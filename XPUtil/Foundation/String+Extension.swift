//
//  String+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit
import CommonCrypto

public extension String {
    /// 长度
    public var length: Int {
        return self.utf16.count
    }
    
    /// 提取字符串中的数字组成新的字符串
    public var scannerNum: String {
        return self.filter { return Int(String($0)) != nil }
    }

    /// 删除两端空格
    public var trimmingSpace: String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public subscript (i: Int) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: i)
            return String(self[startIndex])
        }
    }

    // 下标范围取值：eg: "12345"[1..<3] = "23"
    subscript (i : Range<Int>) -> String {
        get {
            let startIndex = self.index(self.startIndex, offsetBy: i.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: i.upperBound)
            return String(self[startIndex ..< endIndex])
        }
        
        set {
            let startIndex = self.index(self.startIndex, offsetBy: i.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: i.upperBound)
            let strRange = startIndex..<endIndex
            self.replaceSubrange(strRange, with: newValue)
        }
    }
    
    
    // 用目标字符串替换range下标的字符串
    // var aa = "123456"
    // aa.replace(in: 1..<4, with: "*") 结果为：1*56
    public mutating func replace(in range: Range<Int>, with astring: String) -> String {
        
        let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        return self.replacingCharacters(in: startIndex..<endIndex, with: astring)
    }
    
    /// 使用正则表达式替换
    ///
    /// - Parameters:
    ///   - pattern: 正则表达式
    ///   - with: 替换的字符串
    ///   - options:
    /// - Returns:
    /// - eg: let str = "sfdg.sdf?多少f="
    ///       let result = fsdf.pregReplace(pattern: "[.?=]", with: "") //sfdgsdf多少f
    public func pregReplace(pattern: String, with: String,
                     options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
    /// 格式化金额
    public func formatMoney() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        guard let floatValue = Float(self), var resultString = formatter.string(from: NSNumber.init(value: floatValue)) else {
            return nil
        }
        resultString.removeSubrange(resultString.startIndex ..< resultString.index(resultString.startIndex, offsetBy: 1))
        return resultString
    }

    /// 每隔一段插入一个字符
    ///
    /// - Parameters:
    ///   - string: 插入的字符串
    ///   - len: 每隔几位
    /// - Returns: 插入后的字符串
    public func insert(string: String, len: Int) -> String {
        if self.length < 1 { return self }
        var resultString = ""
        var index = 0
        while  index < self.length {
            if index + len >= self.length {
                resultString += self[index..<self.length]
                break
            }
            let news = self[index..<index+len]
            resultString = resultString + news + string
            index += len
        }
        return resultString
    }

    /// 使用正则表达式替换
    ///
    /// - Parameters:
    ///   - pattern: 正则
    ///   - with: <#with description#>
    ///   - options: <#options description#>
    /// - Returns: <#return value description#>
    /// - eg:pregReplace(pattern: "[A-Z]", with: "_$0")  大写转小写，并前面添加一个_
    public func regexReplace(pattern: String, with: String,
                      options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.length),
                                              withTemplate: with)
    }

    /// 获取字符串子串
    ///
    /// - Parameter index: 切割的初始位置
    /// - Returns: 子串
    public func subString(from index: Int) -> String {
        if index <= self.length {
            return String(self[index..<self.length])
        }
        return self
    }

    /// 获取字符串子串
    ///
    /// - Parameter index: 切割的最终位置
    /// - Returns: 子串
    public func subString(to index: Int) -> String {
        if index <= self.length {
            return String(self[0..<index])
        }
        return self
    }

    /// 根据字符串生成Swift的类
    ///
    /// - Parameter string: 类名的字符串
    /// - Returns: Swift类
    public static func swiftClassFromString(string: String) -> AnyClass? {

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let classStringName = "_TtC\(appName.count)\(appName)"+"\(string.count)"+string

        return NSClassFromString(classStringName)
    }

    
    /// 匹配字符串在目标字符串的位置（可用于搜索标记）
    ///
    /// - Parameter string: 字符串
    /// - Returns: 字符串所在的位置
    public func match(string: String) -> [NSRange] {
        var result = [NSRange?]()
        
        string.forEach { (aChar) in
            let temArray = self.enumerated().map({ (index,bChar) -> NSRange? in
                if aChar == bChar {
                    return NSMakeRange(index, 1)
                }
                return nil
            })
            result.append(contentsOf: temArray)
        }
        return result.filter{ return $0 != nil }.map{ return $0! }
    }
    
    /// 共用方法，传参数正则表达试
    public func isValidRegexString(regexString: String) ->Bool {
        do {
            let pattern = regexString
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, self.count))
            return matches.count > 0
            
        } catch {
            return false
        }
    }
    
    // 匹配数字递增或者递减。比如（123456、654321）
    public func isIncreasOrdiminish() -> Bool {
        let regeXStr = "(?:(?:0(?=1)|1(?=2)|2(?=3)|3(?=4)|4(?=5)|5(?=6)|6(?=7)|7(?=8)|8(?=9)){5}|(?:9(?=8)|8(?=7)|7(?=6)|6(?=5)|5(?=4)|4(?=3)|3(?=2)|2(?=1)|1(?=0)){5})\\d"
        return self.isValidRegexString(regexString: regeXStr)
    }
    
    // 匹配6个数字是否相同
    public func isSameString() -> Bool {
        let regeXStr = "([\\d])\\1{5,}" // 匹配6个数字相同
        return self.isValidRegexString(regexString: regeXStr)
    }
    // 匹配2233类型（比如2233、2222，333444）
    public func is2233String() -> Bool {
        let regeXStr = "([\\d])\\1{1,}([\\d])\\2{1,}"
        return self.isValidRegexString(regexString: regeXStr)
    }
    
    // 是否是简单密码
    public var isSimplePwd: Bool {
        if isIncreasOrdiminish() || isSameString() || is2233String() {
            return true
        }
        return false
    }
}

extension String {
    /// 生成随机字符串
    ///
    /// - Parameter length: 字符串长度
    /// - Returns: 生成好的随机字符串
   public  static func randomString(length: Int) -> String {
        var resultStr: String = ""
        for _ in 0..<length {
            let char: Character = Character.init(UnicodeScalar.init(33 + arc4random() % 63)!)
            resultStr.append(char)
        }
        return resultStr
    }
}

// MARK: 字符串和ASCII码的相互转换
extension String {
    
    /// 获取当前字符串的ASCII值
    /// eg a.getHexString() return "61"
    public func getHexString() -> String? {
        var resultStr: String = String.init()
        
        let cStr = cString(using: .utf8)!
        for index in 0..<cStr.count {
            if index == cStr.count - 1 {
                break
            }
            resultStr.append(String.init(format: "%02x", cStr[index]))
        }
        return resultStr
    }
    
    /// ASCII值的字符串形式转字符串
    /// eg: "61".hexStringToString() return "a"
    public func hexStringToString() -> String? {
        var resultStr: String = String.init()
        
        for idx in 1...count {
            if idx != 0 && idx % 2 == 0 {
                let preIndex: Index = index(startIndex, offsetBy: idx - 2)
                let sufIndex: Index = index(startIndex, offsetBy: idx)
                
                var intValue: UInt32 = UInt32()
                let subStr: String = String.init(self[preIndex..<sufIndex])
                Scanner.init(string: subStr).scanHexInt32(&intValue)
                let r = Character(UnicodeScalar.init(intValue)!)
                resultStr.append(r)
                
            }
        }
        return resultStr
    }
    
    /// 是否包含Emoji表情
    public func isContainEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
}

// MARK: - 文字宽高计算
extension String {
    /// 带换行符等特殊字符串计算高度（下面的方法应该也能计算出文字高度，有待验证，如果下面的方法有用，尽量用下面的方法）
    ///
    /// - Parameters:
    ///   - maxSize: 最大size
    func heightForContent(maxSize: CGSize,font: UIFont) -> CGFloat {
        
        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: maxSize.width, height: 10))
        
        textView.text = self
        
        textView.font = font
        
        let constraint = textView.sizeThatFits(maxSize)
        return constraint.height
    }
    
    /// 计算文字的size
    ///
    /// - Parameters:
    ///   - withFont: 文字字体
    ///   - maxSize: 最大的size，指定width，就是计算height。指定height，就是计算width。
    /// - Returns: 计算后的size
    public func size(withFont: UIFont, maxSize: CGSize) -> CGSize {
        
        let dic: [NSAttributedStringKey : Any] = [NSAttributedStringKey.font: withFont]
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: dic, context:nil).size
    }
    
    
    /// 计算文字的size
    ///
    /// - Parameters:
    ///   - withAttrs: <#withAttrs description#>
    ///   - maxSize: 最大的size，指定width，就是计算height。指定height，就是计算width。
    /// - Returns: 计算后的size
    public func size(withAttrs: [NSAttributedStringKey : Any], maxSize: CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: withAttrs, context:nil).size
    }
}

// MARK: - 加密，解密
extension String {
    
    /// base64加密
    public func base64Encode() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        let base64Data = data.base64EncodedData()
        return String.init(data: base64Data, encoding: .utf8)
    }
    
    /// base64解密
    public func base64Dencode() -> String? {
        guard let data = Data.init(base64Encoded: self) else {
            return nil
        }
        return String.init(data: data, encoding: .utf8)
    }
    
    /// MD5加密后的字符串
    var md5: String {
        guard let cStr = self.cString(using: String.Encoding.utf8) else {
            debugPrint("MD5加密失败")
            return self
        }
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let strLength = CC_LONG(strlen(cStr))
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(cStr, strLength, result)
        
        var md5String: String = String()
        for i in 0 ..< digestLen {
            md5String.append(String.init(format: "%02x", result[i]))
        }
        free(result)
        return String(format: md5String as String)
    }
}

