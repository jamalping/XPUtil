//
//  KeyChainTool.swift
//  XPUtilExample
//
//  Created by xp on 2018/5/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

import Foundation

// MARK: - *** Public methods ***
public class KeychainTool {
    
    /// 获取 UUID，并保存
    @discardableResult
    public class func getUUID(key: String) -> String {
        guard let uuid: String = self.value(forKey: key) else {
            let uuid = UUID.init().uuidString
            print("uuid:",uuid)
            self.set(uuid, forKey: key)
            return uuid
        }
        print("uuid:",uuid)
        return uuid
    }
    
    /// 添加或更新值
    @discardableResult
    public class func set<T: TypeSafeKeychainValue>(_ value: T?, forKey key: String) -> Bool {
        guard let value = value else {
            removeValue(forKey: key)
            return true
        }
        if valueExists(forKey: key) {
            return update(value, forKey: key)
        } else {
            return create(value, forKey: key)
        }
    }
    
    /// 获取值
    @discardableResult
    public class func value<T: TypeSafeKeychainValue>(forKey key: String) -> T? {
        guard let valueData = valueData(forKey: key) else { return nil }
        
        return T.value(data: valueData)
    }
    
    /// 移除值
    @discardableResult
    public class func removeValue(forKey key:String) -> Bool {
        return deleteValue(forKey: key)
    }
    
    /// 删除所有的值
    @discardableResult
    public class func reset() -> Bool {
        
        let searchDictionary = basicDictionary()
        let status = SecItemDelete(searchDictionary as CFDictionary)
        return status == errSecSuccess
    }
    
    /// 获取所有的键值对
    @discardableResult
    public class func allValues() -> [[String: String]]? {
        
        var searchDictionary = basicDictionary()
        
        searchDictionary[kSecMatchLimit as String] = kSecMatchLimitAll
        searchDictionary[kSecReturnAttributes as String] = kCFBooleanTrue
        searchDictionary[kSecReturnData as String] = kCFBooleanTrue
        
        var retrievedAttributes: AnyObject?
        var retrievedData: AnyObject?
        
        var status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedAttributes)
        if status != errSecSuccess {
            return nil
        }
        
        status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedData)
        guard status == errSecSuccess,
            let attributeDicts = retrievedAttributes as? [[String: AnyObject]] else { return nil }
        
        var allValues = [[String : String]]()
        for attributeDict in attributeDicts {
            guard let keyData = attributeDict[kSecAttrAccount as String] as? Data,
                let valueData = attributeDict[kSecValueData as String] as? Data,
                let key = String(data: keyData, encoding: .utf8),
                let value = String(data: valueData, encoding: .utf8) else { continue }
            allValues.append([key: value])
        }
        
        return allValues
    }
}

// MARK: - *** Private methods ***
fileprivate extension KeychainTool {
    
    /// 是否存在该键值对
    @discardableResult
    class func valueExists(forKey key: String) -> Bool {
        return valueData(forKey: key) != nil
    }
    
    /// 创建一个键值对
    @discardableResult
    class func create<T: TypeSafeKeychainValue>(_ value: T, forKey key: String) -> Bool {
        var dictionary = newSearchDictionary(forKey: key)
        
        dictionary[kSecValueData as String] = value.data()
        
        let status = SecItemAdd(dictionary as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    /// 更新键值对
    @discardableResult
    class func update<T: TypeSafeKeychainValue>(_ value: T, forKey key: String) -> Bool {
        
        let searchDictionary = newSearchDictionary(forKey: key)
        var updateDictionary = [String: Any]()
        
        updateDictionary[kSecValueData as String] = value.data()
        
        let status = SecItemUpdate(searchDictionary as CFDictionary, updateDictionary as CFDictionary)
        
        return status == errSecSuccess
    }
    
    /// 删除某个键值对
    @discardableResult
    class func deleteValue(forKey key: String) -> Bool {
        let searchDictionary = newSearchDictionary(forKey: key)
        let status = SecItemDelete(searchDictionary as CFDictionary)
        
        return status == errSecSuccess
    }
    
    /// 获取对应的值
    @discardableResult
    class func valueData(forKey key: String) -> Data?  {
        
        var searchDictionary = newSearchDictionary(forKey: key)
        
        searchDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
        searchDictionary[kSecReturnData as String] = kCFBooleanTrue
        
        var retrievedData: AnyObject?
        let status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedData)
        
        var data: Data?
        if status == errSecSuccess {
            data = retrievedData as? Data
        }
        
        return data
    }
    
    @discardableResult
    class func newSearchDictionary(forKey key: String) -> [String: Any] {
        let encodedIdentifier = key.data(using: .utf8, allowLossyConversion: false)
        
        var searchDictionary = basicDictionary()
        searchDictionary[kSecAttrGeneric as String] = encodedIdentifier
        searchDictionary[kSecAttrAccount as String] = encodedIdentifier
        
        return searchDictionary
    }
    
    /// 基础的键值对
    @discardableResult
    class func basicDictionary() -> [String: Any] {
        
        let serviceName = Bundle(for: self).infoDictionary![kCFBundleIdentifierKey as String] as! String
        
        return [kSecClass as String : kSecClassGenericPassword, kSecAttrService as String : serviceName]
    }
}

//MARK: - TypeSafeKeychainValue
public protocol TypeSafeKeychainValue {
    func data() -> Data?
    static func value(data: Data) -> Self?
}

extension String: TypeSafeKeychainValue {
    public func data() -> Data? {
        return data(using: .utf8, allowLossyConversion: false)
    }
    public static func value(data: Data) -> String? {
        return String(data: data, encoding: .utf8)
    }
}

extension Int: TypeSafeKeychainValue {
    public func data() -> Data? {
        var value = self
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
    }
    public static func value(data: Data) -> Int? {
        return data.withUnsafeBytes { $0.pointee }
    }
}

extension Bool: TypeSafeKeychainValue {
    public func data() -> Data? {
        var value = self
        return Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
    }
    public static func value(data: Data) -> Bool? {
        return data.withUnsafeBytes { $0.pointee }
    }
}

extension Date: TypeSafeKeychainValue {
    public func data() -> Data? {
        return NSKeyedArchiver.archivedData(withRootObject: (self as NSDate))
    }
    public static func value(data: Data) -> Date? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Date
    }
}

//public protocol Keychainable {
//    var uniquekey: String { get }
//}
//
//
//public extension Keychainable where Self: TypeSafeKeychainValue {
//    public func set(forKey key: String) -> Bool {
////        guard let value = self else {
////            removeValue(forKey: key)
////            return true
////        }
////
//        if valueExists(forKey: key) {
//            return update(self, forKey: key)
//        } else {
//            return create(self, forKey: key)
//        }
//    }
//
//    /// 获取值
//    @discardableResult
//    public func value<T: TypeSafeKeychainValue>(forKey key: String) -> T? {
//        guard let valueData = valueData(forKey: key) else { return nil }
//
//        return T.value(data: valueData)
//    }
//
//    /// 创建一个键值对
//    @discardableResult
//    fileprivate func create<T: TypeSafeKeychainValue>(_ value: T, forKey key: String) -> Bool {
//        var dictionary = newSearchDictionary(forKey: key)
//
//        dictionary[kSecValueData as String] = value.data()
//
//        let status = SecItemAdd(dictionary as CFDictionary, nil)
//        return status == errSecSuccess
//    }
//
//    /// 更新键值对
//    @discardableResult
//    fileprivate func update<T: TypeSafeKeychainValue>(_ value: T, forKey key: String) -> Bool {
//
//        let searchDictionary = newSearchDictionary(forKey: key)
//        var updateDictionary = [String: Any]()
//
//        updateDictionary[kSecValueData as String] = value.data()
//
//        let status = SecItemUpdate(searchDictionary as CFDictionary, updateDictionary as CFDictionary)
//
//        return status == errSecSuccess
//    }
//
//    /// 删除某个键值对
//    @discardableResult
//    func deleteValue(forKey key: String) -> Bool {
//        let searchDictionary = newSearchDictionary(forKey: key)
//        let status = SecItemDelete(searchDictionary as CFDictionary)
//
//        return status == errSecSuccess
//    }
//
//    /// 获取对应的值
//    @discardableResult
//    fileprivate func valueData(forKey key: String) -> Data?  {
//
//        var searchDictionary = newSearchDictionary(forKey: key)
//
//        searchDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
//        searchDictionary[kSecReturnData as String] = kCFBooleanTrue
//
//        var retrievedData: AnyObject?
//        let status = SecItemCopyMatching(searchDictionary as CFDictionary, &retrievedData)
//
//        var data: Data?
//        if status == errSecSuccess {
//            data = retrievedData as? Data
//        }
//
//        return data
//    }
//
//    /// 是否存在该键值对
//    @discardableResult
//    fileprivate func valueExists(forKey key: String) -> Bool {
//        return valueData(forKey: key) != nil
//    }
//
//
//    @discardableResult
//    fileprivate func newSearchDictionary(forKey key: String) -> [String: Any] {
//        let encodedIdentifier = key.data(using: .utf8, allowLossyConversion: false)
//
//        var searchDictionary = basicDictionary()
//        searchDictionary[kSecAttrGeneric as String] = encodedIdentifier
//        searchDictionary[kSecAttrAccount as String] = encodedIdentifier
//
//        return searchDictionary
//    }
//
//    /// 基础的键值对
//    @discardableResult
//    fileprivate func basicDictionary() -> [String: Any] {
//
//        let serviceName = Bundle.main.infoDictionary![kCFBundleIdentifierKey as String] as! String
//
//        return [kSecClass as String : kSecClassGenericPassword, kSecAttrService as String : serviceName]
//    }
//
//}
//
