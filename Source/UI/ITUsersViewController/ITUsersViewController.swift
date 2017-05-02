//
//  ITUsersViewController.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 02.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

import FacebookLogin
import FacebookCore

let kITLogoutButtonTitle = "Logout"

class ITUsersViewController: UIViewController {
    
    var user:       ITDBUser?
    var friends:    Array<Any>?
    
    // MARK: -
    // MARK: Private
    
    @IBAction func onLogOutButtonClicked(_ sender: Any) {
        LoginManager().logOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadFriends() {

    }
    
    // MARK: -
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationItem: UINavigationItem? = self.navigationItem
        let logoutButton = UIBarButtonItem(title: kITLogoutButtonTitle, style: .plain, target: self, action: #selector(self.onLogOutButtonClicked))
        navigationItem?.setLeftBarButton(logoutButton, animated: true)
        
        loadFriends()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: -
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reusableCell(with: ITFBUserCell.self)
        let user: ITDBUser? = friends[indexPath.row]
        //cell.fill(withUserModel: user)
        return cell as! ITFBUserCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = ITFBFriendViewController()
//        controller.user = friends[indexPath.row]
//        navigationController?.pushViewController(controller, animated: true)
    }
    
}
