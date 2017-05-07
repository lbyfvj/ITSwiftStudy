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
    
    func setGraphRequestConnection(_ graphRequestConnection: GraphRequestConnection) {
        self.graphRequestConnection?.cancel()
        self.graphRequestConnection = graphRequestConnection
    }
    
    func accessToken() -> AccessToken? {
        return AccessToken.current
    }
    
    func graphPath() -> String {
        return "\(user!.id ?? "")/\(kITFriends)"
    }
    
    func requestParameters() -> [String: Any] {
        return [kITFields: "\(kITId), \(kITFirstName), \(kITLastName), \(kITLargePicture)"]
    }
    
    func graphRequest() -> GraphRequest {
        return GraphRequest(graphPath: graphPath(), parameters: requestParameters())
    }
    
    // MARK: -
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.usersView?.tableView.registerReusableCell(ITFBUserCell.self)
        
        let navigationItem: UINavigationItem? = self.navigationItem
        let logoutButton = UIBarButtonItem(title: kITLogoutButtonTitle, style: .plain, target: self, action: #selector(self.onLogOutButtonClicked))
        navigationItem?.setLeftBarButton(logoutButton, animated: true)
        
        loadFriends()
        
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
    
    func parse(object: [String : AnyObject]) -> ITDBUser {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let user: ITDBUser? = ITDBUser.user(with: object[kITId]! as! String)
        user?.firstName = object[kITFirstName] as? String
        user?.lastName = object[kITLastName] as? String
        //user?.picture = ITDBImage.managedObject(withID: object[kITPicture][kITData][kITURL])
        
        return user!
    }
    
    func resultsHandler(_ results: [[String : AnyObject]]) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        for object in results {
            let friend: ITDBUser = self.parse(object: object )
                //user?.friends.append(friend)
            user?.friends = NSSet.init(object: friend)
        }
        
        user?.saveManagedObject()
        
        self.usersView?.tableView.reloadData()
    }
    
    func loadFriends() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")

        graphRequestConnection = GraphRequestConnection()
        graphRequestConnection?.add(graphRequest()) { httpResponse, result in
            switch result {
            case .success(let response):
                if let responseDictionary = response.dictionaryValue {
                    print(responseDictionary)
                    if let dictianary = responseDictionary[kITData] as? [[String : AnyObject]] {
                        self.resultsHandler(dictianary)
                    }
                }
            case .failed(let error):
                print("Graph Request Failed: \(error)")
                self.failedLoadingData()
            }
        }
            
        graphRequestConnection?.start()
    }
    
    func failedLoadingData() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
    }
    
    // MARK: -
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Friends count: \(String(describing: self.user?.friends.count))")
        return self.user!.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ITFBUserCell = tableView.dequeueReusableCell(indexPath: indexPath as NSIndexPath) as ITFBUserCell
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
    
}
