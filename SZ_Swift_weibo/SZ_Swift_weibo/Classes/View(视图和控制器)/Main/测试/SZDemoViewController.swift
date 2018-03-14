//
//  SZDemoViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZDemoViewController: SZBaseViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // 设置标题
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    // MARK: - 监听方法
    // 继续 push 一个新的 VC
    @objc private func showNext() {
        
        let vc = SZDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UI
extension SZDemoViewController {
    
    override func setupUI() {
        
        super.setupUI()
        
        // 设置右侧的控制器
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "下一个", style: .plain, target: self, action: #selector(showNext))
        
//        let btn = UIButton.init(title: "下一个", fontSize: 16, normalColor: UIColor.darkGray, highlightColor: UIColor.orange)
//
//        btn.addTarget(self, action: #selector(showNext), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        // 使用抽取后的 UIBarButtonItem 的便利构造函数，简化代码
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}










