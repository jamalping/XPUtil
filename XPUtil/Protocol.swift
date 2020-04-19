//
//  CheckValueTool.swift
//  XPUtilExample
//
//  Created by xp on 2018/5/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

import Foundation
import UIKit

// MARK: --- ImageFactory
public protocol ImageFactory {
    
    /// 颜色转image
    func createImage(color: UIColor) -> UIImage?
    
    /// gifData转image
    func gifImage(gifData: Data) -> UIImage?
}

// MARK: --- 实现 ImageFactory
public extension ImageFactory {
    func createImage(color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    func gifImage(gifData: Data) -> UIImage? {
        
        guard let sources = CGImageSourceCreateWithData(gifData as CFData, nil) else { return nil }
        
        let count =   CGImageSourceGetCount(sources)
        
        if (count <= 1) {
            return UIImage.init(data: gifData)
        } else {
            var images = [UIImage]()
            for i in 0..<count {
                if let image = CGImageSourceCreateImageAtIndex(sources, i, nil) {
                    images.append(UIImage.init(cgImage: image, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up))
                }
            }
            return UIImage.animatedImage(with: images, duration: Double(count)*0.1)
        }
    }
}


// MARK: 打印内存地址
protocol  MemoryAdress {
    //定义方法打印对象内存地址
    func printAddress(values:AnyObject...)
}

extension MemoryAdress {
    //定义方法打印对象内存地址
    func printAddress(values:AnyObject...){
        for value in values {
            print(Unmanaged.passUnretained(value).toOpaque())
        }
        print("-----------------------------------------")
    }

}

/// 弧度转角度
public func radiansToDegrees(radians: CGFloat) -> CGFloat {
    return ((radians) * (180.0 / CGFloat.pi))
}

/// 角度转弧度
public func degreesToRadians(angle: CGFloat) -> CGFloat {
    return ((angle) / 180.0 * CGFloat.pi)
}

struct AppInfo {
    static let infoDictionary = Bundle.main.infoDictionary!

    static let appDisplayName = infoDictionary["CFBundleDisplayName"] //程序名称

    static let majorVersion=infoDictionary["CFBundleShortVersionString"]//主程序版本号

    static let minorVersion = infoDictionary["CFBundleVersion"]//版本号（内部标示）

    static let appVersion = majorVersion
}
