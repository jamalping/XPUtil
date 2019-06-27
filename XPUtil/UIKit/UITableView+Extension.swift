//
//  UITableView+Extension.swift
//  XPUtilExample
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019年 xyj. All rights reserved.
//

import UIKit

var roeHeightCacheKey: Void = ()
public extension UITableView {
    /// 缓存cell高度
    var rowHeightCache: [IndexPath: Any] {
        get {
            var cache = objc_getAssociatedObject(self, &roeHeightCacheKey) as? [IndexPath: Any]
            if cache != nil {
                return cache!
            }
            cache = [IndexPath: Any]()
            objc_setAssociatedObject(self, &roeHeightCacheKey, cache, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return cache!
        }
        set {
            objc_setAssociatedObject(self, &roeHeightCacheKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
