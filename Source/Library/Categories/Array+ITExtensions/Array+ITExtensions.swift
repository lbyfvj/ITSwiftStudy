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
    
    public func object<T>(of type: T.Type) -> T? {
        
        return self.flatMap { $0 as? T }
            .first
    }
    
}
