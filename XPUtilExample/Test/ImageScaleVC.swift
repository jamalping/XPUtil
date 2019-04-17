//
//  ImageScaleVC.swift
//  XPUtilExample
//
//  Created by Apple on 2019/4/17.
//  Copyright © 2019年 xyj. All rights reserved.
//

import UIKit

// MARK: - ImageView自适应图片
class ImageScaleVC: UIViewController {
    
    lazy var imageView = UIImageView()
//        .init(frame: CGRect.init(x: 10, y: 100, width: 400, height: 500))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(imageView)
//        guard let image  = ct_imageFromImage(image: UIImage.init(named: "r")!, rect: imageView.frame) else { return }
//        if image.size.height > image.size.width {
//        }
        guard let image = UIImage.init(named: "r") else { return }
        let scale = image.size.height/image.size.width
        imageView.size = CGSize.init(width: 300, height: 300*scale)
        imageView.image = image
        imageView.origin = CGPoint.init(x: 100, y: 100)
        imageView.contentMode = .scaleAspectFit
    }
    
    func config() {
        
        layout()
    }
    
    func layout() {
        
    }
}

func ct_imageFromImage(image: UIImage, rect: CGRect) -> UIImage? {
    let size = image.size
    let a = rect.size.width/rect.size.height
    var X: CGFloat = 0.0
    var Y: CGFloat = 0.0
    var W: CGFloat = 0.0
    var H: CGFloat = 0.0
    if size.width > size.height {
        H = size.height
        W = H*a
        Y = 0
        X = (size.width - W)/2
        if (size.width - size.height*a)/2<0 {
            W = size.width
            H = size.width/a
            Y = (size.height-H)/2
            X = 0
        }
    }else{
        
        W = size.width
        H = W/a
        X = 0
        Y = (size.height - H)/2
        
        if (size.height - size.width/a)/2<0 {
            
            H = size.height
            W = size.height*a
            X = (size.width-W)/2
            Y = 0
        }
        
    }
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    //    CGFloat scale = [UIScreen mainScreen].scale;
    let  dianRect = CGRect.init(x: X, y: Y, width: W, height: H)//CGRectMake(x, y, w, h);
//    CGImageCreateWithImageInRect
    guard let imageRef = image.cgImage?.cropping(to: dianRect) else { return nil }
    return UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)

    //截取部分图片并生成新图片
//
//    CGImageRef sourceImageRef = [image CGImage];
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
//
//    CGImageRelease(sourceImageRef);
//
//
//    return newImage;
}

//-(UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
//
//    CGSize size=image.size;
//
//
//    if (size.width>size.height) {
//
//        H= size.height;
//        W= H*a;
//        Y=0;
//        X=  (size.width - W)/2;
//
//        if ((size.width - size.height*a)/2<0) {
//
//            W = size.width;
//            H = size.width/a;
//            Y= (size.height-H)/2;
//            X=0;
//        }
//
//    }else{
//
//        W= size.width;
//        H= W/a;
//        X=0;
//        Y=  (size.height - H)/2;
//
//        if ((size.height - size.width/a)/2<0) {
//
//            H= size.height;
//            W = size.height*a;
//            X= (size.width-W)/2;
//            Y=0;
//        }
//
//    }
//
//    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
//    //    CGFloat scale = [UIScreen mainScreen].scale;
//    CGRect dianRect = CGRectMake(X, Y, W, H);//CGRectMake(x, y, w, h);
//
//    //截取部分图片并生成新图片
//    CGImageRef sourceImageRef = [image CGImage];
//    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
//
//    CGImageRelease(sourceImageRef);
//
//
//    return newImage;
//    ---------------------
//    作者：YoYo____u
//    来源：CSDN
//    原文：https://blog.csdn.net/youyou_56/article/details/82968475
//版权声明：本文为博主原创文章，转载请附上博文链接！
