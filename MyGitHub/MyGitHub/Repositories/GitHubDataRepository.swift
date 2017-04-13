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

protocol GitHubDataRepositoryInterface {
    func loadData( _ username : String) -> Observable<[Any]>
}


struct GitHubDataRepository : GitHubDataRepositoryInterface {
    func loadData(_ username: String) -> Observable<[Any]> {
        return RxAlamofire.requestJSON(.get, URL(string: "https://api.github.com/users/\(username)/repos")!).map({ (response, json) -> [Any] in
            print(json)
            guard let array = json as? [Any] else {
                throw Errors.BadWSReturn
            }
            return array
        })
        
    }

    
}
