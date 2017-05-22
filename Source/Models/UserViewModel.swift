//
//  UserViewModel.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 20.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

import FacebookLogin
import FacebookCore

import MagicalRecord
import IDPCastable

import SwiftyJSON

class UserViewModel {
    
    typealias Facebook = Constants.Facebook
    typealias JsonObject = [String : AnyObject]
    
    var user: ITDBUser
    
    var id: String {
        return self.user.id
    }

    var fullName: String {
        return "\(user.firstName ?? "") \(user.lastName ?? "")"
    }
    
    var image: ITDBImage? {
        return self.user.image
    }
    
    var userFriends: [ITDBUser] {
        return (self.user.friends.map(Array.init) ?? [])
            .sorted { lhs, rhs in
                lhs.firstName.flatMap { lhs in
                    rhs.firstName.flatMap { lhs > $0 }
                }
                ?? false
            }
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    init(user: ITDBUser) {
        self.user = user
    }
    
    // MARK: -
    // MARK: Accessors
    
    func graphPath() -> String {
        return "\(self.id)/\(Facebook.friends)"
    }
    
    func requestParameters() -> [String: Any] {
        return [Facebook.fields: "\(Facebook.id), \(Facebook.firstName), \(Facebook.lastName), \(Facebook.largePicture)"]
    }
    
    func graphRequest() -> GraphRequest {
        return GraphRequest(graphPath: self.graphPath(), parameters: self.requestParameters())
    }
    
    // MARK: -
    // MARK: Public
    
    func login(completion: @escaping (_ user: UserViewModel) -> Void) {
        LoginManager().logIn(readPermissions: [ .publicProfile, .userFriends ], viewController: nil) { loginResult in
            switch loginResult {
            case .failed(let error):
                print("FACEBOOK LOGIN FAILED: \(error)")
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                self.completeLogin(accessToken: accessToken) { completion($0) }
            }
        }
    }
    
    func completeLogin(accessToken: AccessToken, completion: @escaping (_ user: UserViewModel) -> Void) {
        MagicalRecord.save({ _ in
            if let user = ITDBUser.mr_createEntity(in: NSManagedObjectContext.mr_default()) {
                if let userId = accessToken.userId {
                    user.id = userId
                }

                completion(self)
            }
        })
    }
    
    func parse(object: JsonObject) -> ITDBUser? {
        print("\(String(describing: type(of: self))) - \(NSStringFromSelector(#function))")
        
        let json = JSON(object as Any)
        let user = json[Facebook.id].string
            .flatMap { ITDBUser.user(with: $0) }
        user?.firstName = json[Facebook.firstName].string
        user?.lastName = json[Facebook.lastName].string
        user?.image = json[Facebook.picture][Facebook.data][Facebook.url].string
            .flatMap { ITDBImage.managedObject(with: $0) as? ITDBImage }
        
        return user
    }
    
    func resultsHandler(_ results: [JsonObject], completion: @escaping () -> Void) {
        print("\(String(describing: type(of: self))) - \(NSStringFromSelector(#function))")
        
        MagicalRecord.save({ _ in
            let friends = results.flatMap(self.parse)
            self.user.friends = Set<ITDBUser>(friends)
        }) { _ in
            completion()
        }
    }
    
    func loadFriends(completion: @escaping () -> Void) {
        print("\(String(describing: type(of: self))) - \(NSStringFromSelector(#function))")
        
        let profileRequest = ITFBProfileRequest(with: self.graphPath(), requestParameters: self.requestParameters())
        let connection = GraphRequestConnection()
        
        connection.add(profileRequest) { response, result in
            switch result {
            case .success(let response):
                response.dictionaryValue
                    .flatMap { cast($0[Facebook.data]) }
                    .flatMap { self.resultsHandler($0) { completion() } }
                
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    
    func failedLoadingData() {
        print("\(String(describing: type(of: self))) - \(NSStringFromSelector(#function))")
    }
    
    func loadUserDetails(with id: String, completion: @escaping () -> Void) {
        let profileRequest = ITFBProfileRequest(with: "/\(id)", requestParameters: self.requestParameters())
        let connection = GraphRequestConnection()
        
        connection.add(profileRequest) { response, result in
            switch result {
            case .success(let response):
                if let responseDictionary = response.dictionaryValue {
                    MagicalRecord.save({ [weak self] _ in
                        if let user = self?.parse(object: responseDictionary as JsonObject) {
                            self?.user = user
                        }
                    }) { _ in
                        completion()
                    }
                }
            case .failed(let error):
                print("Custom Graph Request Failed: \(error)")
            }
        }
        
        connection.start()
    }
    
}
