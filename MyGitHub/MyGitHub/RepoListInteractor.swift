//
//  RepoListInteractor.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation


import RxSwift


struct RepoListInteractor {
    
    let repository : DataRepository
    let localStorageRepositoty = CoreDataRepository()
    func loadData(username : String) ->  Observable<([RepositoryEntity], Errors?)> {
        return repository.loadData(username, error : nil)
            .catchError({ (error) -> Observable<([RepositoryEntity], Errors?)> in
            
            if let error = error as? Errors {
                return self.localStorageRepositoty.loadData(username, error: error)
            } else{
                return self.localStorageRepositoty.loadData(username, error: Errors.BadWSReturn)
            }
        }).do(onNext: { (repos, error) in
            if error == nil {
                self.localStorageRepositoty.storeData(elements: repos)
            }
        })
    }
}

