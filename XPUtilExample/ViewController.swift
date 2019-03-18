//
//  ViewController.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/30.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit
import XPTool

class ViewController: UIViewController {

    var s: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gradientColor(UIColor.black, toColor: UIColor.red, size: self.view.size, direction: .topLeftToBottomRight)

        self.s = "a"
        let sss = Selector.init(("fff"))
        KVO.observer(object: self, keyPath: "s", target: self, selector: sss)
        self.s = "b"
        
        let ddView = UIView.init(frame: CGRect.init(x: 300, y: 100, width: 100, height: 100))
        view.addSubview(ddView)
        ddView.corner(byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radii: 50)
        
        
        // 圆角图片
        let imgView = UIImageView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        var image = UIImage.init(color: .red)
//        image.cornerImage(size: CGSize.init(width: 100, height: 100), radius: 50, fillColor: .red, completion: { (img) in
//            imgView.image = img
//        })
        image = image.xp_drawRectWithRoundedCorner(radius: 50, CGSize.init(width: 100, height: 100))
        imgView.image = image
        if let url = URL.init(string: "http://u2-test.img.ugirls.tv/ugcv/cma_4329841_8nk63aox.mp4") {
            
            let image = UIImage.getThumbnailImageForVideo(videoUrl: url, time: 1)
            imgView.image = image
        }
//        imgView.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        self.view.addSubview(imgView)

        let aview = UIView.init(frame: CGRect.init(x: 100, y: 300, width: 100, height: 200))
        aview.backgroundColor = .gray
        aview.circleView()
        self.view.addSubview(aview)
        
        let vView = UIView.init(frame: CGRect.init(x: 100, y: 480, width: 200, height: 200))
        vView.backgroundColor = .blue
        vView.backgroundColor = UIColor.gradientColor(.red, toColor: .cyan, size: vView.size, direction: .right)
        self.view.addSubview(vView)
    }
    
    func fff() {
        print("sd")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
