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
        
        NotificationCenter.default.post(name: .objectDidLoadFriends, object: nil, userInfo: nil)
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
    
}

extension Notification.Name {
    static let objectDidLoadFriends = Notification.Name("objectDidLoadFriends")
}
