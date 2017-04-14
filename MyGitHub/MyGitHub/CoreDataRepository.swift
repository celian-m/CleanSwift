//
//  CoreDataRepository.swift
//  MyGitHub
//
//  Created by Célian MOUTAFIS on 13/04/2017.
//  Copyright © 2017 mouce. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire
import CoreData


struct CoreDataCore {
    
    static var sharedInstance = CoreDataCore()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MyGitHub")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    
    init() {
        
    }
}


struct CoreDataRepository : LocalDataRepository {
    func loadData(_ username: String) -> Observable<[RepositoryEntity]>  {
        let results : NSFetchRequest<Repository> = Repository.fetchRequest()
       
        do {
           let repos =  try  CoreDataCore.sharedInstance.persistentContainer.viewContext.fetch(results)
           print(repos)
            return Observable.just( repos.map({ (repository) -> RepositoryEntity in
                return RepositoryEntity(name: repository.cName!, description: "CD", language: nil, owner: "")
            }))
        } catch {
            print(error)
        }
        return Observable.just([])
    }
    
    func storeData(elements: [RepositoryEntity]) {
        
        let results : NSFetchRequest<Repository> = Repository.fetchRequest()
        let repos =  try? CoreDataCore.sharedInstance.persistentContainer.viewContext.fetch(results)
        
        for repo in repos ?? [] {
            CoreDataCore.sharedInstance.persistentContainer.viewContext.delete(repo)
        }
        
        for aRepo in elements {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "Repository", into: CoreDataCore.sharedInstance.persistentContainer.viewContext) as! Repository
            entity.cName = aRepo.name
        }
        
       _ =  try? CoreDataCore.sharedInstance.persistentContainer.viewContext.save()
        
    }
}
