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
        get {
            return URL(string: id)!
        }
    }
    var imageModel: ITImageModel? {
        get {
            return ITImageModel.image(with: self.url!)
        }
    }

}
