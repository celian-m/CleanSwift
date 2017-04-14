//
//  AppDependencies.swift
//  VIPER TODO
//
//  Created by Conrad Stoll on 6/4/14.
//  Copyright (c) 2014 Mutual Mobile. All rights reserved.
//

import Foundation
import UIKit
import RxAlamofire
import Alamofire


class AppDependencies {
  // var listWireframe = ListWireframe()
    
    
    
    init() {
        configureDependencies()
    }
    
    func installRootViewControllerIntoWindow(window: UIWindow) {
        RepoListRouter().presentController(inWindow: window)
    }
    
    func configureDependencies() {
       
    }
}
