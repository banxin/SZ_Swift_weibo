//
//  WBMainViewController.swift
//  传智微博
//
//  Created by yanl on 2017/11/12.
//  Copyright © 2017年 yanl. All rights reserved.
//

import UIKit

class WBMainViewController: UITabBarController {

    // MARK: - 私有控件
    /// 撰写按钮
    private lazy var composeBtn: UIButton = UIButton.init(imageName: "tabbar_compose_icon_add", backImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildControllers()
        setupComposeBtn()
    }
    
    /*
         portrait  竖屏，肖像
         landscape 横屏，风景
     
         - 使用代码控制，支持屏幕的方向，好处：在需要横屏的时候单独处理
         - 设置支持的方向之后，当前的控制器及子控制器，都会遵守这个方向
         - 如果播放视频，通常是通过 model（自定义转场） 展现！
     */
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    // MARK: - 监听按钮方法
    
    /// 撰写微博
    // @objc 修饰符修饰，能够保证用OC的方式访问！
    // 1> private 能够保证方法私有，仅在当前对象能够被访问
    // 2> @objc 允许这个函数在运行时通过 OC 的消息机制 被调用
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
// 注意: 和OC的分类一样，extension中不能定义属性

// MARK: - 设置界面
extension WBMainViewController {
    
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
        
        // 按钮监听方法
        composeBtn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    
    /// 设置所有子控制器
    private func setupChildControllers() {

//        let jsonString = try! String.init(contentsOfFile: "/Users/yanl/Movies/Practice Project/weibo/传智微博/传智微博/Classes/View(视图和控制器)/Main/主控制器/main.json")
//
//        let dataA = jsonString.data(using: .utf8)

        // 从 bundle 中加载JSON
//        guard let path = Bundle.main.path(forResource: "main", ofType: "json"),
//              let data = NSData(contentsOfFile: path),
//            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: AnyObject]]
//            else {
//
//            return
//        }
        
        // 0.获取沙盒的路径
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
        
        var data = NSData(contentsOfFile: jsonPath)
        
        // 判断data是否有内容，如果不存在，说明本地沙盒没有文件
        if (data == nil) {
            
            data = NSData(contentsOfFile: "/Users/yanl/Movies/Practice Project/weibo/传智微博/传智微博/Classes/View(视图和控制器)/Main/主控制器/main.json")
        }
        
        // data 一定有值，反序列化
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
            else {
                
                return
        }
        
        // 使用 Bundle.main.path(forResource: "main", ofType: "json") 取出的path为空，具体原因不明。。。
        // 1.取JSONString 2，取data，3，反序列化
//        guard let jsonString = try? String.init(contentsOfFile: "/Users/yanl/Movies/Practice Project/weibo/传智微博/传智微博/Classes/View(视图和控制器)/Main/主控制器/main.json"),
//            let data = jsonString.data(using: .utf8),
//            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: AnyObject]]
//            else {
//
//                return
//        }
        
//        // 现在很多的应用程序中，界面的创建都依赖网络的JSON
//        let array: [[String: AnyObject]] = [
//
//            ["clsName": "WBHomeViewController" as AnyObject, "title": "首页" as AnyObject, "imageName": "home" as AnyObject, "vistorInfo": ["imageName": "", "message": "关注一些人，回这里看看有什么惊喜"]  as AnyObject],
//            ["clsName": "WBMessageViewController" as AnyObject, "title": "消息" as AnyObject, "imageName": "message_center" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，别人评论你的微博，发给你的信息，都会在这里收到通知"]  as AnyObject],
//            ["clsName": "UIViewController" as AnyObject],
//            ["clsName": "WBDiscoverViewController" as AnyObject, "title": "发现" as AnyObject, "imageName": "discover" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，最新、最热微博尽在掌握，不再会与实事潮流插肩而过"]  as AnyObject],
//            ["clsName": "WBProfileViewController" as AnyObject, "title": "我的" as AnyObject, "imageName": "profile" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_profile", "message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]  as AnyObject]
//        ]
        
        // 写入沙盒
        // 测试数据是否正确，- 转换成plist，更加直观
//        (array as NSArray).write(toFile: "/Users/mac/Desktop/demo.plist", atomically: true)
        
        // 测试获取JSON文件
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
//        
//        (data as NSData).write(toFile: "/Users/yanl/Desktop/main.json", atomically: true)
        
        var arrayM = [UIViewController]()
        
        // 遍历数组，循环创建子控制器
        for dict in array! {
            
            arrayM.append(controller(dict: dict))
        }
        
        // 设置tabbar的子控制器
        viewControllers = arrayM
    }
    
    /// 使用字典创建一个子控制器
    ///
    /// - Parameter dict: 信息字典 [clsName, title, imageName]
    /// - Returns: 子控制器
    private func controller(dict: [String: AnyObject]) -> UIViewController {
        
        // 1.取得字典内容
        
        guard let clsName = dict["clsName"] as? String,
                let title = dict["title"] as? String,
                let imageName = dict["imageName"] as? String,
                let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? WBBaseViewController.Type,
                let visitorDic = dict["vistorInfo"] as? [String: String]
            else {
            
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
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_highlighted")?.withRenderingMode(.alwaysOriginal)
        
        // 4.设置tabbar title 的标题字体(大小)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.orange], for: .highlighted)
        
        // 系统默认 12 号字体，修改字体大小，要设置 normal 的字体大小，设置 highlighted 无效
        vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], for: .normal)
        
        // 实例化导航控制器，会调用 push 方法 将 rootVC 压栈
        let nav = WBNavigationController(rootViewController: vc)
        
        return nav
    }
}























