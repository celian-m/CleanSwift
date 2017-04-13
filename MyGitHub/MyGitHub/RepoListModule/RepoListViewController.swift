//
//  RepoListViewController.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol RepoListViewControllerIntents {
    func intentLoadData() -> Observable<String>
    func intentRefreshData() -> Observable<String>
    func display(viewModel : RepoListModel)
}


class AutoAdjustedCollectionview: UICollectionView {
    
}

class FlexibleCollectionViewFlowLayout : UICollectionViewFlowLayout {
    

   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class RepoListViewController: ViewController, RepoListViewControllerIntents, UICollectionViewDelegateFlowLayout {
    
    private let repoList = Variable<[RepositoryEntity]>([])
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet private weak var mTableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    
    
    func intentLoadData() -> Observable<String> {
        return Observable.just("celian-m")
    }
    
    func intentRefreshData() -> Observable<String> {
        return refreshControl.rx.controlEvent(.valueChanged).map({ (_) -> String in
            return "celian-m"
        })
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attach()
        
      //  self.mCollectionView.delegate = self
        self.mTableView.alwaysBounceVertical = true
        let nib = UINib.init(nibName: "RepositoryCollectionViewCell", bundle: nil)
        self.mTableView.register(nib, forCellReuseIdentifier: "project")
        self.mTableView.estimatedRowHeight = 100
        self.mTableView.rowHeight = UITableViewAutomaticDimension
        _ = self.repoList.asObservable().bindTo(mTableView.rx.items(cellIdentifier: "project")) {
            index, model, cell in
            (cell as RepositoryCollectionViewCell).prepare(repository: model)
        }.addDisposableTo(self.bag)

        
        refreshControl.tintColor = UIColor.black
        self.mTableView.addSubview(refreshControl)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func display(viewModel: RepoListModel) {
        print("Render Model")
        self.loadingView.isHidden = !viewModel.isLoading
        self.repoList.value = viewModel.repoList
  //      self.mCollectionView.collectionViewLayout.invalidateLayout()
        self.title = viewModel.controllerName
        if !viewModel.isLoading && self.refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }


    
    
    var presenter : RepoListPresenter!
    


}
