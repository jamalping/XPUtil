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
    
    /// 添加毛玻璃效果
    public func addVisualEffect(){
        /// 高斯模糊视图
        let blurView: UIVisualEffectView = {
            let blureffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blureffect)
            return blurView
        }()
        
        self.addSubview(blurView)
        if self.bounds == .zero {
            let views: [String: Any] = ["superV": blurView.superview as Any]
            let hConstrain = NSLayoutConstraint.constraints(withVisualFormat: "H:|[superV]|", options: [], metrics: nil, views: views)
            let vConstrain = NSLayoutConstraint.constraints(withVisualFormat: "V:|[superV]|", options: [], metrics: nil, views: views)
            blurView.addConstraints([hConstrain, vConstrain].flatMap{return $0})
        }else {
            blurView.frame = self.bounds
        }
        
    }
}

// MARK: - 渐变色处理
extension UIView {
    
    /// 添加从左到右的渐变色
    ///
    /// - Parameters:
    ///   - startColor: 最左边的颜色
    ///   - endColor: 最右边的颜色
    ///   - radius: 圆角
    /// - Returns: 返回layer用来移除 可不接收返回值
    @discardableResult
    public func addGradientLayer(startColor:CGColor, endColor:CGColor, radius:CGFloat = 0) -> CAGradientLayer {
        
        let gradient:CAGradientLayer = CAGradientLayer.init()
        gradient.colors = [startColor, endColor]
        gradient.startPoint = CGPoint.init(x: 0, y: 0)
        gradient.endPoint = CGPoint.init(x: 1, y: 0)
        gradient.frame = self.bounds
        gradient.cornerRadius = radius
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    
    public func getGradientImage(startColor:CGColor, endColor:CGColor, radius:CGFloat = 0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [startColor, endColor]
        
        guard let gradient: CGGradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil) else { return nil }
        
        let startPoint = CGPoint.init(x: 0.0, y: 0.0)
        let endPoint = CGPoint.init(x: self.frame.size.width, y: 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
}


// MARK: - 添加边框线
//public extension UIView {
//    // MARK: - 虚线
//    public struct UIRectSide : OptionSet {
//
//        public let rawValue: Int
//
//        public static let left = UIRectSide(rawValue: 1 << 0)
//
//        public static let top = UIRectSide(rawValue: 1 << 1)
//
//        public static let right = UIRectSide(rawValue: 1 << 2)
//
//        public static let bottom = UIRectSide(rawValue: 1 << 3)
//
//        public static let all: UIRectSide = [.top, .right, .left, .bottom]
//
//        public init(rawValue: Int) {
//
//            self.rawValue = rawValue;
//        }
//    }
//
//    ///画虚线边框
//    func drawDashLine(strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5, corners: UIRectSide) {
//        if self.bounds.equalTo(.zero) {
//            self.setNeedsLayout()
//            self.layoutIfNeeded()
//        }
//
//        #if DEBUG
//        assert(!self.bounds.equalTo(.zero), "请先设置frame")
//        #endif
//
//        let shapeLayer = CAShapeLayer()
//
//        shapeLayer.bounds = self.bounds
//
//        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
//
//        shapeLayer.fillColor = UIColor.blue.cgColor
//
//        shapeLayer.strokeColor = strokeColor.cgColor
//
//        shapeLayer.lineWidth = lineWidth
//
//        shapeLayer.lineJoin = kCALineJoinRound
////            CAShapeLayerLineJoin.round
//
//        //每一段虚线长度 和 每两段虚线之间的间隔
//        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
//
//        let path = CGMutablePath()
//
//        if corners.contains(.left) {
//
//            path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
//
//            path.addLine(to: CGPoint(x: 0, y: 0))
//
//        }
//
//        if corners.contains(.top){
//
//            path.move(to: CGPoint(x: 0, y: 0))
//
//            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
//
//        }
//
//        if corners.contains(.right){
//
//            path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
//
//            path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
//
//        }
//
//        if corners.contains(.bottom){
//
//            path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
//
//            path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
//
//        }
//
//        shapeLayer.path = path
//
//        self.layer.addSublayer(shapeLayer)
//
//    }
//
//    ///画实线边框
//    func drawLine(strokeColor: UIColor, lineWidth: CGFloat = 1, corners: UIRectSide) {
//
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        #if DEBUG
//        assert(!self.bounds.equalTo(.zero), "请先设置frame")
//        #endif
//
//        if corners == UIRectSide.all {
//
//            self.layer.borderWidth = lineWidth
//
//            self.layer.borderColor = strokeColor.cgColor
//
//        }else{
//
//            let shapeLayer = CAShapeLayer()
//
//            shapeLayer.bounds = self.bounds
//
//            shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
//
//            shapeLayer.fillColor = UIColor.blue.cgColor
//
//            shapeLayer.strokeColor = strokeColor.cgColor
//
//            shapeLayer.lineWidth = lineWidth
//
//            shapeLayer.lineJoin = kCALineJoinRound
////                CAShapeLayerLineJoin.round
//
//            let path = CGMutablePath()
//
//            if corners.contains(.left) {
//
//                path.move(to: CGPoint(x: 0, y: self.layer.bounds.height))
//
//                path.addLine(to: CGPoint(x: 0, y: 0))
//
//            }
//
//            if corners.contains(.top){
//
//                path.move(to: CGPoint(x: 0, y: 0))
//
//                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: 0))
//
//            }
//
//            if corners.contains(.right){
//
//                path.move(to: CGPoint(x: self.layer.bounds.width, y: 0))
//
//                path.addLine(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
//
//            }
//
//            if corners.contains(.bottom){
//
//                path.move(to: CGPoint(x: self.layer.bounds.width, y: self.layer.bounds.height))
//
//                path.addLine(to: CGPoint(x: 0, y: self.layer.bounds.height))
//
//            }
//
//            shapeLayer.path = path
//
//            self.layer.addSublayer(shapeLayer)
//        }
//    }
//
//}

// MARK: - 圆角处理
extension UIView {
    
    /// 圆角的裁剪
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角度数
    /// eg: view.addCornerRadius(byRoundingCorners: [.bottomLeft, .bottomRight], radii: 50)
    public func addCornerRadius(byRoundingCorners corners: UIRectCorner = .allCorners, radii: CGFloat) {
        
        assert(self.frame != .zero, "请先确认当前View已经布局完成")
        //创建贝塞尔,指定画圆角的地方为下方的左，右两个角添加阴影
        let mask: UIBezierPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radii, height: radii))
        let shape:CAShapeLayer = CAShapeLayer()
        //Layer的线为贝塞尔曲线
        shape.path = mask.cgPath
        self.layer.mask = shape
    }
    
    /// 添加圆角和阴影
    /// 使用该方法必须先设置View的frame
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - shadowOpacity: 阴影透明度 (0-1)
    ///   - shadowColor: shadowColor: 阴影颜色
    func addRoundedAndShadow(radius:CGFloat, shadowOpacity:CGFloat, shadowColor:UIColor)  {
        addCornerRadius(byRoundingCorners: .allCorners, radii: radius)
        let subLayer = CALayer()
        assert(self.frame != .zero, "请先确认当前View已经布局完成")
        let fixframe = self.frame
        
        subLayer.frame = fixframe
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = shadowColor.cgColor // 阴影颜色
        subLayer.shadowOffset = CGSize(width: 0, height: 0) // 阴影偏移,width:向右偏移3，height:向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = Float(shadowOpacity) //阴影透明度
        subLayer.shadowRadius = 3;//阴影半径，默认3
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
    }
    
    
    /// 裁剪圆角并增加边框
    ///
    /// - Parameters:
    ///   - radius: 圆角度数
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    public func addRadiusAndBorder(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        addCornerRadius(byRoundingCorners: .allCorners, radii: radius)
        let subLayer = CALayer()
        guard self.frame != .zero else {
            return
        }
        let fixframe = self.frame
        
        subLayer.frame = fixframe
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.borderWidth = borderWidth
        subLayer.borderColor = borderColor.cgColor
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
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

