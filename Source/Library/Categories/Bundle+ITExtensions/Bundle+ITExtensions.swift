//
//  Bundle+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

public extension Bundle {
    
    // MARK: -
    // MARK: Public
    
    class func object<T>(type: T.Type) -> T? {
        return object(type: type, owner: nil)
    }
    
    class func object<T>(type: T.Type, owner: Any?) -> T? {
        return object(type: type, owner: owner, options: nil)
    }
    
    class func object<T>(
        type: T.Type,
        owner: Any?,
        options: [AnyHashable : Any]? = nil
    )
        -> T?
    {
        let name = String(describing: type)
        let objects = self.main.loadNibNamed(name, owner: owner, options: options) ?? []
        
        return objects.object(of: type)
    }
    
}
