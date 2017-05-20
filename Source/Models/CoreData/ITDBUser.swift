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
import IDPCastable

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
    @NSManaged var friends: Set<ITDBUser>?
    @NSManaged var image: ITDBImage?
    
    //@NSManaged var friendsArray: [ITDBUser]
    
    // MARK: -
    // MARK: Class Methods
    
    class func user() -> ITDBUser? {
        let accessToken = AccessToken.current
        
        if accessToken == nil {
            return nil
        }
        
        let user = ITDBUser.managedObject(with: (accessToken?.userId)!)
        
        return user as? ITDBUser
    }
    
    class func user(with id: String) -> ITDBUser? {
        let user = ITDBUser.managedObject(with: id)
        
        return user as? ITDBUser
    }
    
    // MARK: -
    // MARK: Accessors
    
    func fullName() -> String {
        return "\(String(describing: self.firstName ?? "")) \(String(describing: self.lastName ?? ""))"
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
    
    func parse(object: [String : AnyObject]) -> ITDBUser? {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        let user = cast(object[ITConstants.FBConstants.kITId]).flatMap { ITDBUser.user(with: $0) }
        user?.firstName = cast(object[ITConstants.FBConstants.kITFirstName])
        user?.lastName = cast(object[ITConstants.FBConstants.kITLastName])
        
        let imageId = object[ITConstants.FBConstants.kITPicture]
            .flatMap { $0 as? [String: Any] }
            .flatMap { $0[ITConstants.FBConstants.kITData] }
            .flatMap { $0 as? [String: Any] }
            .flatMap { $0[ITConstants.FBConstants.kITURL] }
            .flatMap { $0 as? String }
        
        user?.image = ITDBImage.managedObject(with:imageId ?? "") as? ITDBImage
        
        return user
    }
    
    func resultsHandler(_ results: [[String : AnyObject]]) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")

        MagicalRecord.save({ _ in
            let friends = results.flatMap(self.parse)
            self.friends = Set<ITDBUser>(friends)
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
                response.dictionaryValue
                    .flatMap { cast($0[ITConstants.FBConstants.kITData]) }
                    .flatMap { self.resultsHandler($0) }
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    
    func failedLoadingData() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
    }
    
    func login(completion: @escaping (_ user: ITDBUser) -> Void) {
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
                self.completeLogin(accessToken: accessToken) {
                    (result: ITDBUser) in
                    
                    completion(result)
                }
            }
        }
    }
    
    func completeLogin(accessToken: AccessToken, completion: @escaping (_ user: ITDBUser) -> Void) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        
        MagicalRecord.save({ _ in
            let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default())
            if let userId = accessToken.userId {
                user?.id = userId
            }
            
            completion(user!)
        })
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
                        self.firstName = cast(responseDictionary[ITConstants.FBConstants.kITFirstName])
                        self.lastName = cast(responseDictionary[ITConstants.FBConstants.kITLastName])
                        
                        let imageId = responseDictionary[ITConstants.FBConstants.kITPicture]
                            .flatMap { $0 as? [String: Any] }
                            .flatMap { $0[ITConstants.FBConstants.kITData] }
                            .flatMap { $0 as? [String: Any] }
                            .flatMap { $0[ITConstants.FBConstants.kITURL] }
                            .flatMap { $0 as? String }
   
                        self.image = ITDBImage.managedObject(with:imageId ?? "") as? ITDBImage
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
