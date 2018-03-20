//
//  SZOAuthViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/20.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/// 通过 webview 加载 新浪微博 授权页面控制器
class SZOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        
        view.backgroundColor = UIColor.white
        
        // 设置导航栏标题
        title = "登录新浪微博"
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", target: self, action: #selector(close), isBackButton: true)
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "返回", target: self, action: #selector(back), isBackButton: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }

    // MARK: - 监听方法
    
    @objc private func close() {
        
        dismiss(animated: true, completion: nil)
    }

}





















