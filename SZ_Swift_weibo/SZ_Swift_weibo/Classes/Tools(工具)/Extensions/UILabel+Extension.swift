//
//  UILabel+Extension.swift
//  Weibo10
//
//  Created by male on 15/10/15.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit

extension UILabel {
    
    /// 便利构造函数
    ///
    /// - parameter title:    title
    /// - parameter fontSize: fontSize，默认 14 号字
    /// - parameter color:    color，默认深灰色
    ///
    /// - returns: UILabel
    /// 参数后面的值是参数的默认值，如果不传递，就使用默认值
    convenience init(title: String, fontSize: CGFloat = 14, color: UIColor = UIColor.darkGray) {
        self.init()
        
        text = title
        textColor = color
        font = UIFont.systemFont(ofSize: fontSize)
        
        numberOfLines = 0
        textAlignment = NSTextAlignment.center
    }
}
