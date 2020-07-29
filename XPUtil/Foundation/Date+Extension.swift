//
//  Date+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/23.
//  Copyright © 2017年 xyj. All rights reserved.
//

import Foundation

public extension Date {
    
    // 时间戳转化成时间（毫秒）"yyyy-MM-dd HH:mm:ss"
    static func timeStampToString(timeStamp: String, dataFormatter: String) ->String {
        
        let timeSta: TimeInterval = (Double(timeStamp) ?? 0)/1000
        
        let dfmatter = DateFormatter()
        
        dfmatter.dateFormat = dataFormatter
        
        let date = Date.init(timeIntervalSince1970: timeSta)
        
        return dfmatter.string(from: date)
    }
    
    // 时间转化成时间戳
    static func stringToTimeStamp(stringTime:String)->String {
        
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日"
        let date = dfmatter.date(from: stringTime)
        
        let dateStamp: TimeInterval = date!.timeIntervalSince1970
        
        let dateSt:Int = Int(dateStamp)
        print(dateSt)
        return String(dateSt)
        
    }
    // 格式化时间
    static func formatDate(format: String = "yyyy-MM-dd", time: String) -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        let date = Date.dateWithString(str: time, dateFormat: format)!
        return dfmatter.string(from: date)
    }
    
    static func dateWithString(str: String,dateFormat:String) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        return formatter.date(from: str)
    }
    
    // 比较Date是都相等----到天
    func isEqual(date: Date, otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date, inSameDayAs: otherDate)
    
    }
    
    // 是否为今天
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    // 是否为明天
    func isTomorrow() -> Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    
    // 是否为昨天
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    
    /// 当前date的月份有多少天
    func numberOfDays(date: Date) -> Int? {
        guard let sss = Calendar.current.range(of: .day, in: .month, for: date) else {
            return nil
        }
        return sss.endIndex - sss.startIndex
    }
    
    /// 当前 component 的下一个
    func nextComponent(date: Date, component: Calendar.Component = .day) -> Date? {
        let calendar: Calendar = Calendar.current
        return calendar.date(byAdding: component, value: 1, to: date)
    }
    
    //根据date获取日
    func convertDateToDay(date: Date, _ components: Set<Calendar.Component> = [Calendar.Component.year, .month, .day, .weekday]) -> DateComponents {
        let calendar: Calendar = Calendar.current
        let components = calendar.dateComponents(components, from: date)
        return components
    }
}
