//
//  ITImageModel.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 04.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

class ITImageModel: NSObject {
    
    let kITDefaultImageName = "defaultImage.png"
    var image: UIImage?
    var url: URL?
    
    // MARK: -
    // MARK: Class methods
    
    class func image(with url: URL) -> ITImageModel {
        
        let objectCache = ITObjectCache()
        var image = objectCache.object(for: url as AnyObject)
        
        if image.boolValue == nil {
            image = self.init(with: url);
            objectCache.addObject(image, forKey: url as AnyObject)
        }
        
        return image as! ITImageModel
    }
    
    // MARK: -
    // MARK: Initializations and Deallocations
    
    deinit {
        self.downloadTask = nil
    }
    
    required init(with url: URL) {
        super.init()
        
        self.url = url
        try? FileManager.default.createDirectory(atPath: self.filePath, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: -
    // MARK: Accessors
    
    var downloadTask: URLSessionDownloadTask? {
        willSet {
            self.downloadTask?.cancel()
        }
        didSet {
            self.downloadTask?.resume()
        }
    }
    
    var filePath: String {
        let cachePath: String? = FileManager.documentsDirectoryURL.path
        let host: String? = url?.host?.stringByAddingPercentEncodingWithalphanumericCharacterSet()
        
        return URL(fileURLWithPath: cachePath!).appendingPathComponent(host!).absoluteString
    }
    
    var downloadSession: URLSession {
        let urlSession = DispatchQueue.once {
            URLSession(configuration: URLSessionConfiguration.ephemeral)
        }
        
        return urlSession
    }
    
    var isCached: Bool {
        return self.fileURL.isFileURL && FileManager.default.fileExists(atPath: self.fileURL.path)
    }
    
    var fileURL: URL {
        let url: URL? = self.url
        
        if (url?.isFileURL)! {
            return url!
        }
        
        let fileName: String? = self.url?.relativePath.stringByAddingPercentEncodingWithalphanumericCharacterSet()
        let path: String = URL(fileURLWithPath: filePath).appendingPathComponent(fileName!).relativePath
        
        return URL(fileURLWithPath: path, isDirectory: false)
    }
    
    // MARK: -
    // MARK: Public
    
    func finalizeLoading(with image: UIImage) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        self.image = image
    }

    func performLoading() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        if self.isCached {
            self.image = UIImage(contentsOfFile: self.fileURL.path)
        } else {
            self.download()
        }
    }
    
    func download() -> Void {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        self.downloadTask = self.downloadSession.downloadTask(with: URLRequest(url:self.url!)) { (localUrl, response, error) in
            if let localUrl = localUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                FileManager.default.copyFile(at: localUrl, to: self.fileURL)
                let image = UIImage(contentsOfFile: self.fileURL.path)
                self.finalizeLoading(with: image ?? UIImage(named: self.kITDefaultImageName)!)
            } else {
                print("Error while downloading a file")
            }
        }
    }
}
