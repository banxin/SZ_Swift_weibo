//
//  WBHomeViewController.swift
//  传智微博
//
//  Created by yanl on 2017/11/12.
//  Copyright © 2017年 yanl. All rights reserved.
//

import UIKit

// 定义全局常量，尽量使用private修饰，否则到处都可以访问
private let cellId = "cellId"

class WBHomeViewController: WBBaseViewController {

    /// 微博数据数组
    private lazy var statusList = [String]()
    
    /// 加载数据
    override func loadData() {
        
        print("开始加载数据")
        
        // 模拟延时加载 -> dispatch_after
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            
            if self.isPullUp {
                
                for i in 0..<15 {
                    
                    // 将数据加入到数据
                    self.statusList.append("上拉 \(i)")
                }
                
            } else {
                
                for i in 0..<15 {
                    
                    // 将数据插入到数据顶部
                    self.statusList.insert(i.description, at: 0)
                }
            }
            
            print("加载数据结束")
            
            // 结束刷新控件
            self.refreshControl?.endRefreshing()
            
            // 恢复上拉加载刷新标记
            self.isPullUp = false
            
            print("刷新表格")
            
            // 刷新表格
            self.tableView?.reloadData()
            
//            self.isPullUp = true
        }
    }
    
    /// 显示好友
    @objc private func showFriends() {
        
//        print(#function)
        
        let vc = WBDemoViewController()
        
        // 容易忽略的点， 不过push的动作是Nav 操作的，所以可以抽取到 baseNav 中
//        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 表格数据源方法，具体的数据源方法，不需要 super
extension WBHomeViewController {
    
    // 重写父类方法
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return statusList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 1.取cell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        // 2.设置cell
        cell.textLabel?.text = statusList[indexPath.row]
        
        // 3.返回cell
        return cell
    }
}

// MARK: - 设置界面
extension WBHomeViewController {
    
    /// 重写父类的方法
    override func setupUI() {
        
        super.setupUI()
        
        // 设置左侧导航栏按钮
        // 无法高亮
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        
        // 创建自定义高亮按钮
//        let btn = UIButton.init(title: "好友", fontSize: UIFont.systemFont(ofSize: 16), normalColor: UIColor.darkGray, highlightColor: UIColor.orange)
//
//        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        // 抽取自定义高亮按钮方法
        navItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
        
        // 注册原型 cell
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
}













