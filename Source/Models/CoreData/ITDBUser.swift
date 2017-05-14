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

struct ITFBProfileRequest: GraphRequestProtocol {
    struct Response: GraphResponseProtocol {
        let rawResponse: Any?
        
        public init(rawResponse: Any?) {
            self.rawResponse = rawResponse
        }
        
        public var dictionaryValue: [String : Any]? {
            return rawResponse as? [String : Any]
        }
        
        public var arrayValue: [Any]? {
            return rawResponse as? [Any]
        }
        
        public var stringValue: String? {
            return rawResponse as? String
        }
    }
    
    var graphPath: String
    var parameters: [String : Any]?
    var accessToken = AccessToken.current
    var httpMethod: GraphRequestHTTPMethod = .GET
    var apiVersion: GraphAPIVersion = .defaultVersion
    
    init(with graphPath:String, requestParameters: [String : Any]) {
        self.graphPath = graphPath
        self.parameters = requestParameters
    }
}

@objc(ITDBUser)
class ITDBUser: ITDBObject {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var friends: NSSet?
    @NSManaged var image: ITDBImage?
    
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
    
    func accessToken() -> AccessToken? {
        return AccessToken.current
    }
    
    func graphPath() -> String {
        return "\(String(describing: self.id ))/\(ITConstants.FBConstants.kITFriends)"
    }
    
    func requestParameters() -> [String: Any] {
        return [ITConstants.FBConstants.kITFields: "\(ITConstants.FBConstants.kITId), \(ITConstants.FBConstants.kITFirstName), \(ITConstants.FBConstants.kITLastName), \(ITConstants.FBConstants.kITLargePicture)"]
    }
    
    func graphRequest() -> GraphRequest {
        return GraphRequest(graphPath: graphPath(), parameters: requestParameters())
    }
    
    // MARK: -
    // MARK: Public
    
    func parse(object: [String : Any]) -> ITDBUser {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let user: ITDBUser? = ITDBUser.user(with: object[ITConstants.FBConstants.kITId]! as! String)
        user?.firstName = object[ITConstants.FBConstants.kITFirstName] as? String
        user?.lastName = object[ITConstants.FBConstants.kITLastName] as? String
        
        let pictureJSON = object[ITConstants.FBConstants.kITPicture] as? [String: Any]
        let data = pictureJSON?[ITConstants.FBConstants.kITData] as? [String: Any]
        user?.image = ITDBImage.managedObject(with: (data?[ITConstants.FBConstants.kITURL] as? String)!) as? ITDBImage
        
        return user!
    }
    
    func resultsHandler(_ results: [[String : AnyObject]]) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")

        MagicalRecord.save({ _ in
            for object in results {
                let friend: ITDBUser = self.parse(object: object )
                self.friends = NSSet.init(object: friend)
            }
        }) { _ in
            NotificationCenter.default.post(name: .objectDidLoadFriends, object: self, userInfo: nil)
        }
    }
    
    func loadFriends() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
 
        let profileRequest = ITFBProfileRequest(with: self.graphPath(), requestParameters: self.requestParameters())
        let connection = GraphRequestConnection()
        
        connection.add(profileRequest) { response, result in
            switch result {
            case .success(let response):
                print("Custom Graph Request Succeeded: \(response)")
                if let responseDictionary = response.dictionaryValue {
                    if let dictionary = responseDictionary[ITConstants.FBConstants.kITData] as? [[String : AnyObject]] {
                        self.resultsHandler(dictionary)
                    }
                }
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
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
        
        MagicalRecord.save({ _ in
            let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
            user?.id = accessToken.userId!
        }) { _ in
            NotificationCenter.default.post(name: .objectDidLoadId, object: self, userInfo: nil)
        }
    }
    
    func loadFriendDetails(with id: String) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let profileRequest = ITFBProfileRequest(with: "/\(id)", requestParameters: self.requestParameters())
        let connection = GraphRequestConnection()
        
        connection.add(profileRequest) { response, result in
            switch result {
            case .success(let response):
                if let responseDictionary = response.dictionaryValue {
                    MagicalRecord.save({ _ in
                        self.firstName = responseDictionary[ITConstants.FBConstants.kITFirstName] as? String
                        self.lastName = responseDictionary[ITConstants.FBConstants.kITLastName] as? String
                        
                        let pictureJSON = responseDictionary[ITConstants.FBConstants.kITPicture] as? [String: Any]
                        let data = pictureJSON?[ITConstants.FBConstants.kITData] as? [String: Any]
                        self.image = ITDBImage.managedObject(with: (data?[ITConstants.FBConstants.kITURL] as? String)!) as? ITDBImage
                    }) { _ in
                        NotificationCenter.default.post(name: .objectDidUpdateDetails, object: self, userInfo: nil)
                    }
                }
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    
}

extension Notification.Name {
    static let objectDidLoadFriends = Notification.Name("objectDidLoadFriends")
    static let objectDidLoadId = Notification.Name("objectDidLoadId")
    static let objectDidUpdateDetails = Notification.Name("objectDidUpdateDetails")
}
