//
//  ITFriendDetailView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 13.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITFriendDetailView: ITView {

    @IBOutlet var firstNameLabel: UILabel?
    @IBOutlet var lastNameLabel: UILabel?
    
    @IBOutlet var userImageView: ITImageView?
    
    var user: ITDBUser? {
        willSet {
            self.loadingViewVisible = true
        }
        didSet {
            self.fill(with: user!)
            self.loadingViewVisible = false
        }
    }
    
    // MARK: -
    // MARK: Private
    
    func fill(with user: ITDBUser) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        self.firstNameLabel?.text = user.firstName
        self.lastNameLabel?.text = user.lastName
        
    }
    
}
