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
class ITDBUser: ITDBObject {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var friends: NSSet
    @NSManaged var picture: ITDBImage
    
    //@NSManaged var friendsArray: [ITDBUser]
    
    // MARK: -
    // MARK: Accessors
    
    func fullName() -> String {
        return "\(String(describing: self.firstName!)) \(String(describing: self.lastName!))"
    }

    class func user() -> ITDBUser? {
        let accessToken = AccessToken.current
        
        if accessToken == nil {
            return nil
        }
        
        let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
        user?.id = (accessToken?.userId)!
        
        return user
    }
    
    class func user(with id: String) -> ITDBUser? {
        
        let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
        user?.id = id
        
        return user
    }
    
    func saveManagedObject() {
        
        MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
            
        }, completion: {
            (MRSaveCompletionHandler) in
            
        })
    }
    
}
