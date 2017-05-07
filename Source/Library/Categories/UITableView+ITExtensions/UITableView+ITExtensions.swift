//
//  UITableView+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nib: UINib? { return nil }
}

extension UITableView {
    
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: Reusable, T: Reusable {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: NSIndexPath) -> T where T: Reusable, T: Reusable {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath as IndexPath) as! T
    }
    
    func dequeueReusableCell(with cls: AnyClass) -> Any {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(cls))!
    }
    
    func reusableCell(with cls: AnyClass) -> Any {
        var cell: Any? = dequeueReusableCell(with: cls)
        if cell == nil {
            cell = UINib.object(with: cls)
        }
        
        return cell!
    }
    
}
