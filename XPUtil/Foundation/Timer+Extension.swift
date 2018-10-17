//
//  Timer+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/12.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import Foundation

public extension Timer {
    
    /// MARK -- 暂停
    public func pauseTimer() {
        if !self.isValid {
            return
        }
        self.fireDate = Date.distantFuture
    }
    
    /// MARK -- 重启
    public func resumeTimer() {
        if !self.isValid {
            return
        }
        self.fireDate = Date()
    }
    
    /// MARK -- 隔一段时间启动
    public func resumeTimerAfterInterval(_ interval:TimeInterval) {
        if !self.isValid {
            return
        }
        
        self.fireDate = Date.init(timeIntervalSinceNow: interval)
    }
    
    /// Timer的使用,直接用系统的target action方式会有循环引用。 10.0系统才发布block方式的api，同样是通过这个方式实现的
    public class func xp_scheduledTimer(interval: TimeInterval, repeats: Bool, block: (_ timer: Timer)->()) -> Timer {
        return Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(xp_blcokInvoke), userInfo: block, repeats: true)
    }
    
    @objc public class func xp_blcokInvoke(timer: Timer) {
        if let block: (Timer) -> () = timer.userInfo as? (Timer) -> () {
            block(timer)
        }
    }
}
