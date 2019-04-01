//
//  keyChainToolTestVC.swift
//  XPUtilExample
//
//  Created by jamalping on 2019/3/24.
//  Copyright © 2019年 xyj. All rights reserved.
//

import UIKit


final class User: Codable, CustomStringConvertible {
    var name = "jamal"
    var age = 22
    
    public var description: String {
        return "\(self.name)" + "\(self.age)"
    }
}

extension User: TypeSafeKeychainValue {
    
    func data() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func value(data: Data) -> User? {
        guard let model: User = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return model
    }
}

class keyChainToolTestVC: UIViewController {
    
    let num = "num"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "keyChainToolTest"
        
        save()
        
        get()
    }
    
    func save(key: String = "num") {
        
        KeychainTool.set(User(), forKey: key)
    }
    
    func get(key: String = "num") {
        guard let value: User = KeychainTool.value(forKey: key) else {
            return
        }
        print(value.description)
    }
}
