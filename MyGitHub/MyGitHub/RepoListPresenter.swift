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
    let controllerName : String
    let isLoading : Bool
    let repoList : [RepositoryEntity]
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
        _ = viewController.intentLoadData()
            .flatMap({ (userName) -> Observable<RepoListModel> in
                return self.loadData(userName)
            }).subscribe(onNext: { (model) in
                self.viewController.display(viewModel: model)
            }).addDisposableTo(self.bag)
        
        
        _ = viewController.intentRefreshData()
            .flatMap({ (userName) -> Observable<RepoListModel> in
                return self.reloadData(userName)
            })
            .delay(1, scheduler: MainScheduler.instance)
            .subscribe(onNext: { (model) in
                self.viewController.display(viewModel: model)
            }).addDisposableTo(self.bag)
        
    }
    
    
    
    func loadData(_ username : String) -> Observable<RepoListModel> {
        return self.reloadData(username).startWith(RepoListModel(controllerName : username, isLoading: true, repoList : []))
    }
    
    
    func reloadData(_ username : String) -> Observable<RepoListModel> {
        return self.interactor.loadData(username: username)
            .map({ repositories -> RepoListModel in

                return RepoListModel(controllerName : username, isLoading: false, repoList : repositories)
            })
            .catchErrorJustReturn(RepoListModel(controllerName : username, isLoading : false, repoList : []))
        
    }
    
    

}
