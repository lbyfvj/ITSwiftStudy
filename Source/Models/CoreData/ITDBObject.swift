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

public class ITDBObject: NSManagedObject {
    
    var id = ""
    
    // MARK: -
    // MARK: Class Methods
    
    class func managedObject(with ID: String) -> ITDBObject {
        let context = NSManagedObjectContext.mr_default()
        let predicate = NSPredicate(format: "self.id like %@", ID)
        let objects = self
            .mr_findAll(with: predicate, in: context)
            .flatMap { $0.flatMap { $0 as? ITDBObject } }
        
        let result: ITDBObject = objects?.first ?? self.mr_createEntity(in: context) ?? ITDBObject()
        result.id = ID
        
        return result
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

}
