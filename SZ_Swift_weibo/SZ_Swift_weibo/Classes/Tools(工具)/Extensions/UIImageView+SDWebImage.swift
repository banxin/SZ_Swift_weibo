//
//  UIImageView+SDWebImage.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/23.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation
import SDWebImage

extension UIImageView {
    
    /// 隔离 SDWebImage 设置函数
    ///
    /// - Parameters:
    ///   - urlStr: urlStr
    ///   - placeholder: 占位图片
    ///   - isAvadar: 是否是头像
    func sz_setImage(urlStr: String?, placeholder: UIImage?, isAvadar: Bool = false) {
        
        // 处理 URL
        guard let urlStr = urlStr, let url = URL.init(string: urlStr) else {
            
            // 设置占位图片
            image = placeholder
            
            return
        }
        
        // 可选项只是用在 swift，OC 有的时候用 ！ 同样可以传入 nil
        sd_setImage(with: url, placeholderImage: placeholder, options: [], progress: nil) { [weak self] (image, _, _, _) in
            
            // 完成回调 - 判断是否是头像，如果是，则画圆角
            if isAvadar {
                
                self?.image = image?.sz_avatarImage(size: self?.bounds.size)
            }
        }
    }
}







