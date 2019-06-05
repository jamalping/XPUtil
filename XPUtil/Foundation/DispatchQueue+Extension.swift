//
//  DispatchQueue.swift
//  FastContact
//
//  Created by Apple on 2019/3/30.
//  Copyright © 2019年 shaniaoge. All rights reserved.
//

import Foundation

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /// 只执行一次
    class func once(token: String, block: () -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
