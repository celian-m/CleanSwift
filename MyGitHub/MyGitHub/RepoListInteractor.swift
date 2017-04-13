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
    
    let repository : GitHubDataRepositoryInterface
    
    func loadData(username : String) ->  Observable<[RepositoryEntity]> {
        return repository.loadData(username).map({ (arrayOfJson) -> [RepositoryEntity] in
            return try RepositoryEntity.from(listJson: arrayOfJson)
        });
    }
}

