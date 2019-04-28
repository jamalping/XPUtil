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
        guard let image = UIImage.init(named: "t") else { return }
        guard let imageData = image.toImageJPEGData else { return }
        imageData.forEach { (bety) in
//            print(bety)
        }
        let w = pngImageSizeWithHeaderData(imgdata: imageData)
        let scale = image.size.height/image.size.width
        imageView.size = CGSize.init(width: 300, height: 300)
        imageView.image = image
        imageView.backgroundColor = .red
        
        imageView.origin = CGPoint.init(x: 100, y: 100)
        imageView.contentMode = .scaleAspectFill
        
        let url = URL.init(string: "http://kuaiqiav2.oss-cn-shenzhen.aliyuncs.com/photo/20190417/2_20190417141209545.jpg?x-oss-process=image/info")!
        let request = URLRequest.init(url: url)
        guard let data = try? Data.init(contentsOf: url) else { return }
        let dataString = String.init(data: data, encoding: String.Encoding.utf8)
        print(dataString)
    }
    
    func config() {
        
        layout()
    }
    
    func layout() {
        
    }
}

func pngImageSizeWithHeaderData(imgdata: Data) -> CGSize
{
    var w1 = 0.0
    var w2 = 0.0
    var w3 = 0.0
    var w4 = 0.0
    let index0 = imgdata.index(imgdata.startIndex, offsetBy: 1)
    let index1 = imgdata.index(index0, offsetBy: 1)
    let index2 = imgdata.index(index1, offsetBy: 1)
    let index3 = imgdata.index(index2, offsetBy: 1)
    var w: CGFloat = 0
    var h: CGFloat = 0
    imgdata.enumerated().forEach { (index, element) in
        if index <= 3 {
            w += CGFloat(element << ((3-index)*8))
            
        }else if index <= 7 {
            h += CGFloat(element << ((7-index)*8))
        }
    }
    return CGSize.init(width: w, height: h)
//    imgdata.copyBytes(to: w1, from: imgdata.index(0, offsetBy: 1))
//    imgdata.copyBytes(to: &w1, from: imgdata.index(0, offsetBy: 1))
//    [data getBytes:&w1 range:NSMakeRange(0, 1)];
//    [data getBytes:&w2 range:NSMakeRange(1, 1)];
//    [data getBytes:&w3 range:NSMakeRange(2, 1)];
//    [data getBytes:&w4 range:NSMakeRange(3, 1)];
//    int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
//
//    int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
//    [data getBytes:&h1 range:NSMakeRange(4, 1)];
//    [data getBytes:&h2 range:NSMakeRange(5, 1)];
//    [data getBytes:&h3 range:NSMakeRange(6, 1)];
//    [data getBytes:&h4 range:NSMakeRange(7, 1)];
//    int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
//
//    return CGSizeMake(w, h);
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
