//
//  FileManager+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 05.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

extension FileManager {
    
    static var documentsDirectoryURL: URL {
        return self.url(for: .documentDirectory)
    }
    
    static var libraryDirectoryURL: URL {
        return self.url(for: .libraryDirectory)
    }
    
    static var applicationDirectoryURL: URL {
        return self.url(for: .applicationSupportDirectory)
    }
    
    static func url(for searchPath: FileManager.SearchPathDirectory) -> URL {
        let result = try? FileManager.default
            .url(for: searchPath,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
        
        return result ?? URL(fileURLWithPath: "")
    }
    
    func createDirectory(at url: URL) {
        if url.isFileURL {
            let path: String = url.path
            if !fileExists(atPath: path) {
                try? self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            }
        }
    }
    
    func copyFile(at url: URL, to toURL: URL) {
        self.createDirectory(at: toURL.deletingLastPathComponent())
        
        do {
            try self.copyItem(at: url, to: toURL)
        } catch (let writeError) {
            print("Error creating a file \(toURL) : \(writeError)")
        }
    }
    
}
