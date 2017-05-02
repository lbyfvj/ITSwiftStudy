//
//  UITableView+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell(with cls: AnyClass) -> Any {
        return dequeueReusableCell(withIdentifier: NSStringFromClass(cls))!
    }
    
    func reusableCell(with cls: AnyClass) -> Any {
        var cell: Any? = dequeueReusableCell(with: cls)
        if cell == nil {
            cell = UINib.object(withClass: cls)
        }
        return cell!
    }
    
}
