//
//  SZUser.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/22.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/// 微博用户模型
class SZUser: NSObject {

    /// 用户UID
    @objc var id: Int64 = 0
    
    /// 用户昵称
    @objc var screen_name: String?
    
    /// 用户头像地址（中图），50×50像素
    @objc var profile_image_url: String?
    
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    @objc var verified_type: Int = 0
    
    /// 会员等级 0-6
    @objc var mbrank: Int = 0
    
    override var description: String {
        
         return yy_modelDescription()
    }
}
















