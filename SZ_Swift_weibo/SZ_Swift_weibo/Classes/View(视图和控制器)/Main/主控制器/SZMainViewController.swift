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
    
    /*
     portrait  竖屏，肖像
     landscape 横屏，风景
     
     - 使用代码控制屏幕的方向，好处：在需要横屏的时候单独处理
     - *** 设置支持的方向之后，当前的控制器及子控制器，都会遵守这个方向
     - 如果播放视频，通常是通过 modal（自定义转场） 展现！
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
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
        let vc = UIViewController()

        vc.view.backgroundColor = UIColor().randomColor

        let nav = UINavigationController.init(rootViewController: vc)

        present(nav, animated: true, completion: nil)
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
        
        // 现在很多的应用程序中，界面的创建都依赖网络的 JSON
        let array: [[String: AnyObject]] = [

            ["clsName": "SZHomeViewController" as AnyObject, "title": "首页" as AnyObject, "imageName": "home" as AnyObject, "vistorInfo": ["imageName": "", "message": "关注一些人，回这里看看有什么惊喜"]  as AnyObject],
            ["clsName": "SZMessageViewController" as AnyObject, "title": "消息" as AnyObject, "imageName": "message_center" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，别人评论你的微博，发给你的信息，都会在这里收到通知"]  as AnyObject],
            ["clsName": "UIViewController" as AnyObject],
            ["clsName": "SZDiscoverViewController" as AnyObject, "title": "发现" as AnyObject, "imageName": "discover" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，最新、最热微博尽在掌握，不再会与实事潮流插肩而过"]  as AnyObject],
            ["clsName": "SZProfileViewController" as AnyObject, "title": "我的" as AnyObject, "imageName": "profile" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_profile", "message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]  as AnyObject]
        ]
        
        // 写入沙盒
        // 测试数据是否正确，- 转换成plist，更加直观
//        (array as NSArray).write(toFile: "/Users/yanl/Desktop/demo.plist", atomically: true)
        
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
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        
        guard let clsName = dict["clsName"] as? String,
            let title = dict["title"] as? String,
            let imageName = dict["imageName"] as? String,
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? SZBaseViewController.Type,
            let visitorDic = dict["vistorInfo"] as? [String: String] else {
                
            return UIViewController()
        }
        
        // 2.创建视图控制器
        // 1> 将 clsName 转换成 cls
        //        let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
        let vc = cls.init()
        
        vc.title = title
        
        // 设置控制器的访客信息字典
        vc.vistorInfoDic = visitorDic
        
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


































