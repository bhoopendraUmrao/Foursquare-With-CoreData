//
//  CoreDataManager.swift
//  MVVM Sqlite
//
//  Created by Bhoopendra  on 30/07/19.
//  Copyright © 2019 Bhoopendra . All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum Entity:String{
    case VenueCoreData
    case LocationCoreData
}


class CoreDataManager{
    static let shared = CoreDataManager()
    
    var context:NSManagedObjectContext?{
        return getContext()
    }
    private init(){
        
    }
    private func getContext()-> NSManagedObjectContext?{
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{return nil}
        return appdelegate.persistentContainer.viewContext
    }
    
    func clearStorage(forEntity:String) {
        
        // Parse JSON data
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: forEntity)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func fetchDataForEntity<T:NSManagedObject>(forEntity entity:Entity,wherePredicate:NSPredicate? = nil,sortDescriptor:[NSSortDescriptor] = [])-> [T]?{
        let managedObjectContext = context
        let fetchRequest = NSFetchRequest<T>(entityName: entity.rawValue)
        fetchRequest.sortDescriptors = sortDescriptor
        fetchRequest.predicate = wherePredicate
        do {
            let users = try managedObjectContext?.fetch(fetchRequest)
            return users
        } catch let error {
            print(error)
            return nil
        }
    }
}

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "container")
}
