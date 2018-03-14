//
//  SZBaseViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZBaseViewController: UIViewController {
    
    // 自定义导航条
    lazy var navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 64))
    
    // 自定义导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    // 重写 title didSet 方法
    override var title: String? {
        
        didSet {
            
            navItem.title = title
        }
    }

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
        
        setStatusBarBackgroundColor(color: UIColor.withHex(hexInt: 0xf6f6f6))
        
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将 item 设置给bar
        navigationBar.items = [navItem]
        
        // 设置 navigationBar 渲染颜色
        navigationBar.barTintColor = UIColor.colorWithHex(hexString: "f6f6f6")
        
        // 设置 navigationBar 标题字体颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.withHex(hexInt: 0x323232)]
    }
    
    /// 设置状态栏背景颜色
    private func setStatusBarBackgroundColor(color : UIColor) {
        
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        
        /*
         if statusBar.responds(to:Selector("setBackgroundColor:")) {
         statusBar.backgroundColor = color
         }*/
        
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
}









