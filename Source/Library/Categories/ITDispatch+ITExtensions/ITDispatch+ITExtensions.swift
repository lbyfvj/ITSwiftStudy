//
//  ITDispatch+ITExtensions.swift
//  ITSwiftStudy
//
//  Created by Ivan Tsyganok on 04.05.17.
//  Copyright © 2017 Ivan Tsyganok. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private static var _onceTracker = [String : Any]()
    
    public class func once<Result>(
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: (Void) -> Result
    )
        -> Result
    {
        let token = file + ":" + function + ":" + String(line)
        
        return self.once(token: token, block: block)
    }
    
    public class func once<Result>(
        token: String,
        block: (Void) -> Result
        )
        -> Result
    {
        return synchronized(self) {
            let result = self._onceTracker[token] as? Result ?? block()
            self._onceTracker[token] = result
            
            return result
        }
    }

}

func synchronized<Result>(_ token: AnyObject, execute: () -> Result) -> Result {
    objc_sync_enter(token)
    defer { objc_sync_exit(token) }
    
    return execute()
}

