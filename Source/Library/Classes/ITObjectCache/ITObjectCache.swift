//
//  ITObjectCache.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 04.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITObjectCache: NSObject {
    
    var objectCache: NSMapTable<AnyObject, AnyObject>
    
    // MARK: -
    // MARK: Class methods
    
    class func cache() -> ITObjectCache {
        let object = DispatchQueue.once { self.init() }
        
        return object
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations

    required override init() {
        self.objectCache = NSMapTable.strongToWeakObjects()
    }
    
    // MARK: -
    // MARK: Public
    
    func object(for key: AnyObject) -> AnyObject {        
        return synchronized(self) {
            self.objectCache.object(forKey: key as AnyObject)
        } as AnyObject
    }
    
    func addObject(_ object: Any, forKey key: AnyObject) {
        synchronized(self) {
            self.objectCache.setObject(object as AnyObject, forKey: key as AnyObject)
        }
    }
    
    func removeValue(for key: String) {
        synchronized(self) {
            self.objectCache.setNilValueForKey(key)
        }
    }
    
    func containsObject(for key: AnyObject) -> Bool {
        return self.object(for: key).boolValue
    }
    
    func count() -> Int {
        return synchronized(self) { self.objectCache.count }
    }
}
