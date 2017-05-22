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
import IDPCastable

let kITLogoutButtonTitle = "Logout"

class ITUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: UserViewModel?
 
    var usersView: ITUsersView? {
        return cast(self.viewIfLoaded)
    }
    
    // MARK: -
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersView = self.usersView
        
        usersView?.tableView?.register(ITFBUserCell.self)
        
        let navigationItem = self.navigationItem
        let logoutButton = UIBarButtonItem(title: kITLogoutButtonTitle, style: .plain, target: self, action: #selector(self.onLogOutButtonClicked))
        navigationItem.setLeftBarButton(logoutButton, animated: true)
        
        self.user?.loadFriends() { self.usersView?.tableView?.reloadData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    // MARK: Private
    
    @IBAction func onLogOutButtonClicked(_ sender: Any) {
        LoginManager().logOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: -
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.user
            .flatMap { $0.userFriends }?
            .count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITFBUserCell = tableView.dequeueReusableCell(forIndexPath: indexPath as NSIndexPath)
        if let user = self.user?.userFriends[indexPath.row] {
            cell.fill(with: user)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = ITFriendDetailViewController()
        if let friend = self.user?.userFriends[indexPath.row] {
            controller.friend = friend
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
