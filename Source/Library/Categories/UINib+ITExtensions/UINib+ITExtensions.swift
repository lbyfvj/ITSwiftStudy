//
//  UINib+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 08.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
