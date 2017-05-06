//
//  Array+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

public extension Array {
    
    // MARK: -
    // MARK: Public
    
    public func object(withClass cls: AnyClass) -> Any? {
        for object: Any in self {
            if type(of: object) == cls {
                return object
            }
        }
        
        return nil
    }
    
}
