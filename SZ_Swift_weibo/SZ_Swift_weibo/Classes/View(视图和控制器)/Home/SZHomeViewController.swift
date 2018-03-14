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
        
        // 设置左侧导航栏按钮
        // 但是无法实现高亮
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "好友", style: .plain, target: self, action: #selector(showFriends))
        
        /*
         !!! Swift 调用 OC 返回 instancetype 的方法，是判断不出是否可选的，所以需要加类型 例如：let btn: UIButton = xxxx
         */
        
//        let btn = UIButton.init(title: "好友", fontSize: 16, normalColor: UIColor.darkGray, highlightColor: UIColor.orange)
//
//        btn.addTarget(self, action: #selector(showFriends), for: .touchUpInside)
//
//        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        // 使用抽取后的 UIBarButtonItem 的便利构造函数，简化代码
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "好友", target: self, action: #selector(showFriends))
    }
}

























