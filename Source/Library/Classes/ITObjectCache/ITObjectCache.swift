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
        let object = DispatchQueue.onceReturn { self.init() }
        
        return object as! ITObjectCache
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations

    required override init() {
        self.objectCache = NSMapTable.strongToWeakObjects()
    }
    
    // MARK: -
    // MARK: Public
    
    func object(for key: AnyObject) -> AnyObject {
        let object = DispatchQueue(label: "self").sync {
            self.objectCache.object(forKey: key as AnyObject)
        }
        
        return object as AnyObject
    }
    
    func addObject(_ object: Any, forKey key: AnyObject) {
        DispatchQueue(label: "self").sync {
            self.objectCache.setObject(object as AnyObject, forKey: key as AnyObject)
        }
    }
    
    func removeValue(for key: String) {
        DispatchQueue(label: "self").sync {
            self.objectCache.setNilValueForKey(key)
        }
    }
    
    func containsObject(for key: AnyObject) -> Bool {
        
        if self.object(for: key).boolValue {
            return true
        }
      
        return false
    }
    
    func count() -> Int {
        let count = DispatchQueue(label: "self").sync {
            self.objectCache.count
        }
        
        return count
    }
}
