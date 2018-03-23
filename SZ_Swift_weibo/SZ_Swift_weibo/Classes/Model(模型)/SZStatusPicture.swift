//
//  SZStatusPicture.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/23.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/// 微博配图模型
class SZStatusPicture: NSObject {
    
    /// 缩略图地址
    @objc var thumbnail_pic: String?

    override var description: String {
        
        return yy_modelDescription()
    }
}
