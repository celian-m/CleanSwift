//
//  GitHubDataRepository.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 13/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire




struct GitHubDataRepository : DataRepository {
    let manager: SessionManager = container.resolve(SessionManager.self)!
    func loadData(_ username: String, error : Errors?) -> Observable<([RepositoryEntity], Errors?)> {
        if !Reachability.isConnectedToNetwork() {
            return Observable.error(Errors.NoNetwork)
        }
        
        return manager.rx.json(.get, URL(string: "https://api.github.com/users/\(username)/repos")!).map({ (json) -> [Any] in
          
            guard let array = json as? [Any] else { throw Errors.BadWSReturn }
            return array
        }).map({ (arrayOfJson) -> ([RepositoryEntity], Errors?) in
            let entities = try RepositoryEntity.from(listJson: arrayOfJson)
            return (entities, nil)
        })
    }
}
