//
//  UIAlertViewController+Extension.swift
//  XPUtilExample
//
//  Created by Apple on 2019/6/5.
//  Copyright © 2019年 xyj. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func alert(with title:String,message:String,confirTitle:String = "确定",cancle:(()->Void)?,confir:(()->Void)?) ->UIAlertController{
        let alert =  UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action1 = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (_) in
            cancle?()
        }
        let action2 = UIAlertAction.init(title: confirTitle, style: UIAlertAction.Style.default) { (_) in
            confir?()
        }
        alert.addAction(action1)
        alert.addAction(action2)
        return alert
    }
}
