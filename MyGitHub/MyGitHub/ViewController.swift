//
//  ViewController.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class ViewController : UIViewController {
    
    let bag = DisposeBag()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
}
