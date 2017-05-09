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

class ITUsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: ITDBUser?
    var graphRequestConnection: GraphRequestConnection?
    
    var usersView: ITUsersView? {
        if isViewLoaded && (view is ITUsersView) {
            return (view as? ITUsersView)!
        }
        
        return nil
    }
    
    // MARK: -
    // MARK: Accessors
    
    
    // MARK: -
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usersView = self.usersView
        
        usersView?.tableView.register(ITFBUserCell.self)
        
        let navigationItem: UINavigationItem? = self.navigationItem
        let logoutButton = UIBarButtonItem(title: kITLogoutButtonTitle, style: .plain, target: self, action: #selector(self.onLogOutButtonClicked))
        navigationItem?.setLeftBarButton(logoutButton, animated: true)
        
        self.user?.loadFriends()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.objectDidLoadFriends(_:)), name: .objectDidLoadFriends, object: nil)
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
        return self.user!.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITFBUserCell = tableView.dequeueReusableCell(forIndexPath: indexPath as NSIndexPath)
        let userFriends = (self.user!.friends.allObjects as! [ITDBUser]).sorted { $0.firstName! < $1.firstName! }
        let user: ITDBUser? = userFriends[indexPath.row]
        cell.fill(withUser: user!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = ITFBFriendViewController()
//        controller.user = friends[indexPath.row]
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func objectDidLoadFriends(_ notification: NSNotification) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
         self.usersView?.tableView.reloadData()
    }
    
}
