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
    
    var friend: ITDBUser? {
        willSet { self.loadingViewVisible = true }
        didSet {
            self.fill(with: friend!)
            self.loadingViewVisible = false
        }
    }
    
    // MARK: -
    // MARK: Private
    
    func fill(with friend: ITDBUser) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        self.firstNameLabel?.text = friend.firstName
        self.lastNameLabel?.text = friend.lastName
        self.userImageView?.imageModel = friend.image?.imageModel
        
    }
    
}
