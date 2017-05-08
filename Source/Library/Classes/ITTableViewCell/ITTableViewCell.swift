//
//  ITTableViewCell.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    
    // MARK: -
    // MARK: Accessors
    
    func identifier() -> String {
        return type(of: self).defaultReuseIdentifier
    }
    
    func nib() -> String {
        return type(of: self).nibName
    }

}
