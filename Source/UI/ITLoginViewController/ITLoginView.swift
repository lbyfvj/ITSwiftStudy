//
//  ITLoginView.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 01.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit
import FacebookLogin

let kITLoginButtonTitle = "Login with Facebook"

class ITLoginView: UIView {
    
    @IBOutlet var loginButton: UIButton!
    
    override func awakeFromNib() {
        
//        self.loginButton = LoginButton(readPermissions: [ .publicProfile, .userFriends ])
//        loginButton.center = center
//        
//        self.addSubview(loginButton)
        
        let loginButton: UIButton = self.loginButton
        loginButton.backgroundColor = UIColor(red: CGFloat(0.26), green: CGFloat(0.40), blue: CGFloat(0.70), alpha: CGFloat(1.0))
        loginButton.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(180), height: CGFloat(40))
        loginButton.center = center
        loginButton.layer.cornerRadius = 5.0
        loginButton.setTitle(kITLoginButtonTitle, for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        
        self.addSubview(loginButton)
    }

}
