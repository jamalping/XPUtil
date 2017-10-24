//
//  UIColor+Extension.swift
//  XPUtil
//
//  Created by xyj on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit

public extension UIColor {
    // user:UIColor.init(hexString: "#ff5a10") ||UIColor.init(hexString: "ff5a10")
    convenience init(hexString: String, alpha: CGFloat = 1) {
        var r, g, b, a: CGFloat
        a = alpha
        var hexColor: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // 存在#，则将#去掉
        if (hexColor.hasPrefix("#")) {
            let splitIndex = hexColor.index(after: hexColor.startIndex)
            hexColor = String(hexColor[splitIndex...])
        }
        if hexColor.characters.count == 8 {
            let scanner = Scanner(string: hexColor)
            
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        } else if hexColor.characters.count == 6 {
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        // 设置默认值
        self.init(white: 0.0, alpha: 1)
    }
    
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    //user: UIColor.init(valueHex: 0xff5a10)
    convenience init(valueHex: UInt, alpha: CGFloat = 1.0) {
        
        self.init(
            red: CGFloat((valueHex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((valueHex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(valueHex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    /// 获取随机颜色
    /// - Returns: 随机颜色
    class func randamColor() -> UIColor{
        let R = CGFloat(arc4random_uniform(255))/255.0
        let G = CGFloat(arc4random_uniform(255))/255.0
        let B = CGFloat(arc4random_uniform(255))/255.0
        return UIColor.init(red: R, green: G, blue: B, alpha: 1)
    }
}

