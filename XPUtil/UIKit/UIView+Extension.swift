//
//  UIView+Extension.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/28.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit

// MARK: 坐标处理
public extension UIView {

    public var left: CGFloat {
        set { self.frame.origin.x = newValue }
        get { return self.frame.minX }
    }
    public var top: CGFloat {
        set { self.frame.origin.y = newValue }
        get { return self.frame.minY }
    }
    public var right: CGFloat {
        set { self.frame.origin.x = newValue - self.frame.width }
        get { return self.frame.maxX }
    }
    public var bottom: CGFloat {
        set { self.frame.origin.y = newValue - self.frame.maxY }
        get { return self.frame.maxY }
    }
    
    public var width: CGFloat {
        set { self.frame.size.width = newValue }
        get { return self.frame.width }
    }
    
    public var height: CGFloat {
        set { self.frame.size.height = newValue }
        get { return self.frame.height }
    }
    public var centerX: CGFloat {
        set { self.center = CGPoint.init(x: newValue, y: self.center.y) }
        get { return self.center.x }
    }
    
    public var centerY: CGFloat {
        set { self.center = CGPoint.init(x: self.center.x, y: newValue) }
        get { return self.center.y }
    }
    
    public var size: CGSize {
        set { self.frame = CGRect.init(origin: self.frame.origin, size: newValue) }
        get { return self.frame.size }
    }
    public var origin: CGPoint {
        set { self.frame = CGRect.init(origin: newValue, size: self.frame.size) }
        get { return self.frame.origin }
    }
}

public extension UIView {
    
    /// 获取view的vc
    public var viewController: UIViewController? {
        var next:UIView? = self
        repeat{
            if let nextResponder = next?.next, nextResponder is UIViewController {
                return (nextResponder as! UIViewController)
            }
            next = next?.superview
        } while next != nil
        
        return nil
    }
    /// 移除当前视图的所有子视图
    public func removeAllSubviews() -> Void {
        _ = self.subviews.map { $0.removeFromSuperview()}
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    /// eg: view.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: 50)
    public func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        
        //创建贝塞尔,指定画圆角的地方为下方的左，右两个角添加阴影
        let mask: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radii, height: radii))
        let shape:CAShapeLayer = CAShapeLayer()
        shape.fillColor = UIColor.gray.cgColor
        //Layer的线为贝塞尔曲线
        shape.path = mask.cgPath
        shape.frame = self.bounds;
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.init(width: 1, height: 2)
        self.layer.shadowRadius = radii
        self.layer.addSublayer(shape)
    }
    
    public convenience init(backGroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backGroundColor
    }
    
    /// 截取整个View
    ///
    /// - Parameter save: 是否保存到系统相册
    public func screenShot(_ save: Bool) -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 保存到相册
        if save {
            UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
        }
        return image
    }
}

// MARK: 关联 StoryBoard 和 XIB
extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    public var borderWidth: CGFloat {
        get { return self.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor? {
        get { return self.borderColor }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var shadowRadius: CGFloat {
        get {
            return self.shadowRadius
        }
        
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    public var shadowOpacity: Float {
        get { return self.shadowOpacity }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    public var shadowColor: UIColor? {
        get { return self.shadowColor }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    public var shadowOffset: CGSize {
        get { return self.shadowOffset }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    public var zPosition: CGFloat {
        get { return self.zPosition }
        set {
            layer.zPosition = newValue
        }
    }

}

// MARK: XIB初始化
public protocol Nibloadable {
    
}

public extension Nibloadable where Self : UIView {
    
    public static func loadNib(_ nibNmae :String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}

