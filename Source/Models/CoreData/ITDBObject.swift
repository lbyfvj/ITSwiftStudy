//
//  ITDBObject.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 08.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

import MagicalRecord

public class ITDBObject: NSManagedObject {
    
    var id: String = ""
    
    // MARK: -
    // MARK: Class Methods
    
    class func managedObject(with ID: String) -> ITDBObject {
        let predicate = NSPredicate(format: "self.id like %@", ID)
        let objects: [ITDBObject] = self.mr_findAll(with: predicate)! as! [ITDBObject]

        if objects.count > 0 {
            return objects.first!
        }
        
        let object: ITDBObject? = self.mr_createEntity()
        object?.id = ID
        
        return object!
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    // MARK: -
    // MARK: Accessors
    
//    func setID(_ ID: String) {
//        
//    }
//    
//    func id() -> String {
//        return customValue(forKey: kITId)
//    }
//    
//    func removeID(_ ID: String) {
//        
//    }

}
