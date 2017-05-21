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
 
    var image: UIImage?
    var url: URL
    
    // MARK: -
    // MARK: Class methods
    
    class func model(with url: URL) -> ITImageModel {
        var objectCache = ObjectCache<URL, ITImageModel>()
        let image = objectCache.object(for: url) ?? self.init(with: url)
        
        objectCache[url] = image
        
        return image
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
    
    var downloadSession: URLSession {
        return URLSession(configuration: URLSessionConfiguration.ephemeral)
    }
    
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
    
    func finalizeImageModel(with image: UIImage) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        self.image = image
    }

    func performLoading(completion: @escaping () -> Void) {
        print("\(NSStringFromClass(type(of: self))) - \(NSStringFromSelector(#function))")
        if self.isCached {
            if let image = UIImage(contentsOfFile: self.fileURL.path) {
                self.finalizeImageModel(with: image)
            }
        } else {
            self.downloadImage(url: self.url)
        }
        
        completion()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ url: URL?,
                                                         _ response: URLResponse?,
                                                         _ error: Error?) -> Void)
    {
        let urlRequest = URLRequest(url:url)
        self.downloadTask = self.downloadSession.downloadTask(with: urlRequest)
            { localUrl, response, error in
                completion(localUrl, response, error)
            }
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (localUrl, response, error)  in
            guard let localUrl = localUrl, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                FileManager.default.copyFile(at: localUrl, to: self.fileURL)
                if let image = UIImage(contentsOfFile: self.fileURL.path) {
                    self.finalizeImageModel(with: image)
                }
            }
        }
    }

}
