//
//  SZHomeViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZHomeViewController: SZBaseViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
    }
    
    /// 显示好友
    @objc private func showFriends() {
        
        print(#function)
        
        let vc = SZDemoViewController()
        
        // 容易忽略的点， 不过push的动作是Nav 操作的，所以可以抽取到 baseNav 中
        vc.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - 设置界面
extension SZHomeViewController {
    
    /// 重写父类的方法
    override func setupUI() {
        
        super.setupUI()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", style: .plain, target: self, action: #selector(showFriends))
    }
}

























