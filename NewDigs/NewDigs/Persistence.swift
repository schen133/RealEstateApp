//
//  Persistence.swift
//  NewDigs
//
//  Created by Sifeng Chen on 11/5/22.
//
import Foundation
import CoreData

class Persistence: ObservableObject {
    
    let container = NSPersistentContainer(name: "NewDigs")
    let description = NSPersistentStoreDescription()

    init() {
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
            description.shouldMigrateStoreAutomatically = true
            description.shouldInferMappingModelAutomatically = true
            container.persistentStoreDescriptions =  [description]
    }
}
