//
//  SZUserAccount.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/20.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/// 账户文件名
private let accountFileName: String = "useraccount.json"

/// 用户账户信息
class SZUserAccount: NSObject {
    
    /// 访问令牌
    @objc var access_token: String? // = "2.00agKp7GmmCIeC27fbda3419XfN2JD"
    
    /// 授权用户的UID，用户代号
    @objc var uid: String?
    
    /// 过期日期，单位：秒
    /// 开发者 5 年 每次登录之后都是 5年
    /// 使用者 3 天 会从第一天登录递减
    @objc var expires_in: TimeInterval = 0 {
        
        didSet {
            
            expiresDate = Date(timeIntervalSinceNow: expires_in)
        }
    }
    
    /// 过期日期 - 通过 重写 expires_in 的 set方法 来设置
    @objc var expiresDate: Date?
    
    /// 用户昵称
    @objc var screen_name: String?
    
    /// 用户头像地址（大图），180×180像素
    @objc var avatar_large: String?
    
    override var description: String {
        
        return yy_modelDescription()
    }
    
    /// 重写 构造函数
    override init() {
        
        super.init()
        
        // 从磁盘 加载保存的文件 -> 字典
        let filePath = String.getSandBoxFilePath(fileName: accountFileName)
        
        // 1> 加载磁盘文件到二进制数据，如果失败直接返回
        guard let data = NSData.init(contentsOfFile: filePath),// 加载 data
            let dict = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [String: AnyObject]
            else {
                
            return
        }
        
        // 2> 使用 字典 设置属性值
        // *** 用户是否登录的关键代码
        yy_modelSet(with: dict ?? [:])
        
        //        print("从沙盒加载用户信息 \(self)")
        
        // 3> 判断 token 是否过期
        
        /// 测试过期日期 -- *** 在开发中，每一个分支都需要测试
//        expiresDate = Date.init(timeIntervalSinceNow: -3600 * 24)
//        print(expiresDate as Any)
        
        if expiresDate?.compare(Date()) != .orderedDescending {
            
            print("账户过期")
            
            // 账户过期后 清空 token
            access_token = nil
            uid          = nil
            
            // 删除账户文件
            try? FileManager.default.removeItem(atPath: filePath)
            
            return
        }
        
        print("账户正常 \(self)")
    }
    
    /*
     存储方式：
     
     1. 偏好设置（小）
     2. 沙盒 - 归档 / plist / 'json'
     3. 数据库 (FMDB / CoreData)
     4. 钥匙串（小 / 自动加密 - 需要使用框架（SSKeychain））
     */
    
    /// 保存用户信息
    func saveAccount() {
        
        // 1. 模型转 字典
        var dict = (self.yy_modelToJSONObject() as? [String: AnyObject]) ?? [:]
        
//        print(dict as Any)
        
        // 需要删除 expires_in
        dict.removeValue(forKey: "expires_in")
        
        // 2. 字典序列化 data
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []) else {
            
            return
        }
        
        // 3. 写入磁盘
//        let fileName = "useraccount.json"
        
        // 取沙盒目录
//        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let filePath = (docDir as NSString).appendingPathComponent(fileName)
        
        // 取沙盒目录
        let filePath = String.getSandBoxFilePath(fileName: accountFileName)
        
        // 保存在沙盒
        (data as NSData).write(toFile: filePath, atomically: true)
        
        print("用户账户保存成功 \(filePath)")
    }
}

















