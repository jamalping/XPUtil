//
//  KVO.swift
//  XPUtilExample
//
//  Created by jamalping on 2018/7/24.
//  Copyright © 2018年 xyj. All rights reserved.
//

import Foundation

// MARK: KVO：实现了KVO的观察者的自动释放
public class KVO: NSObject {
    var target: AnyObject?
    var selector: Selector?
    var observedObject: NSObject?
    var keyPath: String?
    
    @discardableResult
    public class func observer(object: NSObject, keyPath: String, target: AnyObject, selector: Selector) -> KVO {
        return KVO.init(object: object, keyPath: keyPath, target: target, selector: selector)
    }
    
    init(object: NSObject, keyPath: String, target: AnyObject, selector: Selector) {
        super.init()
        self.target = target
        self.selector = selector
        self.observedObject = object
        self.keyPath = keyPath
         object.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let ok = self.target?.responds(to: self.selector), ok == true {
            _ = self.target?.perform(self.selector)
        }
        
    }
    
    deinit {
        guard let keyPath = self.keyPath else {
            return
        }
        self.observedObject?.removeObserver(self, forKeyPath: keyPath)
    }
}
