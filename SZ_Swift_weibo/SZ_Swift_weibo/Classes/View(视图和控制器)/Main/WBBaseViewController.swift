//
//  WBBaseViewController.swift
//  传智微博
//
//  Created by yanl on 2017/11/12.
//  Copyright © 2017年 yanl. All rights reserved.
//

import UIKit
import SnapKit

/*
 OC中支持多继承吗？如果不支持，如何替代？ -- 使用协议替代
 
 Swift 的写法更类似于多继承
 */
//class WBBaseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

/*
 Swift 中利用 extension 可以把 ‘函数’ 按照功能分类管理，便于阅读和维护
 
 注意：
 1.extension 中不能有属性
 2.extension 中不能重写'父类' 本类 的方法！重写父类的方法，是子类的职责，扩展是对类的扩展！！！
 */

/// 所有主控制器的基类
class WBBaseViewController: UIViewController {
    
    /// 用户登录标记
    var userLogon = false
    
    /// 访客视图信息字典
    var vistorInfoDic: [String: String]?
    
    /// 表格视图 - 如果用户没有登录就不创建，不能使用懒加载
    var tableView: UITableView?
    
    /// 刷新控件
    var refreshControl: UIRefreshControl?
    
    /// 上拉加载标记
    var isPullUp = false
    
    // 自定义导航条
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: UIScreen.main.screenWidth, height: 44))
    
    // 自定义导航条目 - 以后设置导航栏内容，统一使用 navItem
    lazy var navItem = UINavigationItem()
    
    // TODO 暂时方案，解决 statusBar 颜色显示不正常
//    lazy var statusBar = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.screenWidth, height: 20))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []

        setupUI()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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

// MARK: - 设置界面
extension WBBaseViewController {
    
    // 如果子类需要重写该方法，必须使用 @objc dynamic 修饰，Swift 本身不支持 extension 中方法的重写，需要使用OC的机制曲线实现
    @objc dynamic func setupUI() {
        
        // 取消自动缩进，如果隐藏了导航栏，会缩进 20 个点
        automaticallyAdjustsScrollViewInsets = false
        
//        view.backgroundColor = UIColor().randomColor
        view.backgroundColor = UIColor.white
        
        setupNavigationBar()
        
        userLogon ? setupTableView() : setupVistorView()
        
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
    
    /// 设置表格视图
    private func setupTableView() {
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        // 由于自定义了导航栏，直接addSubview，会遮挡nav
//        view.addSubview(tableView!)
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        // 设置数据源和代理 -> 目的：子类直接实现数据源方法
        tableView?.dataSource = self
        tableView?.delegate = self
        
        // 设置内容缩进，取出 头 和 底
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, tabBarController?.tabBar.bounds.height ?? 49, 0)
        
        // 设置刷新控件
        // 1> 实例化控件
        refreshControl = UIRefreshControl()
        
        // 2> 添加到视图
        tableView?.addSubview(refreshControl!)
        
        // 3>添加监听方法
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    /// 设置访客视图
    func setupVistorView() {
        
        let vistorView = WBVistorView(frame: view.bounds)
        
        view.insertSubview(vistorView, belowSubview: navigationBar)
        
        // 设置访客视图信息
        vistorView.vistorInfo = vistorInfoDic
    }
    
    /// 设置导航条
    private func setupNavigationBar() {
        
        //        navigationController?.navigationBar.backgroundColor = UIColor.withHex(hexInt: 0xf6f6f6)
        
        //        view.addSubview(statusBar)
        //        statusBar.backgroundColor = UIColor.withHex(hexInt: 0xf6f6f6)
        setStatusBarBackgroundColor(color: UIColor.withHex(hexInt: 0xf6f6f6))
        
        // 添加导航条
        view.addSubview(navigationBar)
        
        // 将 item 设置给bar
        navigationBar.items = [navItem]
        
        // 设置 navigationBar 渲染颜色
        navigationBar.barTintColor = UIColor.withHex(hexInt: 0xf6f6f6)
        
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension WBBaseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    // 基类只是准备方法，子类负责具体实现
    // 子类的数据源 super
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 只是保证没有语法错误
        return UITableViewCell()
    }
    
    /// 在显示最后一行的时候，做上拉加载
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // 1.判断 indexPath 是否最后一行（indexPath.section(最大) / indexPath.row（最后一行））
        // 1> 取出 row
        let row = indexPath.row
        
        // 2> 取出 section
        let section = tableView.numberOfSections - 1    
        
        if row < 0 || section < 0 {
            
            return
        }
        
        // 3> 取行数
        let count = tableView.numberOfRows(inSection: section)
        
        // 如果是最后一行，同时没有开始上拉
        if row == count - 1 && !isPullUp  {
            
            print("上拉加载")
            
            isPullUp = true
            
            print("加载更多")
            
            loadData()
        }
    }
}













