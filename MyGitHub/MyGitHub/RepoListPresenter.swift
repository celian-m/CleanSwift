//
//  RepoListPresenter.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

struct RepoListModel {
    let controllerName : String?
    let isLoading : Bool?
    let repoList : [RepositoryEntity]?
    let error : Errors
    
    static func loading(username : String) -> RepoListModel {
        return RepoListModel(controllerName: username,
                             isLoading: true,
                             repoList: nil,
                             error : Errors.NoError)
    }
    
    static func data(repos : [RepositoryEntity], error : Errors) -> RepoListModel {
        return RepoListModel(controllerName: nil,
                             isLoading: false,
                             repoList: repos,
                             error : error)
    }
    
    static func error(error : Errors) -> RepoListModel {
        return RepoListModel(controllerName: nil,
                             isLoading: false,
                             repoList: nil,
                             error : error)
    }
    
    
}

class RepoListPresenter {
    
    let bag = DisposeBag()
    let router : RepoListRouter!
    let interactor : RepoListInteractor
    let viewController : RepoListViewControllerIntents!
    
    
    init(router : RepoListRouter, interactor : RepoListInteractor, viewController : RepoListViewControllerIntents) {
        self.router = router
        self.interactor = interactor
        self.viewController = viewController
       
    }
    
    
    func attach() {
        let intentLoad = viewController.intentLoadData()
            .flatMap({ (userName) -> Observable<RepoListModel> in
                return self.loadData(userName)
            })

        
        let refresh = viewController.intentRefreshData()
            .flatMap({ (userName) -> Observable<RepoListModel> in
                return self.reloadData(userName)
            })
            .delay(1, scheduler: MainScheduler.instance)

        
        _ = Observable.merge([intentLoad, refresh]).scan(RepoListModel(controllerName: nil, isLoading: false, repoList: [], error : Errors.NoError), accumulator: { ( accu, newModel) -> RepoListModel in
            

            return RepoListModel(controllerName: newModel.controllerName ?? accu.controllerName,
                                 isLoading: newModel.isLoading ?? accu.isLoading,
                                 repoList: newModel.repoList ?? accu.repoList,
                                 error: newModel.error )

        }).subscribe(onNext: { (model) in
            self.viewController.display(viewModel: model)
        }).addDisposableTo(self.bag)
    }
    
    
    
    func loadData(_ username : String) -> Observable<RepoListModel> {
        return self.reloadData(username).startWith(RepoListModel.loading(username: username))
    }
    
    
    func reloadData(_ username : String) -> Observable<RepoListModel> {
        return self.interactor.loadData(username: username)
            .map({ (repositories, error) -> RepoListModel in
                return RepoListModel.data(repos: repositories, error : error ?? Errors.NoError )
            }).catchError({ (error) -> Observable<RepoListModel> in
                return Observable.just(RepoListModel.error(error: error as? Errors ?? Errors.BadWSReturn))
            })
        
        
    }
    
    

}
