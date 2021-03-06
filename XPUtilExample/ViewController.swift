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

    enum TestType: String {
        case keyChainTool
        case imageScale
    }
    @IBOutlet weak var tableView: UITableView!
    
    var tableDataSource: [TestType] = [.keyChainTool, .imageScale]
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
        
        ddView.addCornerRadius(byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft, .topRight], radii: 50)
        
        
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

        
        
        let vView = UIView.init(frame: CGRect.init(x: 100, y: 480, width: 200, height: 200))
        vView.backgroundColor = .blue
        vView.backgroundColor = UIColor.gradientColor(.red, toColor: .cyan, size: vView.size, direction: .right)
        self.view.addSubview(vView)
        
        var images: [String] = []
        for i in 1...75 {
            let imageString = String.init(format: "VR_%02d", i)
//            let imageString = "VR_\(i)"
            images.append(imageString)
        }
        let imagess = images.map { (imageString) -> UIImage in
            return UIImage.init(named: imageString)!
        }
        let imgVieww = UIImageView()
        imgVieww.frame = CGRect.init(x: 100, y: 280, width: 200, height: 200)
        imgVieww.animationImages = imagess
        imgVieww.animationDuration = 3
        imgVieww.startAnimating()
        view.addSubview(imgVieww)
        
        UIImage().imageWithGif(iamges: images)
//        let ddView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
//        view.addSubview(ddView)
//        ddView.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: 50)
    }
    
    func fff() {
        print("sd")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.tableDataSource[indexPath.row].rawValue
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.tableDataSource[indexPath.row] {
        case .keyChainTool:
            print("keyChainTool test")
            self.navigationController?.pushViewController(keyChainToolTestVC(), animated: true)
        case .imageScale: // 自适应图片
            self.navigationController?.pushViewController(ImageScaleVC(), animated: true)
        }
        
    }
}
