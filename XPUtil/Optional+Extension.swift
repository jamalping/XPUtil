//
//  Optional+Extension.swift
//  XPUtilExample
//
//  Created by Apple on 2019/6/27.
//  Copyright © 2019 xyj. All rights reserved.
//


public extension Optional {
    
    /// 是否是空
    var isNone: Bool {
        switch self {
        case .none:
            return true
        case .some:
            return false
        }
    }
    
    /// 是否有值
    var isSome: Bool {
        return !self.isNone
    }
    
    
    /// 返回可选值或默认值
    /// - Parameter default: 如果可选值为空，将会默认值
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    
    /// 当可选值不为空时，执行 `some` 闭包
    func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }
    
    /// 当可选值为空时，执行 `none` 闭包
    func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
    
    /// 可选值不为空且可选值满足 `predicate` 条件才返回，否则返回 `nil`
    ///
    /// 仅会影响 id < 1000 的用户
    /// 正常写法
    /// if let aUser = user, user.id < 1000 { aUser.upgradeToPremium() }
    /// 使用 `filter`
    /// user.filter({ $0.id < 1000 })?.upgradeToPremium()
    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let unwrapped = self,
            predicate(unwrapped) else { return nil }
        return self
    }
    
}
