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
        return try! FileManager
            .default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
    }
    
    static var libraryDirectoryURL: URL {
        return try! FileManager
            .default
            .url(for: .libraryDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
    }
    
    static var applicationDirectoryURL: URL {
        return try! FileManager
            .default
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
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

        try? self.copyItem(at: url, to: toURL)
    }
    
}
