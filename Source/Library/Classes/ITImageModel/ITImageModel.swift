//
//  ITImageModel.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 04.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import UIKit

extension Optional {
    var boolValue: Bool {
        return self != nil
    }
}

class ITImageModel: NSObject {
    
    let downloadSession = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    var image: UIImage?
    var url: URL
    
    // MARK: -
    // MARK: Class methods
    
    class func model(with url: URL) -> ITImageModel {
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
        defer { downloadTask = nil }
    }
    
    required init(with url: URL) {
        self.url = url
        
        super.init()
        
        try? FileManager.default.createDirectory(atPath: self.filePath, withIntermediateDirectories: true, attributes: nil)
    }
    
    // MARK: -
    // MARK: Accessors
    
    var downloadTask: URLSessionDownloadTask? {
        willSet { downloadTask?.cancel() }
        didSet { downloadTask?.resume() }
    }
    
    var filePath: String {
        let cachePath = FileManager.documentsDirectoryURL.path
        let host = self.url.host?.alphanumeriPercentEncoded() ?? ""
        
        return URL(fileURLWithPath: cachePath).appendingPathComponent(host).absoluteString
    }
    
    var isCached: Bool {
        let url = self.fileURL
        return url.isFileURL && FileManager.default.fileExists(atPath: url.path)
    }
    
    var fileURL: URL {
        let url = self.url
        
        if url.isFileURL {
            return url
        }
        
        let fileName = self.url.relativePath.alphanumeriPercentEncoded()
        let path: String = URL(fileURLWithPath: filePath).appendingPathComponent(fileName).relativePath
        
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
    
    func download() {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        let urlRequest = URLRequest(url:self.url)
        self.downloadTask = self.downloadSession.downloadTask(with: urlRequest) { localUrl, response, error in
            if let localUrl = localUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                FileManager.default.copyFile(at: localUrl, to: self.fileURL)
                let image = UIImage(contentsOfFile: self.fileURL.path)
                self.finalizeLoading(with: image ?? UIImage(named: ITConstants.Default.kITDefaultImageName)!)
            } else {
                print("Error while downloading a file")
            }
        }
    }
}
