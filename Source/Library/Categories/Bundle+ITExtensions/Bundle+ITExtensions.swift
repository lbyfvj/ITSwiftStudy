//
//  Bundle+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

extension Bundle {
    
    // MARK: -
    // MARK: Public
    
    class func object(withClass cls: AnyClass) -> Any {
        return object(withClass: cls, withOwner: Optional.none!)
    }
    
    class func object(withClass cls: AnyClass, withOwner owner: Any) -> Any {
        return object(withClass: cls, withOwner: owner, withOptions: Optional.none!)
    }
    
    class func object(withClass cls: AnyClass, withOwner owner: Any, withOptions options: NSDictionary) -> Any {
        let objects: [Any] = self.main.loadNibNamed(NSStringFromClass(cls), owner: owner, options: options as? [AnyHashable : Any])!
        
        return objects.object(withClass: cls) as Any
    }
    
}
