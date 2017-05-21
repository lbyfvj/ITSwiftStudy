//
//  ITFBProfileRequest.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 21.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

import FacebookLogin
import FacebookCore

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
