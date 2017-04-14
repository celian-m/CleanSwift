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
    func loadData(username : String) ->  Observable<[RepositoryEntity]> {
        return repository.loadData(username).do(onNext: { (listRepo) in
                self.localStorageRepositoty.storeData(elements: listRepo)
        }).catchError({ (error) -> Observable<[RepositoryEntity]> in
            print(error)
            
            return self.localStorageRepositoty.loadData(username).do(onNext: { (repositories) in
                if (repositories.count == 0){
                    throw error
                }
            })
        })
    }
}

