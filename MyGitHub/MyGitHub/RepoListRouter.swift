//
//  RepoListRouter.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation
import UIKit



struct RepoListRouter  {
    
    func presentController(inWindow window : UIWindow) {
        let navigationController = window.rootViewController as! UINavigationController
        let vc = self.instantiateController()
        navigationController.setViewControllers([vc], animated: false)
       
    }
    
    func instantiateController() -> RepoListViewController {
        let controller = UIStoryboard.main().instantiateViewController(withIdentifier: "RepoListViewController") as! RepoListViewController
        
        
        
        let repository = GitHubDataRepository()
        let interactor = RepoListInteractor(repository : repository)
        
        let presenter = RepoListPresenter(router: self, interactor: interactor, viewController: controller)
        controller.presenter = presenter

        return controller
    }
    
}
