//
//  KVO.swift
//  XPUtilExample
//
//  Created by jamalping on 2018/7/24.
//  Copyright © 2018年 xyj. All rights reserved.
//

import Foundation

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
//        self.observedObject?.removeObserver(self)
        guard let keyPath = self.keyPath else {
            return
        }
        self.observedObject?.removeObserver(self, forKeyPath: keyPath)
    }
    
    /*
     
     @property (nonatomic, weak) id target;
     @property (nonatomic) SEL selector;
     @property (nonatomic, strong) id observedObject;
     @property (nonatomic, copy) NSString* keyPath;
     
     @end
     
     @implementation Jamal_KVO
     
     + (instancetype)observerWithObject:(id)object
     keyPath:(NSString*)keyPath
     target:(id)target
     selector:(SEL)selector {
     return [[Jamal_KVO alloc] initWithObject:object keyPath:keyPath target:target selector:selector];
     }
     
     // 检查某个key是否存在
     - (BOOL)observerKeyPath:(NSString *)key
     {
     id info = self.observationInfo;
     NSArray *array = [info valueForKey:@"_observances"];
     for (id objc in array) {
     id properyies = [objc valueForKeyPath:@"_property"];
     NSString *keyPath = [properyies valueForKeyPath:@"_keyPath"];
     if ([key isEqualToString:keyPath]) {
     return YES;
     }
     }
     return NO;
     }
     
     - (id)initWithObject:(id)object
     keyPath:(NSString*)keyPath
     target:(id)target
     selector:(SEL)selector {
     self = [super init];
     if (self) {
     self.observedObject = object;
     self.keyPath = keyPath;
     self.target = target;
     self.selector = selector;
     [object addObserver:self forKeyPath:keyPath options:0 context:(__bridge void *)(self)];
     }
     return self;
     }
     
     - (void)observeValueForKeyPath:(NSString*)keyPath
     ofObject:(id)object
     change:(NSDictionary*)change
     context:(void*)context {
     if (context == CFBridgingRetain(self)) {
     id strongTarget = self.target;
     if ([strongTarget respondsToSelector:self.selector]) {
     #pragma clang diagnostic push
     #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
     [strongTarget performSelector:self.selector];
     #pragma clang diagnostic pop
     }
     }
     }
     
     - (void)asfdgh {
     if (self&&self.delegate&&[self.delegate respondsToSelector:@selector(delegateAction:)]) {
     [self.delegate delegateAction:@"testVale"];
     }
     }
     
     - (void)dealloc
     {
     id strongObservedObject = self.observedObject;
     if (strongObservedObject) {
     [strongObservedObject removeObserver:self forKeyPath:self.keyPath];
     }
     }
     */
}
