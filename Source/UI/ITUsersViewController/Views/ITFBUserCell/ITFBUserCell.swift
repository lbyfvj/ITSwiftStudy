//
//  ITFBUserCell.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITFBUserCell: ITTableViewCell {
    
    @IBOutlet var fullNameLabel: UILabel!
    @IBOutlet var userImageView: ITImageView!

    
    // MARK: -
    // MARK: Accessors
    
    var user: ITDBUser? {
        didSet {
            self.fill(withUser: user!)
        }
    }
    
    // MARK: -
    // MARK: Public
    func fill(withUser user: ITDBUser) {
        self.fullNameLabel.text = user.firstName
        //self.userImageView.imageModel = user.picture.imageModel
    }

}
