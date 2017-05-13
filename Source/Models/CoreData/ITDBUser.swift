//
//  ITDBUser.swift
//  
//
//  Created by Ivan Tsyganok on 01.05.17.
//
//

import Foundation
import CoreData

import FacebookLogin
import FacebookCore

import MagicalRecord

@objc(ITDBUser)
class ITDBUser: ITDBObject {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var friends: NSSet?
    @NSManaged var image: ITDBImage?
    
    var graphRequestConnection: GraphRequestConnection?
    
    //@NSManaged var friendsArray: [ITDBUser]
    
    // MARK: -
    // MARK: Class Methods
    
    class func user() -> ITDBUser? {
        let accessToken = AccessToken.current
        
        if accessToken == nil {
            return nil
        }
        
        let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
        user?.id = (accessToken?.userId)!
        
        return user
    }
    
    class func user(with id: String) -> ITDBUser? {
        
        let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
        user?.id = id
        
        return user
    }
    
    // MARK: -
    // MARK: Accessors
    
    func fullName() -> String {
        return "\(String(describing: self.firstName!)) \(String(describing: self.lastName!))"
    }
    
    func setGraphRequestConnection(_ graphRequestConnection: GraphRequestConnection) {
        self.graphRequestConnection?.cancel()
        self.graphRequestConnection = graphRequestConnection
    }
    
    func accessToken() -> AccessToken? {
        return AccessToken.current
    }
    
    func graphPath() -> String {
        return "\(String(describing: self.id ))/\(kITFriends)"
    }
    
    func requestParameters() -> [String: Any] {
        return [kITFields: "\(kITId), \(kITFirstName), \(kITLastName), \(kITLargePicture)"]
    }
    
    func graphRequest() -> GraphRequest {
        return GraphRequest(graphPath: graphPath(), parameters: requestParameters())
    }
    
    // MARK: -
    // MARK: Public
    
    func saveManagedObject() {
        
        MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
            
        }, completion: {
            (MRSaveCompletionHandler) in
            
        })
    }
    
    func parse(object: [String : Any]) -> ITDBUser {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let user: ITDBUser? = ITDBUser.user(with: object[kITId]! as! String)
        user?.firstName = object[kITFirstName] as? String
        user?.lastName = object[kITLastName] as? String
        
        let pictureJSON = object[kITPicture] as? [String: Any]
        let data = pictureJSON?[kITData] as? [String: Any]
        user?.image = ITDBImage.managedObject(with: (data?[kITURL] as? String)!) as? ITDBImage
        
        return user!
    }
    
    func resultsHandler(_ results: [[String : AnyObject]]) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        for object in results {
            let friend: ITDBUser = self.parse(object: object )
            self.friends = NSSet.init(object: friend)
        }
        
        self.saveManagedObject()
        
        NotificationCenter.default.post(name: .objectDidLoadFriends, object: self, userInfo: nil)
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
            case .failed( _):
                self.failedLoadingData()
            }
        }
        
        graphRequestConnection?.start()
    }
    
    func failedLoadingData() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
    }
    
    func login() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")

        LoginManager().logIn(readPermissions: [ .publicProfile, .userFriends ], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print("Logged in!")
                print("ACCESS TOKEN \(accessToken)")
                self.completeLogin(accessToken: accessToken)
            }
        }
    }
    
    func completeLogin(accessToken: AccessToken) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        MagicalRecord.save({ (_ localContext: NSManagedObjectContext) in
            let user = ITDBUser.mr_createEntity(in: localContext)
            user?.id = accessToken.userId!
        }) { (_ success: Bool, _ error: Error?) in
            NotificationCenter.default.post(name: .objectDidLoadId, object: self, userInfo: nil)
        }
    }
    
}

extension Notification.Name {
    static let objectDidLoadFriends = Notification.Name("objectDidLoadFriends")
    static let objectDidLoadId = Notification.Name("objectDidLoadId")
}
