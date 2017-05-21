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
import IDPCastable

@objc(ITDBUser)
class ITDBUser: ITDBObject {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var friends: Set<ITDBUser>?
    @NSManaged var image: ITDBImage?
    
    // MARK: -
    // MARK: Class Methods
    
    class func user() -> ITDBUser? {
        if let accessToken = AccessToken.current {
            let user = ITDBUser.managedObject(with: accessToken.userId ?? "")
            
            return user as? ITDBUser
        }

        return nil
    }
    
    class func user(with id: String) -> ITDBUser? {
        let user = ITDBUser.managedObject(with: id)
        
        return user as? ITDBUser
    }
    
}
