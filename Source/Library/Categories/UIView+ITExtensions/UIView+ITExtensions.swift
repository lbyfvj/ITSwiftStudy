//
//  UIView+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 06.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

public extension UIView {
    
    public class func instantiateFromNibWithView<T: UIView>(viewType: T.Type) -> T? {
        return Bundle
            .main
            .loadNibNamed(String(describing: viewType), owner: nil, options: nil)?
            .first as? T
    }
    
    public class func instantiateFromNib() -> Self? {
        return instantiateFromNibWithView(viewType: self)
    }
    
}
