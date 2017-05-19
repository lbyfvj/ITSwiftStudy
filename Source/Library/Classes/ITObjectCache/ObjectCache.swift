//
//  ObjectCache.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 17.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

struct ObjectCache<Key: Hashable, Value> {
    
    var keys = [Key]()
    var objectCache = [Key: Value]()
    
    var values: [Value] { return keys.flatMap { self.objectCache[$0] } }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    init() { }
    
    // MARK: -
    // MARK: Public
    
    public func object(for key: Key) -> Value? {
        let object = objectCache[key]
        
        if let object = object {
            return object
        }
        
        return nil
    }
    
    public subscript(key: Key) -> Value? {
        get { return objectCache[key] }
        set(newValue) {
            if let value = newValue {
                if objectCache[key] == nil {
                    keys.append(key)
                }
                
                objectCache[key] = value
            }
        }
    }
}
