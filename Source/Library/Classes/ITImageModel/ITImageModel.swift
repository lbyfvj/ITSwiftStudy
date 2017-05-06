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
        let image = objectCache.object(for: url as AnyObject)
        
        if !image.boolValue {
            self.init(with: url);
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
        
        let urlSession: URLSession = DispatchQueue.onceReturn {
            URLSession(configuration: URLSessionConfiguration.ephemeral)
            } as! URLSession
        
        return urlSession
    }
    
    var isCached: Bool {
        return self.fileURL.isFileURL && FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    var fileURL: URL {
        let url: URL? = self.url
        
        if (url?.isFileURL)! {
            return url!
        }
        
        let fileName: String? = self.url?.relativePath.stringByAddingPercentEncodingWithalphanumericCharacterSet()
        let path: String = URL(fileURLWithPath: filePath).appendingPathComponent(fileName!).absoluteString
        
        return URL(fileURLWithPath: path, isDirectory: false)
    }
    
    // MARK: -
    // MARK: Public
    
    func performLoading(withCompletionBlock block: @escaping (_ image: UIImage) -> Void) {
    
    }
    
    func finalizeLoading(with image: UIImage) {
        self.image = image
    }
    
    func performLoading() {
        
        if self.isCached {
            self.image = UIImage(contentsOfFile: self.filePath)
        } else {
            self.download()
        }
        
        sleep(1)
        
        
        performLoading(withCompletionBlock: {(_ image: UIImage) -> Void in
            self.finalizeLoading(with: image)
        })
    }
    
    func download() -> Void {
        var image = UIImage(named: kITDefaultImageName)
        self.downloadTask = self.downloadSession.downloadTask(with: URLRequest(url:self.url!)) { (localUrl, response, error) in
            if let localUrl = localUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                
                do {
                    try FileManager.default.copyItem(at: localUrl, to: self.fileURL)
                    image = UIImage(contentsOfFile: self.filePath)
                } catch (let writeError) {
                    print("Error creating a file \(self.fileURL) : \(writeError)")
                }
                
            } else {
                print("Error while downloading a file")
            }
        }
        
        self.image = image
    }
}
