//
//  UINib+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

extension UINib {
    
    // MARK:
    // MARK: Class Methods
    
    class func object(with cls: AnyClass) -> Any {
        return self.object(with: cls,
                         bundle: nil)
    }
    
    class func object(with cls: AnyClass,
                        bundle: Bundle) -> Any
    {
        return self.object(with: cls,
                         bundle: bundle,
                          owner: nil,
                        options: nil)
    }
    
    class func object(with cls: AnyClass,
                        bundle: Bundle,
                         owner: Any,
                       options: NSDictionary) -> Any
    {
//        let nib: UINib? = nib(withClass: cls,
//                                 bundle: bundle)
//        
//        return nib?.object(withClass: cls, with: owner, with: options)
    }
    
}
