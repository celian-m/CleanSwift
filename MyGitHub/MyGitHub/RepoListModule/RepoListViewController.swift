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
import RxGesture

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
    var presenter : RepoListPresenter!
    
    
    @IBOutlet private weak var mTableView: UITableView!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    
    var userName = Variable<String>("celian-m")
    
    func intentLoadData() -> Observable<String> {
        return Observable.just("celian-m")
    }
    
    func intentRefreshData() -> Observable<String> {
        
        
        
        let refreshIntent =  refreshControl.rx.controlEvent(.valueChanged).map({ (_) -> String in
            return self.userName.value
        })
        
        return Observable.merge([refreshIntent, userName.asObservable()])
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
        
        
//        let title = self.navigationController?.navigationItem.titleView
//        
//        
        let gesture = mTableView.rx.tapGesture().subscribe(onNext: { (_) in
            let controller = UIAlertController(title: "UserName", message: "Provide Username", preferredStyle: UIAlertControllerStyle.alert)
            controller.addTextField(configurationHandler: { (field) in
                field.placeholder = "username"
            })
            controller.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                self.userName.value = controller.textFields?[0].text ?? ""
            }))
            controller.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in
                
            }))
            
            self.present(controller, animated: true, completion: nil)
            
        })
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func display(viewModel: RepoListModel) {
        print("Render Model \(viewModel.error)")
        
        self.loadingView.isHidden = !viewModel.isLoading!
        self.repoList.value = viewModel.repoList!
        
        self.title = viewModel.controllerName
        if !((viewModel.isLoading)!) && self.refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        switch viewModel.error {
        case .NoNetwork:
            self.errorLabel.text = "No Network"
            break
        default:
            self.errorLabel.text = nil
        }
    }
    
    
    
    
    
    
    
    
}
