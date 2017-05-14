//
//  ITDBImage.swift
//  
//
//  Created by Ivan Tsyganok on 01.05.17.
//
//

import Foundation
import CoreData

@objc(ITDBImage)
class ITDBImage: ITDBObject {
    
    var url: URL? {
        return URL(string: self.id)
    }
    
    var imageModel: ITImageModel? {
        return self.url.map(ITImageModel.model)
    }

}
