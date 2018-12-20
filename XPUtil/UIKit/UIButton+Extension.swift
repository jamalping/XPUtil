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
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -margin/2, bottom: 0, right: margin/2)
        case .bottom:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: -lblH-margin/2, right: -lblW)
            self.titleEdgeInsets = UIEdgeInsets.init(top: -imgH-margin/2, left: -imgW, bottom: 0, right: 0)
        case .right:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: lblW+margin/2, bottom: 0, right: -lblW-margin/2)
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -lblW-margin/2, bottom: 0, right: imgW+margin/2)
        }
    }
}
