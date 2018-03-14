//
//  WBDemoViewController.swift
//  传智微博
//
//  Created by yanl on 2017/11/12.
//  Copyright © 2017年 yanl. All rights reserved.
//

import UIKit

class WBDemoViewController: WBBaseViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 设置标题
        title = "第\(navigationController?.childViewControllers.count ?? 0)个"
    }
    
    // MARK: - 监听方法
    // 继续 push 一个新的 VC
    @objc private func showNext() {
        
        let vc = WBDemoViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WBDemoViewController {
    
    override func setupUI() {
        
        super.setupUI()
        
        // 设置 nav 右侧 item
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "下一个", style: .plain, target: self, action: #selector(showNext))
        
//        let btn = UIButton.init(title: "下一个", fontSize: UIFont.systemFont(ofSize: 16), normalColor: UIColor.darkGray, highlightColor: UIColor.orange)
//
//        btn.addTarget(self, action: #selector(showNext), for: .touchUpInside)
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
        
        navItem.rightBarButtonItem = UIBarButtonItem(title: "下一个", target: self, action: #selector(showNext))
    }
}
