//
//  MyGitHubTests.swift
//  MyGitHubTests
//
//  Created by Célian MOUTAFIS on 12/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import XCTest
import RxSwift
@testable import MyGitHub

class RepoListTests: XCTestCase {
    
    let interactor = RepoListInteractor(repository: GitHubDataRepository())

    
    func testLoadDataNotEmpty() {
        
        let expectation = self.expectation(description: "getting repos")
        
        _ = interactor.loadData(username: "celian-m").catchError({ (error) -> Observable<[RepositoryEntity]> in
            XCTFail(error.localizedDescription)
            return Observable.just([])
        })
            .subscribe(onNext: { (entities) in
                XCTAssertGreaterThan(entities.count, 0 ,"Should have found repository")
                expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 50)
    }
    
    
    
    
    
    
    

}
