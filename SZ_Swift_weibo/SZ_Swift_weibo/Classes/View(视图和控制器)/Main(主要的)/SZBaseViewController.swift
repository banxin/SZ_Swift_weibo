//
//  SZBaseViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/*
 OC中支持多继承吗？如果不支持，如何替代？ -- 使用协议替代
 
 Swift 的写法更类似于多继承
 */
//class WBBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

/*
 Swift 中利用 extension 可以把 ‘函数’ 按照功能分类管理，便于阅读和维护
 
 注意：
 1.extension 中不能有属性
 2.extension 中不能重写'父类' 本类 的方法！但可以在子类扩展中重写父类扩展中的方法！重写父类的方法，是子类的职责，扩展是对类的扩展！！！
 */

/// 所有主控制器的基类
class SZBaseViewController: UIViewController {
    
    /// 用户是否登录 标记 --> 使用 network 中的accessToken来判断即可
//    var userLogon = false
//    var userLogon = true
    
    /// 访客视图信息字典 (外部传入)
    var vistorInfoDic: [String: String]?
    
    /// 表格视图 - 如果用户没有登录就不创建，不能使用懒加载
    var tableView: UITableView?
    
    /// 刷新控件
    var refreshControl: UIRefreshControl?
    
    /// 上拉刷新标记
    var isPullUp = false
    
    // 自定义导航条
    lazy var navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.screenWidth, height: 44))
    
    // 自定义导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupUI()
        
        // 用户登录之后才加载数据
        SZNetworkManager.shared.userLogon ? loadData() : ()
        
        // 注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: SZUserLoginSuccessNotification), object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // 重写 title didSet 方法
    override var title: String? {
        
        didSet {
            
            navItem.title = title
        }
    }
    
    /// 加载数据 - 具体的实现由子类负责
    @objc func loadData() {
        
        // 如果子类不实现任何方法，默认关闭刷新控件
        refreshControl?.endRefreshing()
    }
}

// MARK: - 访客视图监听方法
extension SZBaseViewController {
    
    /// 登录成功处理
    @objc private func loginSuccess(n: Notification) {
        
        print("登录成功 \(n)")
        
        // 登录前 左边是 注册，右边是登录
        // 先清除，再让重新设置
        navigationItem.leftBarButtonItem  = nil
        navigationItem.rightBarButtonItem = nil
        
        // 更新 UI - 将访客视图替换为表格视图
        // 需要重新设置 view
        // 在访问 view 的 getter 方法时，当 view = nil，会调用 loadView -> viewDidLoad，所以 会重新执行一次 viewDidLoad
        view = nil
        
        // 注销通知 -> 重新执行 viewDidLoad 会再次注册！避免通知被重复注册
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 发送 登录 通知
    @objc private func login() {
        
        // 发送 用户登录 通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SZUserShouldLoginNotification), object: nil)
    }
    
    @objc private func register() {
        
        print("注册按钮")
    }
}

// MARK: - 设置界面
extension SZBaseViewController {
    
    // 如果子类需要重写该方法，必须使用 @objc dynamic 修饰，Swift 本身不支持 extension 中方法的重写，需要使用OC的机制曲线实现
//    @objc dynamic func setupUI() {
    private func setupUI() {
        
        // 取消自动缩进，如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
//        view.backgroundColor = UIColor().randomColor
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        
        // 用户登录则显示列表视图，否则显示访客视图
        // 使用 accessToken 是否为空 来判定即可
//        userLogon ? setupTableView() : setupVistorView()
//        (SZNetworkManager.shared.accessToken != nil) ? setupTableView() : setupVistorView()
        
        // 用计算型属性 - 用户是否登记标记来判定，可读性更高
        SZNetworkManager.shared.userLogon ? setupTableView() : setupVistorView()
        
        // 测试调用OC代码
        //        let alert = YTAlertController.init(title: "测试", message: "看看是不是调用OC成功了", preferredStyle: .alert)
        //
        //        alert.addAction(YTAlertAction.init(title: "取消", style: .cancel, handler: { (_) in
        //
        //            print("cancel")
        //        }))
        //
        //        present(alert, animated: true, completion: nil)
    }
    
    /// 设置表格视图 - 用户登录之后执行
    /// 子类重写此方法，因为子类不关心用户登录之前的逻辑
   @objc dynamic func setupTableView() {
        
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        
        // 由于自定义了导航栏，直接addSubview，会遮挡nav
//        view.addSubview(tableView!)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源和代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate   = self
        
        // 设置内容缩进，取出 头 和 底
//        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: tabBarController?.tabBar.bounds.height ?? 49, right: 0)
        // 这里不设置底部的缩进就是正常的，原因不明 @山竹
        tableView?.contentInset = UIEdgeInsets(top: navigationBar.bounds.height, left: 0, bottom: 0, right: 0)
    
        // *** 修改指示器的缩进  此处的 tableView! 强行解包为了拿到一个必有的inset
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        
        // 设置刷新控件
        // 1> 实例化控件
        refreshControl = UIRefreshControl()
        
        // 2> 添加到表格视图
        tableView?.addSubview(refreshControl!)
        
        // 3>添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    private func setupVistorView() {
        
        let vistorView = SZVistorView(frame: view.bounds)
        
        view.insertSubview(vistorView, belowSubview: navigationBar)
        
//        print("访客视图 -> \(vistorView)")
        
        // 1. 设置访客视图信息
        vistorView.vistorInfo = vistorInfoDic
        
        // 2.添加访客视图按钮的监听方法
        vistorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        vistorView.registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        // 3. 设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        
        setStatusBarBackgroundColor(color: UIColor.colorWithHex(hexString: "f6f6f6"))
        
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将 item 设置给bar
        navigationBar.items = [navItem]
        
        // 1> 设置 navigationBar 整个背景的渲染颜色
        navigationBar.barTintColor = UIColor.colorWithHex(hexString: "f6f6f6")
        
        // 2> 设置 navigationBar 标题 字体颜色
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.withHex(hexInt: 0x323232)]
        
        // 3> 设置系统按钮的文字渲染颜色
        navigationBar.tintColor = UIColor.orange
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SZBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    // 基类只是准备方法，子类负责具体实现
    // 子类的数据源不需要 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 只是保证没有语法错误
        return UITableViewCell()
    }
    
    /* 将要显示cell的方法 */
    /// 在显示最后一行的时候，做上拉加载
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1.判断 indexPath 是否最后一行（indexPath.section(最大的section) / indexPath.row（最后一行））
        // 1> 取出 row
        let row = indexPath.row
        
        // 2> 取出 section
        let section = tableView.numberOfSections - 1
        
//        print("section ------- \(section)")
        
        // 也有可能没有数据，所以需要加判断
        if row < 0 || section < 0 {
            
            return
        }
        
        // 3> 取行数
        let count = tableView.numberOfRows(inSection: section)
        
        // 如果是最后一行，同时没有开始上拉
        if row == count - 1 && !isPullUp  {
            
            print("上拉加载")
            
            // 标记开始上拉刷新
            isPullUp = true
            
            print("加载更多")
            
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 0
    }
}









