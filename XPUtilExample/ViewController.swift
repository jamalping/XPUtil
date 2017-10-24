//
//  ViewController.swift
//  XPUtilExample
//
//  Created by xyj on 2017/9/30.
//  Copyright © 2017年 xyj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.viewControllers.append(contentsOf: [UIViewController()])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

