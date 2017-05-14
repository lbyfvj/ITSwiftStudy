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
    
    var url: URL {
        return URL(string: self.id) ?? URL(fileURLWithPath: "")
    }
    
    var imageModel: ITImageModel? {
        return ITImageModel.model(with: self.url)
    }

}
