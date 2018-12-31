//
//  JSON.swift
//  XPUtilExample
//
//  Created by Apple on 2018/12/30.
//  Copyright © 2018年 xyj. All rights reserved.
//

import Foundation
// MARK: - JSON字符串相关
public struct JSON {
    
    /// 转JSON字符串
    ///
    /// - Parameters:
    ///   - object: JSON对象(字典)
    ///   - options: <#options description#>
    /// - Returns: JSON字符串
    public static func toJSONString(_ object: Any, options: JSONSerialization.WritingOptions) -> String? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: options) else {
            return nil
        }
        let jsonString = String.init(data: data, encoding: .utf8)
        return jsonString
    }
    
    
    /// 转data
    ///
    /// - Parameters:
    ///   - JSONObject: JSON对象（字典）
    ///   - options: <#options description#>
    /// - Returns: Data
    public static func toJSONData(_ JSONObject: Any, options: JSONSerialization.WritingOptions) -> Data? {
        if JSONSerialization.isValidJSONObject(JSONObject) {
            let JSONData: Data?
            do {
                JSONData = try JSONSerialization.data(withJSONObject: JSONObject, options: options)
            } catch let error {
                print(error)
                JSONData = nil
            }
            
            return JSONData
        }
        
        return nil
    }
    
    
    /// 转JSON对象
    ///
    /// - Parameters:
    ///   - jsonString: JSON字符串
    ///   - options: <#options description#>
    /// - Returns: JOSN对象
    public static func toJSON(_ jsonString: String, options: JSONSerialization.ReadingOptions) -> [String: Any] {
        guard let data = jsonString.data(using: .utf8) else {
            return [:]
        }
        
        guard let json: [String: Any] = try? JSONSerialization.jsonObject(with: data, options: options) as! [String : Any]  else {
            return [:]
        }
        return json
    }
}
