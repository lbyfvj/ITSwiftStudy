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
    
    var user: ITDBUser?
    
    var accessToken: AccessToken? {
        return AccessToken.current
    }
    
    // MARK: -
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = ITDBUser.user()

        if self.user != nil {
            self.pushViewController(user: self.user!, animation: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: -
    // MARK: Private
    
    private func pushViewController(user: ITDBUser, animation: Bool) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let controller = ITUsersViewController()
        controller.user = self.user
        navigationController?.pushViewController(controller, animated: animation)
    }
    
    @IBAction private func onLoginButtonClicked(_ sender: Any) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")

        self.user?.login() { (user:ITDBUser) in
            self.pushViewController(user: user, animation: true)
        }
    }
}
