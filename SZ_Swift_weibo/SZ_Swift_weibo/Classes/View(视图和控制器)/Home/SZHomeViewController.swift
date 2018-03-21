//
//  SZHomeViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

// 定义全局常量，尽量使用private修饰，否则到处都可以访问
private let cellId = "cellId"

class SZHomeViewController: SZBaseViewController {

//    /// 微博数据数组
//    private lazy var statusList = [String]()
    
    /// 列表视图模型
    private lazy var listViewModel = SZStatusListViewModel()
    
    /// 加载数据
    override func loadData() {
        
        // 1. 测试用网络工具加载微博数据（最简单的get请求）
//        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
//
//        let params = ["access_token": "2.00agKp7GmmCIeCc2f7e5c3d26H97nD"]
//
//        SZNetworkManager.shared.get(urlStr, parameters: params, progress: nil, success: { (_, json) in
//
//            print(json as Any)
//
//        }) { (_, error) in
//
//            print("网络请求失败，\(error)")
//        }
        
        // 2. 使用封装好的网络单例加载微博数据
//        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
//
//        let params = ["access_token": "2.00agKp7GmmCIeCc2f7e5c3d26H97nD"]
//
//        SZNetworkManager.shared.request(method: .GET, URLString: urlStr, parameters: params as AnyObject) { (json, isSuccess) in
//
//            print(json as Any)
//        }
        
//        // 3. 再次封装 获取首页数据的 extension 方法调用
//        SZNetworkManager.shared.statusList { (list, isSuccess) in
//
//            // 字典转模型，绑定表格数据
//            print(list as Any)
//        }
        
        print("准备刷洗，最后一条 \(self.listViewModel.statusList.last?.text ?? "")")
        
        // 4. 使用 viewModel 获取首页数据
        listViewModel.loadStatus(isPullUp: self.isPullUp) { (isSuccess, shouldRefresh) in
            
            //                print("开始加载数据")
            
            // 刷新数据完成
            print("加载数据结束")
            //                print("加载数据结束 \(self.listViewModel.statusList.last?.text ?? "")")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            
            // 恢复上拉加载刷新标记
            self.isPullUp = false
            
            //                print("刷新表格")
            
            // 有下一页才刷新表格
            if shouldRefresh {
                
                // 刷新表格
                self.tableView?.reloadData()
            }
            
//            print("开始加载数据")
//
//            // 刷新数据完成
//            print("加载数据结束")
//
//            // 结束刷新控件
//            self.refreshControl?.endRefreshing()
//
//            // 恢复上拉加载刷新标记
//            self.isPullUp = false
//
//            print("刷新表格")
//
//            // 刷新表格
//            self.tableView?.reloadData()
        }
        
//        print("开始加载数据")
////        print("开始加载数据 --> \(SZNetworkManager.shared)")
//
//        // 模拟延时加载 -> dispatch_after
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
//
//            if self.isPullUp {
//
//                for i in 0..<20 {
//
//                    // 将数据追加到底部
//                    self.statusList.append("上拉 \(i)")
//                }
//
//            } else {
//
//                for i in 0..<20 {
//
//                    // 将数据插入到数据顶部
//                    self.statusList.insert(i.description, at: 0)
//                }
//            }
//
//            print("加载数据结束")
//
//            // 结束刷新控件
//            self.refreshControl?.endRefreshing()
//
//            // 恢复上拉加载刷新标记
//            self.isPullUp = false
//
//            print("刷新表格")
//
//            // 刷新表格
//            self.tableView?.reloadData()
//        }
    }
    
    /// 显示好友
    @objc private func showFriends() {
        
//        print(#function)
        
        let vc = SZDemoViewController()
        
        // 容易忽略的点， 不过push的动作是Nav 操作的，所以可以抽取到 baseNav 中
//        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 表格数据源方法，具体的数据源方法，不需要 super
extension SZHomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return statusList.count
        
        return listViewModel.statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1.取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // 2.设置cell
//        cell.textLabel?.text = statusList[indexPath.row]
        cell.textLabel?.text = listViewModel.statusList[indexPath.row].text
        
        // 3.返回cell
        return cell
    }
}

// MARK: - 设置界面
extension SZHomeViewController {
    
    /// 重写父类的方法
//    override func setupUI() {
//
//        super.setupUI()
//
//        // 设置左侧导航栏按钮
//        // 但是无法实现高亮
////        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", style: .plain, target: self, action: #selector(showFriends))
//
//        /*
//         !!! Swift 调用 OC 返回 instancetype 的方法，是判断不出是否可选的，所以需要加类型 例如：let btn: UIButton = xxxx
//         */
//
////        let btn = UIButton.init(title: "好友", fontSize: 16, normalColor: UIColor.darkGray, highlightColor: UIColor.orange)
////
////        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
////
////        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
//
//        // 使用抽取后的 UIBarButtonItem 的便利构造函数，简化代码
////        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
//
//        // 使用自定义的 navigationItem 设置左侧按钮
//        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
//
//        // 注册原型 cell
//        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
//    }
    
    override func setupTableView() {
        
        super.setupTableView()
        
        // 使用自定义的 navigationItem 设置左侧按钮
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册原型 cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        setupTitle()
    }
    
    /// 设置导航栏标题
    private func setupTitle() {
        
        let title = SZNetworkManager.shared.userAccount.screen_name
        
        let btn = SZTitleButton(title: title ?? "")
        
        btn.addTarget(self, action: #selector(clickBtnTitle), for: .touchUpInside)
        
        navItem.titleView = btn
    }
    
    @objc private func clickBtnTitle(btn: UIButton) {
        
        // 设置选中状态
        btn.isSelected = !btn.isSelected
    }
}

























