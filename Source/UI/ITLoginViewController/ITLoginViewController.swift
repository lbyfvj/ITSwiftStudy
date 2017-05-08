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
    
    // MARK: -
    // MARK: Private
    
    func pushViewController(user: ITDBUser, animation: Bool) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let controller = ITUsersViewController()
        controller.user = user
        navigationController?.pushViewController(controller, animated: animation)
    }
    
    @IBAction func onLoginButtonClicked(_ sender: Any) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        if (self.accessToken()?.userId != nil) {
            completeLogin(accessToken: self.accessToken()!)
        }
        else {
            loginAtFacebook()
        }
    }
    
    func accessToken() -> AccessToken? {
        return AccessToken.current
    }
    
    func loginAtFacebook() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let loginManager = LoginManager()
        print("LOGIN MANAGER: \(loginManager)")
        loginManager.logIn(readPermissions: [ .publicProfile, .userFriends ], viewController: self) { loginResult in
            print("LOGIN RESULT! \(loginResult)")
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                print("Logged in!")
                print("GRANTED PERMISSIONS: \(grantedPermissions)")
                print("DECLINED PERMISSIONS: \(declinedPermissions)")
                print("ACCESS TOKEN \(accessToken)")
                self.completeLogin(accessToken: accessToken)
            }
        }
    }
    
    func completeLogin(accessToken: AccessToken) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        MagicalRecord.save({ (_ localContext: NSManagedObjectContext) in
            self.user = ITDBUser.mr_createEntity(in: localContext)
            self.user?.id = accessToken.userId!
        }) { (_ success: Bool, _ error: Error?) in
            self.pushViewController(user: self.user!, animation: true)
        }
    }
    
    // MARK: -
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = ITDBUser.user()
        
        if user != nil {
            self.pushViewController(user: user!, animation: false)
        }        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
