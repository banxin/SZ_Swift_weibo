//
//  UIBarButtonItem+Extension.swift
//  传智微博
//
//  Created by yanl on 2017/11/12.
//  Copyright © 2017年 yanl. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /*
     *** btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>) target 和 action 的类型，参照btn的方法copy过来就可以
     */
    
    /// 创建 UIBarButtonItem
    ///
    /// - Parameters:
    ///   - title: title
    ///   - fontSize: fontSize 默认 16 号
    ///   - target: target
    ///   - action: action
    ///   - isBackButton: 是否是返回按钮，如果是，加返回按钮
    convenience init(title: String, fontSize: CGFloat = 16, target: Any?, action: Selector, isBackButton: Bool = false) {

        let btn = UIButton.init(title: title, fontSize: 16, normalColor: UIColor.darkGray, highlightColor: UIColor.orange)

        btn.addTarget(target, action: action, for: .touchUpInside)

        if isBackButton {

            btn.setImage(UIImage.init(named: "navigationbar_back_withtext"), for: .normal)
            btn.setImage(UIImage.init(named: "navigationbar_back_withtext_highlighted"), for: .highlighted)

            btn.sizeToFit()
        }

        // 实例化 UIBarButton
        self.init()

        customView = btn
    }
}
