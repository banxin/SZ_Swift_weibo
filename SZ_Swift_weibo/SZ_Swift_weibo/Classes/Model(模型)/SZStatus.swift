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
@objc public class SZStatus: NSObject {
    
    /*
     *** 在Swift4.0，需要使用 YYModel 进行字典转模型，必须在属性名前添加 @objc 关键字，否则将转换不成功
     */
    
    /// Int 类型，在 64 位的机器是 64 位，在 32 位的机器上是 32 位
    /// 如果不写 Int64，在 ipad2 iPhone 5/5c/4s 会数据溢出，无法正常运行
    @objc var id: Int64 = 0

    /// 微博信息内容
    @objc var text: String?
    
    /// 转发数
    @objc var reposts_count: Int = 0
    
    /// 评论数
    @objc var comments_count: Int = 0
    
    /// 表态数
    @objc var attitudes_count: Int = 0
    
    /// 缩略图配图模型数组
    @objc var pic_urls: [SZStatusPicture]?
    
    /// 微博的用户信息
    @objc var user: SZUser?
    
    /// 重写 description 计算型属性
    override public var description: String {
        
        return yy_modelDescription()
    }
    
    /// 类函数 -> 告诉 YYModel 如果遇到数组类型的属性，数组中存放的对象是什么类！
    /// NSArray 中保存对象的类型通常是 ‘id’ 类型
    /// OC 中的泛型 是 Swift 推出后，苹果为了兼容 OC 增加的
    /// 从运行时角度，仍然不知道数组中应该存放什么类型的对象
    @objc public class func modelContainerPropertyGenericClass() -> [String: AnyClass] {
        
        return ["pic_urls": SZStatusPicture.self]
    }
}
















