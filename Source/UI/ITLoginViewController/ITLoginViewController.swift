//
//  ITLoginViewController.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 01.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

import FacebookLogin
import FacebookCore

import MagicalRecord

class ITLoginViewController: UIViewController {
    
    var user: UserViewModel?
    
    // MARK: -
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = ITDBUser.user() {
            self.user = UserViewModel.init(user: user)
            self.user.map { self.pushViewController($0, animation: false) }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: -
    // MARK: Private
    
    private func pushViewController(_ user: UserViewModel, animation: Bool) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let controller = ITUsersViewController()
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: animation)
    }
    
    @IBAction private func onLoginButtonClicked(_ sender: Any) {
        self.user?.login() { self.pushViewController($0, animation: true) }
    }
}
