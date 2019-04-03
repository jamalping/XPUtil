//
//  Device+Extensions.swift
//  XPUtilExample
//
//  Created by xp on 15/07/15.
//  Copyright (c) 2015 xp. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit

/// EZSwiftExtensions
private let DeviceList = [
    "iPod5,1": "iPod Touch 5",/* iPod 5 */
    "iPod7,1": "iPod Touch 6",/* iPod 6 */
    "iPhone3,1": "iPhone 4", "iPhone3,2": "iPhone 4", "iPhone3,3": "iPhone 4", /* iPhone 4 */
    "iPhone4,1": "iPhone 4S",    /* iPhone 4S */
    "iPhone5,1": "iPhone 5", "iPhone5,2": "iPhone 5", /* iPhone 5 */
    "iPhone5,3": "iPhone 5C", "iPhone5,4": "iPhone 5C", /* iPhone 5C */
    "iPhone6,1": "iPhone 5S", "iPhone6,2": "iPhone 5S", /* iPhone 5S */
    "iPhone7,2": "iPhone 6", /* iPhone 6 */
    "iPhone7,1": "iPhone 6 Plus", /* iPhone 6 Plus */
    "iPhone8,1": "iPhone 6S", /* iPhone 6S */
    "iPhone8,2": "iPhone 6S Plus", /* iPhone 6S Plus */
    "iPhone9,1": "iPhone 7", "iPhone9,3": "iPhone 7", /* iPhone 7 */
    "iPhone9,2": "iPhone 7 Plus", "iPhone9,4": "iPhone 7 Plus", /* iPhone 7 Plus */
    "iPhone8,4": "iPhone SE", /* iPhone SE */
    "iPhone10,1": "iPhone 8", "iPhone10,4": "iPhone 8", /* iPhone 8 */
    "iPhone10,2": "iPhone 8 Plus", "iPhone10,5": "iPhone 8 Plus", /* iPhone 8 Plus */
    "iPhone10,3": "iPhone X", "iPhone10,6": "iPhone X", /* iPhone X */
    "iPhone11,2": "iPhone XS", /* iPhone XS */
    "iPhone11,4": "iPhone XS Max","iPhone11,6": "iPhone XS Max", /* iPhone XS Max*/
    "iPhone11,8": "iPhone XR", /* iPhone XR */
    
    "iPad2,1": "iPad 2", "iPad2,2": "iPad 2", "iPad2,3": "iPad 2", "iPad2,4": "iPad 2", /* iPad 2 */
    "iPad3,1": "iPad 3", "iPad3,2": "iPad 3", "iPad3,3": "iPad 3", /* iPad 3 */
    "iPad3,4": "iPad 4", "iPad3,5": "iPad 4", "iPad3,6": "iPad 4", /* iPad 4 */
    "iPad4,1": "iPad Air", "iPad4,2": "iPad Air", "iPad4,3": "iPad Air", /* iPad Air */
    "iPad5,3": "iPad Air 2", "iPad5,4": "iPad Air 2", /* iPad Air 2 */
    "iPad2,5": "iPad Mini", "iPad2,6": "iPad Mini", "iPad2,7": "iPad Mini", /* iPad Mini */
    "iPad4,4": "iPad Mini 2", "iPad4,5": "iPad Mini 2", "iPad4,6": "iPad Mini 2", /* iPad Mini 2 */
    "iPad4,7": "iPad Mini 3", "iPad4,8": "iPad Mini 3", "iPad4,9": "iPad Mini 3", /* iPad Mini 3 */
    "iPad5,1": "iPad Mini 4", "iPad5,2": "iPad Mini 4", /* iPad Mini 4 */
    "iPad6,7": "iPad Pro", "iPad6,8": "iPad Pro", /* iPad Pro */
    "AppleTV5,3": "AppleTV", /* AppleTV */
    
    "x86_64": "Simulator", "i386": "Simulator" /* Simulator */
]


/// 设备名对应的case
public enum DeviceModel: String {
    case iPodTouch5 = "iPod Touch 5"
    case iPodTouch6 = "iPod Touch 6"
    
    case iPhone4  =  "iPhone 4"
    case iPhone4s =  "iPhone 4s"
    case iPhone5 =  "iPhone 5"
    case iPhone5c =  "iPhone 5c"
    case iPhone5s =  "iPhone 5s"
    case iPhone6 =  "iPhone 6"
    case iPhone6Plus =  "iPhone 6 Plus"
    case iPhone6s =  "iPhone 6s"
    case iPhone6sPlus =  "iPhone 6s Plus"
    case iPhone7 =  "iPhone 7"
    case iPhone7Plus =  "iPhone 7 Plus"
    case iPhoneSE =  "iPhone SE"
    case iPhone8 =  "iPhone 8"
    case iPhone8Plus =  "iPhone 8 Plus"
    case iPhoneX = "iPhone X"
    case iPhoneXR = "iPhone XR"
    case iPhoneXS = "iPhone XS"
    case iPhoneXSMax = "iPhone XS Max"
    
    case iPad2 =  "iPad 2"
    case iPad3 =  "iPad 3"
    case iPad4 =  "iPad 4"
    case iPadAir =  "iPad Air"
    case iPadAir2 =  "iPad Air 2"
    case iPadMini =  "iPad Mini"
    case iPadMini2 =  "iPad Mini 2"
    case iPadMini3 =  "iPad Mini 3"
    case iPadMini4 =  "iPad Mini 4"
    case iPadPro12inch =  "iPad Pro (12.9 inch)"
    case iPadPro9inch =  "iPad Pro (9.7 inch)"
    case AppleTV =  "Apple TV"
    case Simulator =  "Simulator"
}

public extension UIDevice {
    
    public class func idForVendor() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    /// 系统名
    public class func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    /// 系统版本
    public class func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    /// 系统短版本号
    public class func systemFloatVersion() -> Float {
        return (systemVersion() as NSString).floatValue
    }
    
    /// 设备名称
    public class func deviceName() -> String {
        return UIDevice.current.name
    }
    
    /// 设备语言
    public class func deviceLanguage() -> String {
        return Bundle.main.preferredLocalizations[0]
    }
    
    /// 获取设备标识
    public class func deviceModelReadable() -> String {
        return DeviceList[deviceModel()] ?? deviceModel()
    }
    
    /// 获取设备标识
    public class func getDeviceModel() -> DeviceModel {
        return DeviceModel.init(rawValue: DeviceList[deviceModel()] ?? deviceName()) ?? DeviceModel.iPhone6
    }
    
    /// 是否是iphone
    public class func isPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    
    /// 是否是ipad
    public class func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    /// 获取设备的标示
    public class func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let machine = systemInfo.machine
        var identifier = ""
        let mirror = Mirror(reflecting: machine)
        
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        
        return identifier
    }
    
    /// 当前版本号
    public class var CURRENT_VERSION: String {
        return "\(systemFloatVersion())"
    }
    
    public class func isSystemVersionOver(_ requiredVersion: String) -> Bool {
        switch systemVersion().compare(requiredVersion, options: NSString.CompareOptions.numeric) {
        case .orderedSame, .orderedDescending:
            //println("iOS >= 8.0")
            return true
        case .orderedAscending:
            //println("iOS < 8.0")
            return false
        }
    }
}

#endif
