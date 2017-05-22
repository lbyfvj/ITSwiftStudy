//
//  ITDBObject.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 08.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

import MagicalRecord
import CoreData

protocol Inittable {
    init()
}

public class ITDBObject: NSManagedObject, Inittable {
    
    var id = ""
    
    // MARK: -
    // MARK: Class Methods
    
    class func managedObject<T: Inittable>(with ID: String) -> T
        where
            T: Inittable,
            T: ITDBObject
    {
        let context = NSManagedObjectContext.mr_default()
        let predicate = NSPredicate(format: "self.id like %@", ID)
        let objects = self
            .mr_findAll(with: predicate, in: context)
            .flatMap { $0.flatMap { $0 as? T } }
            ?? []
        
        let result = objects.first ?? T.mr_createEntity(in: context) ?? T()
        result.id = ID
        
        return result
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
