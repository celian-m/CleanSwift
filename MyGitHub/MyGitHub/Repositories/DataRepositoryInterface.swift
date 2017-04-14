//
//  DataRepositoryInterface.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 13/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

protocol DataRepository {
    func loadData( _ username : String, error : Errors?)  -> Observable<([RepositoryEntity], Errors?)>
}


protocol LocalDataRepository : DataRepository {
    func storeData(elements : [RepositoryEntity])
}

