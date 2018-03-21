//
//  SZMainViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import SVProgressHUD

class SZMainViewController: UITabBarController {
    
    /// 定时器
    private var timer: Timer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupChildControllers()
        
        setupComposeBtn()
        
        setupTimer()
        
        // 设置新特性视图
        setupNewFeatureViews()
        
        // 设置代理
        delegate = self
        
//        // 测试未读数量
//        SZNetworkManager.shared.unreadCount { (count) in
//
//            print("有 \(count) 条新微博")
//        }
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: SZUserShouldLoginNotification), object: nil)
    }
    
    deinit {
        
        // 销毁定时器
        timer?.invalidate()
        
        // 注销通知
        NotificationCenter.default.removeObserver(self)
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
    
    /// 用户登录
    @objc private func userLogin(n: Notification) {
        
        print("用户登录通知")
        
        var deadline = DispatchTime.now()
        
        // 判断 n 的 object 是否有值，如果有值，提示用户重新登录
        if n.object != nil {
            
            // 设置渐变样式
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录超时，需要重新登录")
            
            // 修改延时时间，token 过期，才需要提示用户
            deadline = DispatchTime.now() + 2
        }
        
        // 延时两秒执行
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            
            // 恢复默认样式
            SVProgressHUD.setDefaultMaskType(.clear)
            
            // 展现登录控制器 - 通常会和 UINavigationController 连用，方便返回
            let nav = UINavigationController(rootViewController: SZOAuthViewController())
            
            self.present(nav, animated: true, completion: nil)
        }
    }
    
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

// MARK: - 新特性视图处理
extension SZMainViewController {
    
    /// 设置新特性视图
    private func setupNewFeatureViews() {
        
        // 0. 判断用户是否登录
        if !SZNetworkManager.shared.userLogon {
            
            return
        }
        
        // 1. 如果更新，显示新特性，否则显示更新
        let v = isNewVersion ? SZNewFeatureView.newFeatureView() : SZWelcomeView.welcomeView()
        
        // 2. 添加视图
        view.addSubview(v)
    }
    
    /// extension 中可以有计算型属性，不会占用存储空间
    /// 构造函数：给属性分配空间
    private var isNewVersion: Bool {
        
        /*
         版本号：
         
         - 在App Store中，每次升级应用程序，版本号都需要增加，不能递减
         - 组成：主版本号，次版本号， 修订版本号
         - 主版本号，意味着大的修改，使用者也需要做大的适应
         - 次版本号，意味着小的修改，某些函数和方法的使用或者参数有变化
         - 修订版本号，框架 / 者程序内部 bug 的修订，不会对使用者造成任何的影响
         */
        
        // 1. 当前的版本 - info.plist CFBundleShortVersionString
        //        print("\(Bundle.main.infoDictionary ?? [:])")
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        // 取保存在 'Document(iTunes备份)[最理想保存在用户偏好]' 目录中的之前的版本号
        // 2. `之前`的版本，把当前版本保存在用户偏好 - 如果 key 不存在，返回 0
        let sandboxVersionKey = "sandboxVersionKey"
        let sandboxVersion = UserDefaults.standard.string(forKey: sandboxVersionKey)
        
        // 3. 将当前版本号保存在沙盒
        UserDefaults.standard.set(currentVersion, forKey: sandboxVersionKey)
        
        // 4. 返回两个版本号 ‘是否一致’
        return currentVersion != sandboxVersion
//        return currentVersion == sandboxVersion
    }
}

// MARK: - UITabBarControllerDelegate
extension SZMainViewController: UITabBarControllerDelegate {
    
    // 将要切换，可以和当前选中的 tab 进行比较
    
    /// 将要选择 tabBarItem
    ///
    /// - Parameters:
    ///   - tabBarController: tabBarController
    ///   - viewController: 目标 VC
    /// - Returns: 是否切换
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        print("将要切换的控制器 \(viewController)")
        
        // 1> 获取控制器在数组中的索引
//        let idx = childViewControllers.index(of: viewController)
        let idx = (childViewControllers as NSArray).index(of: viewController)
        
        // 2> 获取当前索引
        // 判断当前索引是首页，并且将要选择的idx也是首页，相当于重复点击首页的按钮，再加上一个判断，用户登录的情况下
        if SZNetworkManager.shared.userLogon && selectedIndex == 0 && selectedIndex == idx {
            
            print("重复点击首页")
            
            // 3> 让表格滚动到顶部
            // a) 获取到控制器
            let nav = childViewControllers[0] as! SZNavigationController
            let vc  = nav.childViewControllers[0] as! SZHomeViewController
            
            // b) 滚动到顶部
            vc.tableView?.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
            
            // 4> 刷新数据
            // 延迟 1 秒 执行，保证表格先滚动到顶部，再刷新，不然速度快的话，会有问题，导致数据刷新之后，表格没在顶部
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                
                vc.loadData()
            })
        }
        
        // 判断目标控制器，是否是 UIVIewController，如果是，就不切换，可以用来判断中间按钮的容错，如果不是，就意味着是其他4个tab，切换
        return !viewController.isMember(of: UIViewController.self)
    }
}

// MARK: - 定时器相关
extension SZMainViewController {
    
    /// 定义定时器
    private func setupTimer() {
        
        // 时间间隔，建议长一些
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    /// 定时器触发方法
    @objc private func updateTimer() {
        
//        print(#function)
        
        // 用户登录了的情况下，才做轮询，没有登录，直接返回，什么也不做
        if !SZNetworkManager.shared.userLogon {
            
            return
        }
        
        SZNetworkManager.shared.unreadCount { (count) in
            
            print("检测到 \(count) 条新微博")
            
            // 设置 首页 tabBarItem 的 badgeNum
            self.tabBar.items?[0].badgeValue = count > 0 ? "\(count)" : nil
            
            // 设置 APP 的 badgeNum，从 8.0 之后，要用户授权之后才能显示
            UIApplication.shared.applicationIconBadgeNumber = count
        }
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
        
        // 0.获取沙盒的 JSON 路径
//        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let filePath = (docDir as NSString).appendingPathComponent("main.json")
        
        // 使用封装好的方法获取路径
        let filePath = String.getSandBoxFilePath(fileName: "main.json")
        
        // 加载 data
        var data = NSData.init(contentsOfFile: filePath)
        
        // 判断data是否有内容，如果不存在，说明本地沙盒没有文件
        if (data == nil) {
            
            // 从Bundle加载 data
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            
            data = NSData.init(contentsOfFile: path!)
        }
        
        // data 一定有值，反序列化
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: AnyObject]]
            else {
                
            return
        }
        
//        // 从 bundle 加载配置的 JSON
//        // 1.获取路径 2，加载 NSData，3，反序列化转换成数组
//        guard let path = Bundle.main.path(forResource: "main.json", ofType: nil),
//                let data = NSData.init(contentsOfFile: path),
//                let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[String: AnyObject]]
//                else {
//
//            return
//        }
        
//        // 现在很多的应用程序中，界面的创建都依赖网络的 JSON   ---  使用配置的JSON文件来加载配置
//        let array: [[String: AnyObject]] = [
//
//            ["clsName": "SZHomeViewController" as AnyObject, "title": "首页" as AnyObject, "imageName": "home" as AnyObject, "vistorInfo": ["imageName": "", "message": "关注一些人，回这里看看有什么惊喜"]  as AnyObject],
//            ["clsName": "SZMessageViewController" as AnyObject, "title": "消息" as AnyObject, "imageName": "message_center" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，别人评论你的微博，发给你的信息，都会在这里收到通知"]  as AnyObject],
//            ["clsName": "UIViewController" as AnyObject],
//            ["clsName": "SZDiscoverViewController" as AnyObject, "title": "发现" as AnyObject, "imageName": "discover" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_message", "message": "登录后，最新、最热微博尽在掌握，不再会与实事潮流插肩而过"]  as AnyObject],
//            ["clsName": "SZProfileViewController" as AnyObject, "title": "我的" as AnyObject, "imageName": "profile" as AnyObject, "vistorInfo": ["imageName": "visitordiscover_image_profile", "message": "登录后，你的微博、相册、个人资料会显示在这里，展示给别人"]  as AnyObject]
//        ]
        
        // 以 plist格式 写入沙盒
        // 测试数据是否正确，- 转换成plist，更加直观
//        (array as NSArray).write(toFile: "/Users/yanl/Desktop/demo.plist", atomically: true)
        
        // 数组 -> JSON 序列化
        // 测试保存 JSON 文件 到 mac 桌面
//        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])
//
//        (data as NSData).write(toFile: "/Users/yanl/Desktop/main.json", atomically: true)
        
        var childVCArray = [UIViewController]()
        
        // 遍历数组，循环创建子控制器
        for dict in array! {
            
            childVCArray.append(controller(dict: dict))
        }
        
        // 设置tabbar的子控制器
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
        
//        // -1 遮挡系统的左右容错点，避免遮挡不住中间的tabbar item
//        let w = tabBar.bounds.width / count - 1
        
        // 按钮的宽度
        // 使用代理方法进行了判断，这里就可以不用使用容错点了
        let w = tabBar.bounds.width / count
        
        // 设置按钮的位置
        // CGRectInset 正数向内缩进，负数向外扩展
        composeBtn.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: 0)
        
        print("撰写按钮的宽度 --> \(composeBtn.frame.width)")
        
        // 按钮监听方法
        composeBtn.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
}


































