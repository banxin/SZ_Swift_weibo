//
//  SZStatus.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/19.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import YYModel

/// 微博首页数据模型
class SZStatus: NSObject {
    
    /*
     *** 在Swift4.0，需要使用 YYModel 进行字典转模型，必须在属性名前添加 @objc 关键字，否则将转换不成功
     */
    
    /// Int 类型，在 64 位的机器是 64 位，在 32 位的机器上是 32 位
    /// 如果不写 Int64，在 ipad2 iPhone 5/5c/4s 会数据溢出，无法正常运行
    @objc var id: Int64 = 0

    /// 微博信息内容
    @objc public var text: String?
    
    /// 重写 description 计算型属性
    override var description: String {
        
        return yy_modelDescription()
    }
}
