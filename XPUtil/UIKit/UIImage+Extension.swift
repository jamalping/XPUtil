//
//  UIImage+Extension.swift
//  Ecredit
//
//  Created by xyj on 2017/7/4.
//  Copyright © 2017年 xyjw. All rights reserved.
//

import UIKit
import ImageIO
import CoreGraphics
import AVFoundation
import MobileCoreServices

public extension UIImage {
    
    /// 获取图片的大小，多少bytes
     var bytesSize: Int { return self.jpegData(compressionQuality: 1)?.count ?? 0 }
    /// 获取图片的大小，多少kb
     var kiloBytesSize: Int {
        return self.bytesSize/1024
    }
    
     convenience init(color: UIColor) {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    
     convenience init?(fileName: String, bundle: Bundle = Bundle.main) {
        var path: String?
        if fileName.contains(".png") {
            path = bundle.path(forResource: fileName, ofType: nil)
        }else {
            path = bundle.path(forResource: fileName, ofType: ".png")
        }
        guard path != nil else { return nil }
        self.init(contentsOfFile: path!)
    }
    
    /// 是否有AlPha通道
     var hasAlphaChannnel: Bool {
        get {
            let alpha = self.cgImage?.alphaInfo
            return alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast
        }
    }
    
    
    // base64字符串转image
     convenience init?(base64ImgString: String) {
        let imageString = base64ImgString as NSString
        
        let dataString = imageString.replacingOccurrences(of:" ", with:"")
        
        let dataString1 = dataString.replacingOccurrences(of:"\n", with:"")
        
        let imageData = NSData(base64Encoded: dataString1, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        
        guard let data = imageData else { return nil }
        
        self.init(data: data as Data)
    }
    
    // image转base64字符串
     var toBase64String: String? {
        get {
            
            ///根据图片得到对应的二进制编码
            guard let imageData = self.jpegData(compressionQuality: 0.25) else {
                return nil
            }
            ///根据二进制编码得到对应的base64字符串
            let base64String = imageData.base64EncodedString(options: .lineLength76Characters)
            return base64String
        }
    }
    
     var toBase64StringPNG: String? {
        get {
            ///根据图片得到对应的二进制编码
            guard let imageData = self.pngData() else {
                return nil
            }
            ///根据二进制编码得到对应的base64字符串
            let base64String = imageData.base64EncodedString(options: .lineLength76Characters)
            return base64String
        }
        
    }
    
    /// 转换成Data
     var toImageJPEGData: Data? {
        get {
            guard let imageData = self.jpegData(compressionQuality: 0.25) else { return nil }
            return imageData
        }
    }
    
     var toImagePNGData: Data? {
        get {
            guard let imageData = self.pngData() else { return nil }
            return imageData
            
        }
    }
    
    
    /// 压缩图片
    ///
    /// - Parameters:
    ///   - maxLength: 最大长度
    /// - Returns:
     func compressImage(maxLength: Int) -> Data? {
        
        guard let vData = self.jpegData(compressionQuality: 1) else { return nil }
        
        if vData.count < maxLength {
            return vData
        }
        
        let newSize = self.scaleImages(imageLength: 1000)
        guard let newImage = self.resizeImage(newSize: newSize) else { return nil }
        
        var compress:CGFloat = 0.9
        guard var data = newImage.jpegData(compressionQuality: compress) else { return nil }
        
        while data.count > maxLength && compress > 0.01 {
            compress -= 0.02
            autoreleasepool {
                data = newImage.jpegData(compressionQuality: compress)!
            }
        }
        return data
    }
    
    
    /// 指定宽或高的最大值
    ///
    /// - Parameters:
    ///   - imageLength: 最大值
    /// - Returns: 按比例压缩后的尺寸
     func  scaleImages(imageLength: CGFloat) -> CGSize {
        
        var newWidth:CGFloat = 0.0
        var newHeight:CGFloat = 0.0
        let width = self.size.width
        let height = self.size.height
        
        if (width > imageLength || height > imageLength){
            
            if (width > height) {
                
                newWidth = imageLength;
                newHeight = newWidth * height / width;
                
            }else if(height > width){
                
                newHeight = imageLength;
                newWidth = newHeight * width / height;
                
            }else{
                
                newWidth = imageLength;
                newHeight = imageLength;
            }
            
        }
        return CGSize(width: newWidth, height: newHeight)
    }
    
    
    /// 压缩图片到指定大小
     func resizeImage(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(newSize)
        
        self.draw(in:CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    // 加载本地gif
     static func imageWithGifName(name: String) -> UIImage? {
    
        var animatedImage: UIImage?
        guard let path = Bundle.main.path(forResource: name, ofType: "gif") else { return nil }
        guard let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: path)) else { return nil }
        let sources = CGImageSourceCreateWithData(data as CFData, nil)
        guard let source = sources else {
            return nil
        }
        let count =   CGImageSourceGetCount(source)
        
        if (count <= 1) {
            animatedImage = UIImage.init(data: data)
        } else {
            var images = [UIImage]()
            for i in 0..<count {
                if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                    images.append(UIImage.init(cgImage: image, scale: UIScreen.main.scale, orientation: UIImage.Orientation.up))
                }
            }
            animatedImage = UIImage.animatedImage(with: images, duration: Double(count)*0.1)
        }
     
        return animatedImage
    }
        
    /// 获取某个点的UIColor
    ///
    /// - Parameter point: 目标点
    /// - Returns: UIColor
     func colorOfPoint(point: CGPoint)-> UIColor? {
        guard point.x >= 0 && point.y >= 0 else { return nil }
        guard let cgimage = self.cgImage else { return nil }
        let width = CGFloat(cgimage.width)
        let height = CGFloat(cgimage.height)
        guard point.x <= width && point.y <= height else { return nil }
        let pixelData = CGDataProvider.init(data: self.cgImage! as! CFData)

        let data:UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData?.data)
        let pixelInfo: Int = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    /// 生成一个圆角的图片
    ///
    /// - Parameters:
    ///   - radius: <#radius description#>
    ///   - sizetoFit: <#sizetoFit description#>
    /// - Returns: <#return value description#>
    func xp_drawRectWithRoundedCorner(radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect,byRoundingCorners: UIRectCorner.allCorners,cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output!
    }
    
    /// 异步设置圆角图片
    ///
    /// - Parameters:
    ///   - size:       图片大小
    ///   - radius:     圆角值
    ///   - fillColor:  裁切区域填充颜色
    ///   - completion: 回调裁切结果图片
    func cornerImage(size: CGSize, radius: CGFloat, fillColor: UIColor, completion: @escaping ((_ image: UIImage)->())) -> Void {
        
        //异步绘制裁切
        DispatchQueue.global().async {
            //利用绘图建立上下文
            UIGraphicsBeginImageContextWithOptions(size, true, 0)
            
            let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            //设置填充颜色
            fillColor.setFill()
            UIRectFill(rect)
            
            //利用贝塞尔路径裁切
            let path = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
            path.addClip()
            
            self.draw(in: rect)
            
            //获取结果
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            //关闭上下文
            UIGraphicsEndImageContext()
            
            //主队列回调
            DispatchQueue.main.async {
                completion(resultImage!)
            }
        }
    }

    func imageWithGif(iamges: [String]) {
        var destination: CGImageDestination?
        
        let document = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        var documentStr = document.first!
        let fileManager = FileManager.default
        
        let textDirectory = documentStr.append("/gif")

        try? fileManager.createDirectory(atPath: documentStr, withIntermediateDirectories: true, attributes: nil)
        
        let path = documentStr + "/example.gif"
        
        //创建CFURL对象
        let urlref = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, path as CFString, CFURLPathStyle.cfurlposixPathStyle, false)

        //通过一个url返回图像目标
        destination = CGImageDestinationCreateWithURL(urlref!, kUTTypeGIF, iamges.count, nil)

        //设置gif的信息,播放间隔时间,基本数据,和delay时间
        let frameProperties = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime :NSNumber.init(value: 0.3)]]


        var dict: [CFString: Any] = [
            kCGImagePropertyGIFHasGlobalColorMap: NSNumber.init(value: true),
            kCGImagePropertyColorModel: kCGImagePropertyColorModelRGB,
            kCGImagePropertyDepth: NSNumber.init(value: 7),
            kCGImagePropertyGIFLoopCount: NSNumber.init(value: 0)]
        
        let gifProperties = [kCGImagePropertyGIFDictionary: dict]

        //合成gif
        for img in iamges {
            CGImageDestinationAddImage(destination!, (UIImage.init(named: img)?.cgImage)!, frameProperties as CFDictionary)
            
//            CGImageDestinationAddImage(<#T##idst: CGImageDestination##CGImageDestination#>, <#T##image: CGImage##CGImage#>, <#T##properties: CFDictionary?##CFDictionary?#>)
            
        }

        CGImageDestinationSetProperties(destination!, gifProperties as CFDictionary)

    }
}

public extension UIImage {
    
    /// 获取url资源的第一帧
    ///
    /// - Parameters:
    ///   - videoUrl: <#videoUrl description#>
    ///   - time: 时间点
    /// - Returns: 图片
    class func getThumbnailImageForVideo(videoUrl: URL, time: TimeInterval) -> UIImage? {
        let asset = AVURLAsset.init(url: videoUrl)
        let imageGenerator = AVAssetImageGenerator.init(asset: asset)
        imageGenerator.apertureMode = .encodedPixels
        
        let imageRef = try? imageGenerator.copyCGImage(at: CMTime.init(seconds: time, preferredTimescale: 60), actualTime: nil)
        
        let image: UIImage? = (imageRef != nil) ? UIImage.init(cgImage: imageRef!) : nil
        return image
    }
}


/// VR 相关资源
var vrImagePaths: [String] {
    get {
        var vrs: [String] = [String]()
        for i in 1...75 {
            vrs.append(Bundle.main.path(forResource: String.init(format: "VR_%02d", i), ofType: "png")!)
        }
        return vrs
    }
}

var vrImages = vrImagePaths.compactMap { (vrImagePath) -> UIImage? in
    return UIImage.init(contentsOfFile: vrImagePath)
}

/// 播放帧动画的ImageView
class VrImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        _layer = CALayer()
        self.layer.addSublayer(_layer!)
        
        userDisplayLink()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var _displayLink: CADisplayLink?
    func userDisplayLink() {
        
        _displayLink = CADisplayLink.init(target: self, selector: #selector(updateImage))
        if #available(iOS 10.0, *) {
            _displayLink?.preferredFramesPerSecond = vrImages.count/3
        } else {
            _displayLink?.frameInterval = vrImages.count/3
        }
        _displayLink?.add(to: RunLoop.main, forMode: .common)
    }
    
    var _layer: CALayer?
    override func layoutSubviews() {
        super.layoutSubviews()
        _layer?.bounds = self.frame
        _layer?.position = CGPoint.init(x: self.frame.width/2, y: self.frame.height/2)
    }
    
    var _index = 0
    @objc func updateImage() {
        let image = vrImages[_index]
        _layer?.contents = image.cgImage
        _index = (_index + 1)%vrImages.count
    }
    
    deinit {
        deinitDisplayLink()
    }
    
    func deinitDisplayLink() {
        print("销毁_displayLink")
        _displayLink?.invalidate()
        _displayLink = nil
    }
}

// MARK: - 渐变色图片
//extension UIImage {
//
//    /// 渐变色方向
//     enum Directions: Int {
//        case right = 0
//        case left
//        case bottom
//        case top
//        case topLeftToBottomRight
//        case topRightToBottomLeft
//        case bottomLeftToTopRight
//        case bottomRightToTopLeft
//    }
//
//     class func gradientColor(_ startColor: UIColor, endColor: UIColor, size: CGSize, direction: Directions = UIImage.Directions.right) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        let context = UIGraphicsGetCurrentContext()
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let colors = [startColor.cgColor, endColor.cgColor]
//
//        guard let gradient: CGGradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil) else { return nil }
//
//        var startPoint: CGPoint
//        var endPoint: CGPoint
//        switch direction {
//        case .left:
//            startPoint = CGPoint.init(x: size.width, y: 0.0)
//            endPoint = CGPoint.init(x: 0.0, y: 0.0)
//        case .right:
//            startPoint = CGPoint.init(x: 0.0, y: 0.0)
//            endPoint = CGPoint.init(x: size.width, y: 0.0)
//        case .bottom:
//            startPoint = CGPoint.init(x: 0.0, y: 0.0)
//            endPoint = CGPoint.init(x: 0.0, y: size.height)
//        case .top:
//            startPoint = CGPoint.init(x: 0.0, y: size.height)
//            endPoint = CGPoint.init(x: 0.0, y: 0.0)
//        case .topLeftToBottomRight:
//            startPoint = CGPoint.init(x: 0.0, y: 0.0)
//            endPoint = CGPoint.init(x: size.width, y: size.height)
//        case .topRightToBottomLeft:
//            startPoint = CGPoint.init(x: size.width, y: 0.0)
//            endPoint = CGPoint.init(x: 0.0, y: size.height)
//        case .bottomLeftToTopRight:
//            startPoint = CGPoint.init(x: 0.0, y: size.height)
//            endPoint = CGPoint.init(x: size.width, y: 0.0)
//        case .bottomRightToTopLeft:
//            startPoint = CGPoint.init(x: size.width, y: size.height)
//            endPoint = CGPoint.init(x: 0.0, y: 0.0)
//        }
//
//        context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
//
//        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
//        UIGraphicsEndImageContext()
//        return image
//    }
//}
