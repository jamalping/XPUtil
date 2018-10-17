# XPUtil
个人工具
### ContactsManager
联系人管理类
### KeyChainTool:钥匙串工具类

- 获取UUID
`public class func getUUID(key: String) -> String`
- 设置值
`public class func set<T: TypeSafeKeychainValue>(_ value: T?, forKey key: String) -> Bool`
- 获取值
`public class func value<T: TypeSafeKeychainValue>(forKey key: String) -> T?`
- 移除值
`public class func removeValue(forKey key:String) -> Bool`
- 删除所有的值

`public class func reset() -> Bool`

- 获取所有的键值对
`public class func allValues() -> [[String: String]]?`

### CheckValueTool：字符串有效性校验工具
- 手机号校验
`public static func isValidatePhoneNumber(_ phoneNumber: String) -> Bool`
- 邮箱校验
`public static func isValidateEmail(_ email: String) -> Bool`
- 身份证校验
`public static func isValidateIDCard(_ idCard: String) -> Bool`
- 香港通行证校验
`public static func isValidateHongkong(_ hkNumber: String) -> Bool`
- 澳门通行证校验
`public static func isValidateMacao(_ mcNumber: String) -> Bool`
- 台湾通行证校验
`public static func isValidateTaiwan(_ twNumber: String) -> Bool`
- 护照校验
`public static func isValidatePassport(_ passport: String) -> Bool`
- 车牌号校验
`public static func isValidateCarNo(_ CarNo: String) -> Bool `
- 检测输入的有效性

```
public static func isValueData(string: String,regeXType: regeXStringType) -> Bool

public static func isValueData(string: String,predicateString: String) -> Bool
```
### KVO：实现了观察者的自动释放
```
	/// 建立观察者与被观察者之间的联系
    ///
    /// - Parameters:
    ///   - object: 观察者
    ///   - keyPath: 观察目标
    ///   - target: 被观察对象
    ///   - selector: 响应
    /// - Returns: <#return value description#>
    @discardableResult
    public class func observer(object: NSObject, keyPath: String, target: AnyObject, selector: Selector) -> KVO {
        return KVO.init(object: object, keyPath: keyPath, target: target, selector: selector)
    }
```