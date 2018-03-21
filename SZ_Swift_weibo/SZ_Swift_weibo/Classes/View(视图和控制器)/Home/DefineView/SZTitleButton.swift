//
//  SZTitleButton.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/21.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/// 自定义 Home Title Button
class SZTitleButton: UIButton {
    
    /// 重载构造函数
    ///
    /// - Parameter title: 标题，如果不为 nil ，显示 title 和 箭头，否则 显示 '首页'
    init(title: String?) {
        
        super.init(frame: CGRect())
        
        // 1> 判断 title 是否为 nil 或 “”
        if title == nil || title == "" {
            
            setTitle("首页", for: .normal)
            
        } else {
            
            setTitle(title! + "  ", for: .normal)
            
            // 设置图像
            setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
            setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        }
        
        // 2> 设置字体和颜色
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        setTitleColor(UIColor.darkGray, for: .normal)
        
        // 3> 设置大小
        sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // FIXME: - 首次显示不对，且会调用两次
    /// 重新布局子视图 - 一定要调 super，否则会显示空白
    override func layoutSubviews() {

        super.layoutSubviews()
        
        // 判断 titleLabel 和 imageView 是否同时存在
        guard let titleLabel = titleLabel, let imageView = imageView else {

            return
        }

        print("\(titleLabel) \(imageView)")

        // 将 label 的 x 向左移动 image 的宽度
        titleLabel.frame = titleLabel.frame.offsetBy(dx: -imageView.bounds.width, dy: 0)

        // 将 Image 的 x 向右移动 label 的宽度
        imageView.frame = imageView.frame.offsetBy(dx: titleLabel.bounds.width, dy: 0)
    }
}















