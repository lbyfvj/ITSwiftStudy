//
//  ITTableViewCell.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITTableViewCell: UITableViewCell {

    // MARK: -
    // MARK: Accessors
    
    func cellReuseIdentifier() -> String {
        return NSStringFromClass(type(of: self))
    }

}
