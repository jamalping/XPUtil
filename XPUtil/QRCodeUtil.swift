//
//  QRCodeUtil.swift
//  ML
//
//  Created by midland on 2019/4/1.
//  Copyright © 2019年 杨帅. All rights reserved.
//

import UIKit
import CoreImage

public class QRCodeUtil {
    
    public static func setQRCodeToImageView(_ imageView: UIImageView?, _ url: String?, _ centerLogo: String?) {
        
        if imageView == nil || url == nil {
            return
        }
        
        // 创建二维码滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 恢复滤镜默认设置
        filter?.setDefaults()
        
        // 设置滤镜输入数据
        let data = url!.data(using: String.Encoding.utf8)
        filter?.setValue(data, forKey: "inputMessage")
        
        // 设置二维码的纠错率
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        
        // 从二维码滤镜里面, 获取结果图片
        var image = filter?.outputImage
        
        // 生成一个高清图片
        let transform = CGAffineTransform.init(scaleX: 20, y: 20)
        image = image?.transformed(by: transform)
        
        // 图片处理
        var resultImage = UIImage(ciImage: image!)
        
        // 中间的logo
        var center = UIImage(named: "log-logo.png")
        if let url = URL(string: centerLogo ?? "") {
            do {
                let data = try Data(contentsOf: url)
                center = UIImage(data: data)
            } catch let error as NSError {
                print(error)
            }
        }
        // 设置二维码中心显示的小图标
        resultImage = getClearImage(sourceImage: resultImage, center: center!)
        
        // 显示图片
        imageView?.image = resultImage
    }
    
    // 使图片放大也可以清晰
    static func getClearImage(sourceImage: UIImage, center: UIImage) -> UIImage {
        
        let size = sourceImage.size
        // 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 绘制大图片
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 绘制二维码中心小图片
        let width: CGFloat = 120
        let height: CGFloat = 120
        let x: CGFloat = (size.width - width) * 0.5
        let y: CGFloat = (size.height - height) * 0.5
        // 方形
        // center.draw(in: CGRect(x: x, y: y, width: width, height: height))
        
        // 画圆
        let path = UIBezierPath.init(ovalIn: CGRect.init(x: x, y: y, width: width, height: height))
        //裁切
        path.addClip()
        //3.绘制图像
        center.draw(in: CGRect.init(x: x, y: y, width: width, height: height))
        
        
        // 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}

