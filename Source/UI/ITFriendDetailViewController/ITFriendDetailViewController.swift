//
//  ITFriendDetailViewController.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 13.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITFriendDetailViewController: UIViewController {
    
    var friendDetailView: ITFriendDetailView? {
        if isViewLoaded && (view is ITFriendDetailView) {
            return (view as? ITFriendDetailView)!
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.objectDidUpdateDetails(_:)), name: .objectDidUpdateDetails, object: self.friend)
              
        self.loadFriendDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    // MARK: Private
    
    private func loadFriendDetails() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        self.friend?.loadFriendDetails(with: (self.friend?.id)!)
    }
    
    // MARK: -
    // MARK: NSNotification
    
    @objc private func objectDidUpdateDetails(_ notification: NSNotification) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        self.friendDetailView?.friend = self.friend
    }
}
