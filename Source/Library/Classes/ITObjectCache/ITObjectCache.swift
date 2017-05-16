//
//  ITObjectCache.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 04.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITObjectCache/*<Key: Hashable, Value>*/: NSObject {
    
//    typealias Index = Int
//    typealias Element = (key: Key, value: Value)
//    
//    var keys = [Key]()
//    var objCache = [Key: Value]()
//    var values: [Value] { return keys.flatMap { self.objCache[$0] } }
    
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
    
//    init(_ objectCache: ITObjectCache<Key, Value>) {
//        self.keys = objectCache.keys
//        self.objCache = objectCache.objCache
//    }
    
    // MARK: -
    // MARK: Public
    
//    func object<T>(for key: Key) -> T? {
//        let obj = objCache[key]
//        
//        if let obj = obj as? T {
//            return obj
//        }
//        
//        return nil
//    }
//    
//    func addObject(_ object: Element, forKey key: Key) {
//        synchronized(self) {
//            
//        }
//    }
    
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

//extension ITObjectCache: Collection {
//    
//    var startIndex: Index { return 0 }
//    var endIndex: Index { return self.keys.endIndex }
//    
//    func index(after i: Int) -> Int {
//        return i + 1
//    }
//    
//    subscript(key: Key) -> Value? {
//        get { return objCache[key] }
//        set(newValue) {
//            if let value = newValue {
//                if objCache[key] == nil {
//                    keys.append(key)
//                }
//                objCache[key] = value
//            }
//        }
//    }
//}

//extension ITObjectCache: Sequence {
//    typealias Iterator = AnyIterator<Key, Value>
//    
//    func makeIterator() -> Iterator {
//        var iterator = objCache.makeIterator()
//
//        return AnyIterator {
//            return iterator.next()
//        }
//    }
//}
