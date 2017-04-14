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
    
  //  let manager = SessionManager.default
    
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        return SessionManager(configuration: configuration)
    }()
    
    func loadData(_ username: String) -> Observable<[RepositoryEntity]> {
 //     manager.session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        
        return manager.rx.json(.get, URL(string: "https://api.github.com/users/\(username)/repos")!).map({ (json) -> [Any] in
            
            guard let array = json as? [Any] else {
                throw Errors.BadWSReturn
            }
            print(array.count)
            
            return array
        }).map({ (arrayOfJson) -> [RepositoryEntity] in
            let entities = try RepositoryEntity.from(listJson: arrayOfJson)
            return entities
        })
    }
}
