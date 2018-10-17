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
        // Do any additional setup after loading the view, typically from a nib.
//        self.navigationController?.viewControllers.append(contentsOf: [UIViewController()])
//        let size = CGSize.init(width: 1, height: 1)
//        let fromColor = UIColor.red
//        let toColor = UIColor.blue
//        self.view.backgroundColor = UIColor.gradientColor(UIColor.black, toColor: UIColor.white, height: self.view.height)
//        self.view.colorof
//        let ccc = []
        self.s = "a"
        let sss = Selector.init(("fff"))
        KVO.observer(object: self, keyPath: "s", target: self, selector: sss)
        self.s = "b"
        
        let ddView = UIView.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(ddView)
        ddView.corner(byRoundingCorners: [.bottomLeft, .bottomRight], radii: 50)
    }
    
    func fff() {
        print("sd")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

