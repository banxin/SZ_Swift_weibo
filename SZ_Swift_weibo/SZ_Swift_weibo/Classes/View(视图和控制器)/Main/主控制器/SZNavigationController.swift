//
//  SZNavigationController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZNavigationController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // 隐藏默认的 navigationBar
        navigationBar.isHidden = true
    }
    
    /// 重写 push 方法，所有的 push 动作都会调用此方法
    // viewController 就是被 push 的控制器，设置 左侧按钮作为返回按钮
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        // 如果不是栈底控制器才需要隐藏，根控制器不需要处理
        if childViewControllers.count > 0 {
            
            // 隐藏底部的 tabbar
            viewController.hidesBottomBarWhenPushed = true
            
            // 判断控制器的类型
            if let vc = viewController as? SZBaseViewController {
                
                var title = "返回"
                
                // 判断控制器的 级数，只有一个子控制器，显示栈顶控制器的标题
                if childViewControllers.count == 1 {
                    
                    // 返回按钮的title 显示 首页标题
                    title = childViewControllers.first?.title ?? "返回"
                }
                
                // 取出 nav item，设置左侧按钮作为返回按钮
                vc.navItem.leftBarButtonItem = UIBarButtonItem(title: title, target:self, action: #selector(popToback), isBackButton: true)
            }
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    // pop 返回上一级控制器
    @objc private func popToback() {
        
        popViewController(animated: true)
    }
}
