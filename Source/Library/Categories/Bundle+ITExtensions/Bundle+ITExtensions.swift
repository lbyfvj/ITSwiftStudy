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
    
    class func object<T>(with type: T.Type) -> T? {
        return object(with: type, withOwner: nil)
    }
    
    class func object<T>(with type: T.Type, withOwner owner: Any?) -> T? {
        return object(with: type, withOwner: owner, withOptions: nil)
    }
    
    class func object<T>(
        with type: T.Type,
        withOwner owner: Any?,
        withOptions options: [AnyHashable : Any]? = nil
        ) -> T?
    {
        let name = String(describing: type)
        let objects:[Any]? = self.main.loadNibNamed(name, owner: owner, options: options)
        
        return objects?.object(of: type)
    }
    
}
