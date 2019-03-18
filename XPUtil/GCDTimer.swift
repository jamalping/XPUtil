//
//  GCDTimer.swift
//  XPUtilExample
//
//  Created by Apple on 2019/3/18.
//  Copyright © 2019年 xyj. All rights reserved.
//

import Foundation

/// GCD实现的倒计时
/*
 若要实现后台倒计时： 在 `applicationDidEnterBackground`中添加如下代码
 func applicationDidEnterBackground(_ application: UIApplication) {
 
 /// 后台任务检测
 var bgTask: UIBackgroundTaskIdentifier?
 bgTask = UIApplication.shared.beginBackgroundTask {
 DispatchQueue.main.async {
 if bgTask != UIBackgroundTaskIdentifier.invalid {
 bgTask = UIBackgroundTaskIdentifier.invalid
 }
 }
 }
 
 DispatchQueue.global().async {
 DispatchQueue.main.async {
 if bgTask != UIBackgroundTaskIdentifier.invalid {
 bgTask = UIBackgroundTaskIdentifier.invalid
 }
 }
 }
 print("applicationDidEnterBackground")
 }
 */
struct GCDTimer {
    
    
    /// 倒计时
    ///  若要后台倒计时，请看上方注释
    /// - Parameters:
    ///   - totalTime: 倒计时总共时间
    ///   - timeInterval: 时间间隔
    ///   - eventHandler: 时间回调
    ///   - timeFinesh: 倒计时完成回调
    static func countdown(totalTime: TimeInterval, timeInterval: TimeInterval , eventHandler: @escaping (_ currentTime: TimeInterval)->(), timeFinesh: (()->())? = nil) {
        var aTime = totalTime
        let codeTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: DispatchTime.now(), repeating: timeInterval)
        codeTimer.setEventHandler {
            if aTime == 0 {
                timeFinesh?()
                codeTimer.cancel()
                return
            }
            DispatchQueue.global().async {
                eventHandler(aTime)
                aTime -= 1
            }
        }
        if #available(iOS 10.0, *) {
            codeTimer.activate()
        } else {
            codeTimer.resume()
        }
    }
}
