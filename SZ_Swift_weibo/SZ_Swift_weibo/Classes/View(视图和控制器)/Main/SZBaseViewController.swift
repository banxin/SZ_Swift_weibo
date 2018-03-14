//
//  SZBaseViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

// MARK: - 设置界面
extension SZBaseViewController {
    
    // 如果子类需要重写该方法，必须使用 @objc dynamic 修饰，Swift 本身不支持 extension 中方法的重写，需要使用OC的机制曲线实现
    @objc dynamic func setupUI() {
        
        // 取消自动缩进，如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = UIColor().randomColor
    }
}
