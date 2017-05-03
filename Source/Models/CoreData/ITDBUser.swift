//
//  ITDBUser.swift
//  
//
//  Created by Ivan Tsyganok on 01.05.17.
//
//

import Foundation
import CoreData

import FacebookLogin
import FacebookCore

import MagicalRecord

@objc(ITDBUser)
public class ITDBUser: NSManagedObject {
    
    @NSManaged var id: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var friends: Array<Any>?

    class func user() -> ITDBUser? {
        let accessToken = AccessToken.current
        
        if accessToken == nil {
            return nil
        }
        
        let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
        user?.id = accessToken?.userId
        
        return user
    }
    
    class func user(with id: String) -> ITDBUser? {
        
        let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
        user?.id = id
        
        return user
    }
    
    func saveManagedObject() {
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext) in
            
        })
    }
    
}
