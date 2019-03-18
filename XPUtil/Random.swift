//
//  Random.swift
//  XPUtilExample
//
//  Created by Apple on 2019/3/18.
//  Copyright © 2019年 xyj. All rights reserved.
//

import Foundation


/// 获取随机数协议
public protocol Randomable {
    
}

public  extension Randomable {
    /// 随机数生成 闭区间 [min, max]支持负数 eg: [1, 10],[-3,3]
    public func randomCustom(min: Int, max: Int) -> Int {
        //  [min, max)  [0, 100)
        //        var x = arc4random() % UInt32(max);
        //        return Int(x)
        // [min, max）
        var y: UInt32
        if min >= 0 {
            y = arc4random() % UInt32(max) + UInt32(min)
            return Int(y)
        }else {
            y = arc4random() % UInt32(max-min+1)
            let r: Int = Int(y)
            return Int(r + min)
        }
    }
    
    /// 随机生成正负1
    public func randomPosiOrNega() -> Int {
        let random = (arc4random()%2+1)%2
        if random == 0 {
            return -1
        }
        return 1
    }
}


