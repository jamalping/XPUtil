//
//  UIButton+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/4.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import UIKit


public extension UIButton {
    
    // MARK: --- 表单提交按钮
    public convenience init(formBtnTitle: String) {
        self.init(type: .custom)
        setTitle(formBtnTitle, for: .normal)
        
        setBackgroundImage(UIImage.init(color: UIColor.red), for: .normal)
        setBackgroundImage(UIImage.init(color: UIColor.gray), for: .disabled)
        setBackgroundImage(UIImage.init(color: UIColor.blue), for: .highlighted)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        titleLabel?.textAlignment = .center
        isEnabled = false
    }
    
    // MARK: --- 分段选择器按钮的创建
    public convenience init(title: String, bNormalImg: UIImage?, bSelectedImg: UIImage?){
        self.init(type: .custom)
        self.setBackgroundImage(bNormalImg, for: .normal)
        self.setBackgroundImage(bSelectedImg, for: .selected)
        self.setTitleColor(.white, for: .selected)
//        self.setTitleColor(UIColor.titleTextColor, for: .normal)
        self.adjustsImageWhenHighlighted = false
        self.setTitle(title, for: .normal)
    }
    
    // 只有默认背景
    public convenience init(normalbackgroundImage: String) {
        self.init()
        self.setBackgroundImage(UIImage(named: normalbackgroundImage), for: .normal)
    }
    
    // 创建一般按钮
    public convenience init(title: String, titleColor: UIColor, backGroundColor: UIColor, font: UIFont = .systemFont(ofSize: 13)) {
        self.init()
        self.backgroundColor = backGroundColor
        
        self.setTitle(title, for: UIControlState())
        
        self.titleLabel?.font = font
        
        self.setTitleColor(titleColor, for: UIControlState())
        
        self.layer.cornerRadius = 5
        
        self.layer.masksToBounds = true
    }
    
    public convenience init(title: String, titleColor: UIColor, normalImg: UIImage, selectedimg: UIImage) {
        self.init()
        
        self.setTitle(title, for: .normal)
        
        self.setTitleColor(titleColor, for: .normal)
        
        self.setImage(normalImg, for: .normal)
        
        self.setImage(selectedimg, for: .selected)
        
    }
}

/// 按钮布局方式
///
/// - top: image 上，labal下
/// - left: image 左，label右
/// - right: <#right description#>
/// - bottom: <#bottom description#>
public enum ButtonEdgeInsetStyle {
    case top
    case left
    case right
    case bottom
}

public extension UIButton {
    /// 按钮布局
    ///
    /// - Parameters:
    ///   - edgeInsetStyle: 布局方式
    ///   - margin: image和Label之间的间隙
    func layoutSubView(edgeInsetStyle: ButtonEdgeInsetStyle, margin: CGFloat = 5) {
        
        let imgW = self.imageView?.image?.size.width ?? 0
        let imgH = self.imageView?.image?.size.height ?? 0
        let lblW:CGFloat = self.titleLabel!.intrinsicContentSize.width
        let lblH:CGFloat = self.titleLabel!.intrinsicContentSize.height
        
        switch edgeInsetStyle {
        case .top:
            self.imageEdgeInsets = UIEdgeInsets.init(top: -lblH-margin/2, left: 0, bottom: 0, right: -lblW)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imgW, bottom: -imgH-margin/2, right: 0)
        case .left:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -margin/2, bottom: 0, right: margin/2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: margin/2, bottom: 0, right: -margin/2)
        case .bottom:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: -lblH-margin/2, right: -lblW)
            self.titleEdgeInsets = UIEdgeInsets.init(top: -imgH-margin/2, left: -imgW, bottom: 0, right: 0)
        case .right:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: lblW+margin/2, bottom: 0, right: -lblW-margin/2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -lblW-margin/2, bottom: 0, right: imgW+margin/2)
        }
    }
}

// MARK: - 扩大按钮的响应区域
var TSButtonExtensionKayTopEdge = "TSButtonExtensionKayTopEdge"
var TSButtonExtensionKayRightEdge = "TSButtonExtensionKayRightEdge"
var TSButtonExtensionKayBottomEdge = "TSButtonExtensionKayBottomEdge"
var TSButtonExtensionKayLeftEdge = "TSButtonExtensionKayLeftEdge"
extension UIButton {
    /// 设置按钮扩大的响应区域
    /// 上、左、下、右均相同的距离
    func setEnlargeResponseAreaEdge(size: Float) {
        objc_setAssociatedObject(self, &TSButtonExtensionKayTopEdge, NSNumber(value: size), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &TSButtonExtensionKayRightEdge, NSNumber(value: size), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &TSButtonExtensionKayBottomEdge, NSNumber(value: size), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &TSButtonExtensionKayLeftEdge, NSNumber(value: size), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    /// 设置按钮扩大的响应区域
    /// 上、左、下、右单独设置
    func setEnlargeResponseAreaEdge(top: Float, left: Float, bottom: Float, right: Float) {
        objc_setAssociatedObject(self, &TSButtonExtensionKayTopEdge, NSNumber(value: top), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &TSButtonExtensionKayLeftEdge, NSNumber(value: left), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &TSButtonExtensionKayBottomEdge, NSNumber(value: bottom), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        objc_setAssociatedObject(self, &TSButtonExtensionKayRightEdge, NSNumber(value: right), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    /// 获取扩展后的响应区域Rect
    func enlargedResponseAreaRect() -> CGRect {
        let topEdge = objc_getAssociatedObject(self, &TSButtonExtensionKayTopEdge) as? NSNumber
        let leftEdge = objc_getAssociatedObject(self, &TSButtonExtensionKayLeftEdge) as? NSNumber
        let rightEdge = objc_getAssociatedObject(self, &TSButtonExtensionKayRightEdge) as? NSNumber
        let bottomEdge = objc_getAssociatedObject(self, &TSButtonExtensionKayBottomEdge) as? NSNumber
        if topEdge != nil && leftEdge != nil && bottomEdge != nil && rightEdge != nil {
            let topEdgeFloat = CGFloat((topEdge?.floatValue)!)
            let leftEdgeFloat = CGFloat((leftEdge?.floatValue)!)
            let bottomEdgeFloat = CGFloat((bottomEdge?.floatValue)!)
            let rightEdgeFloat = CGFloat((rightEdge?.floatValue)!)
            return CGRect(x: self.bounds.origin.x - leftEdgeFloat, y: self.bounds.origin.y - topEdgeFloat, width: self.bounds.size.width + leftEdgeFloat + rightEdgeFloat, height: self.bounds.size.height + topEdgeFloat + bottomEdgeFloat)
        } else {
            return self.bounds
        }
    }
    /// 计算当前区域是否需要响应当前事件
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let curentRect = self.enlargedResponseAreaRect()
        if curentRect == self.bounds {
            return super.point(inside: point, with: event)
        } else {
            return curentRect.contains(point)
        }
    }
}
