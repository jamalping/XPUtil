//
//  UIViewController+Extension.swift
//  XPUtilExample
//
//  Created by Apple on 2018/12/31.
//  Copyright © 2018年 xyj. All rights reserved.
//

import UIKit

let keyWindow = UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first!
extension UIViewController {
    
    /// 获取栈顶控制器
    ///
    /// - Parameter currentVC: <#currentVC description#>
    /// - Returns: <#return value description#>
    static func getTopViewController(_ currentVC: UIViewController? = nil) -> UIViewController? {
        let viewController = currentVC ?? UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = viewController as? UINavigationController,
            !navigationController.viewControllers.isEmpty {
            
            return self.getTopViewController(navigationController.viewControllers.last)
            
        } else if let tabBarController = viewController as? UITabBarController, let selectedController = tabBarController.selectedViewController {
            
            return self.getTopViewController(selectedController)
            
        } else if let presentedController = viewController?.presentedViewController {
            
            return self.getTopViewController(presentedController)
            
        } else if let presentedController = viewController?.childViewControllers.filter({ (vc) -> Bool in
            let point = vc.view.convert(vc.view.center, to: keyWindow)
            return keyWindow.bounds.contains(point)
        }).last { // 有childViewControllers的，只取当前展示在window内的控制器
            
            return self.getTopViewController(presentedController)
        }
        
        return viewController
    }
}
