//
//  UIButton+Extension.swift
//  Weibo10
//
//  Created by male on 15/10/14.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 便利构造函数
    ///
    /// - parameter imageName:     图像名称
    /// - parameter backImageName: 背景图像名称
    ///
    /// - returns: UIButton
    convenience init(imageName: String, backImageName: String) {
        
        self.init()
        
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        setBackgroundImage(UIImage(named: backImageName + "_highlighted"), for: .highlighted)
        
        // 会根据背景图片的大小调整尺寸
        sizeToFit()
    }
    
    /// 便利构造函数
    ///
    /// - parameter title:     title
    /// - parameter color:     color
    /// - parameter imageName: imageName
    ///
    /// - returns: UIButton
    convenience init(title: String, color: UIColor, imageName: String) {
        
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(color, for: .normal)
        
        setBackgroundImage(UIImage(named: imageName), for: .normal)
        
        sizeToFit()
    }
    
    convenience init(title: String, fontSize: CGFloat, normalColor: UIColor, highlightColor: UIColor) {
        
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(normalColor, for: .normal)
        setTitleColor(highlightColor, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
        sizeToFit()
    }
    
    convenience init(title: String, fontSize: CGFloat, normalColor: UIColor, highlightColor: UIColor, backImageName: String) {
        
        self.init()
        
        setTitle(title, for: .normal)
        setTitleColor(normalColor, for: .normal)
        setTitleColor(highlightColor, for: .highlighted)
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setBackgroundImage(UIImage(named: backImageName), for: .normal)
        setBackgroundImage(UIImage(named: backImageName), for: .highlighted)
        
        sizeToFit()
    }
}
