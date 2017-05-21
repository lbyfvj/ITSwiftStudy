//
//  ITFBUserCell.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 03.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITFBUserCell: ITTableViewCell {
    
    @IBOutlet var fullNameLabel: UILabel?
    @IBOutlet var userImageView: ITImageView?
    
    // MARK: -
    // MARK: Public
    
    func fill(with user: ITDBUser) {
        let userViewModel = UserViewModel.init(user: user)
        self.fullNameLabel?.text = userViewModel.fullName
        self.userImageView?.imageModel = userViewModel.image?.imageModel
    }

}
