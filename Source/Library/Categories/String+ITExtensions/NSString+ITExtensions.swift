//
//  NSString+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 05.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

public extension String {
    
    public func alphanumeriPercentEncoded() -> String {
        let alphanumericCharacterSet = CharacterSet.alphanumerics
        
        return self.addingPercentEncoding(withAllowedCharacters: alphanumericCharacterSet)!
    }
}
