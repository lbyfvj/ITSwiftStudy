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
        
        return AccessToken.current
            .flatMap { $0.userId }
            .map(self.managedObject)
    }
    
    class func user(with id: String) -> ITDBUser? {
        return self.managedObject(with: id)
    }
    
}
