//
//  ITFriendDetailViewController.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 13.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

import IDPCastable

class ITFriendDetailViewController: UIViewController {
    
    // TEMP. with return cast(self.isViewLoaded) works incorrect. The view doesn't load.
    var friendDetailView: ITFriendDetailView? {
        if self.isViewLoaded && (view is ITFriendDetailView) {
            return self.view as? ITFriendDetailView
        }
        
        return nil
    }
        
    var friend: ITDBUser? {
        didSet {
            if self.isViewLoaded {
                self.friendDetailView?.friend = friend
            }
        }
    }
    
    // MARK: -
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
              
        self.loadFriendDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    // MARK: Private
    
    private func loadFriendDetails() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        self.friend?.loadFriendDetails(with: self.friend?.id ?? "") {
            self.friendDetailView?.friend = self.friend
        }
    }
    
}
