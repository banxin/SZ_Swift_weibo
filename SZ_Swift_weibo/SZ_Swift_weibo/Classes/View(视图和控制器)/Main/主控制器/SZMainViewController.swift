//
//  SZMainViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZMainViewController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupChildControllers()
        
        setupComposeBtn()
    }
    
    // MARK: - 私有控件
    /// 撰写按钮
    private lazy var composeBtn: UIButton = UIButton.init(imageName: "tabbar_compose_icon_add", backImageName: "tabbar_compose_button")
    
    // MARK: - 监听按钮方法
    
    // @objc 修饰符修饰，能够保证用OC的方式访问！
    // 1> private 能够保证方法私有，仅在当前对象能够被访问
    // 2> @objc 允许这个函数在运行时通过 OC 的消息机制 被调用
    
    /// 撰写微博
    @objc private func composeStatus() {
        
        print("撰写微博")
        
        // 测试 设备支持的方向
//        let vc = UIViewController.init()
//
//        vc.view.backgroundColor = UIColor().randomColor
//
//        let nav = UINavigationController.init(rootViewController: vc)
//
//        present(nav, animated: true, completion: nil)
    }
}

// extension 类似于 OC 中的分类，在Swift中，还可以用来切分代码块，
// 可以把相近功能的函数放在一个extension中，
// 便于代码维护
// *** 注意: 和OC的分类一样，extension中不能定义属性

// MARK: - 设置界面
extension SZMainViewController {
    
    /// 设置所有子控制器
    private func setupChildControllers() {
        
        let array = [
            ["clsName": "SZHomeViewController", "title": "首页", "imageName": "home"],
            ["clsName": "SZMessageViewController", "title": "消息", "imageName": "message_center"],
            ["clsName": "UIViewController"],
            ["clsName": "SZDiscoverViewController", "title": "发现", "imageName": "discover"],
            ["clsName": "SZProfileViewController", "title": "我的", "imageName": "profile"]
        ]
        
        var childVCArray = [UIViewController]()
        
        for dict in array {
            
            childVCArray.append(controller(dict: dict))
        }
        
        // 设定tabbar的控制器
        viewControllers = childVCArray
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典 [clsName, title, imageName]
    /// - Returns: 子控制器
    private func controller(dict: [String: String]) -> UIViewController {
        
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else {
                
            return UIViewController()
        }
        
        // 2.创建视图控制器
        // 1> 将 clsName 转换成 cls
        //        let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
        let vc = cls.init()
        
        vc.title = title
        
        // 3.设置图像
        vc.tabBarItem.image = UIImage.init(named: "tabbar_" + imageName)
        // withRenderingMode(.alwaysOriginal) 图片渲染模式
        vc.tabBarItem.selectedImage = UIImage.init(named: "tabbar_" + imageName + "_highlighted")?.withRenderingMode(.alwaysOriginal)
        
        // 4.设置tabbar title 的标题字体(大小)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .highlighted)
        
        // 系统默认 12 号字体，修改字体大小，要设置 normal 的字体大小，设置 highlighted 无效
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        
        let nav = SZNavigationController.init(rootViewController: vc)
        
        return nav
    }
    
    /// 设置撰写按钮
    private func setupComposeBtn() {
        
        tabBar.addSubview(composeBtn)
        
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        
        // -1 遮挡系统的左右容错点，避免遮挡不住中间的tabbar item
        let w = tabBar.bounds.width / count - 1
        
        // 设置按钮的位置
        // CGRectInset 正数向内缩进，负数向外扩展
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        print("撰写按钮的宽度 --> \(composeBtn.frame.width)")
        
        // 按钮监听方法
        composeBtn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
}


































