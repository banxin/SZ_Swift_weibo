//
//  WeiboCommon.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/20.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation

// MARK: - 应用程序信息

/// 应用程序 ID
let SZAppKey      = "2425236440"

/// 应用程序 加密信息（开发者可以申请修改）
let SZAppSecret   = "abe18aac16e7a3b2904474684d9e5253"

/// 回调地址 - 登录完成跳转的 URL ，参数以 get 形式拼接
let SZRedirectURI = "http://www.baidu.com"

// MARK: - 全局通知定义

/// 用户需要登录通知
let SZUserShouldLoginNotification = "SZUserShouldLoginNotification"

/// 用户登录成功
let SZUserLoginSuccessNotification = "SZUserLoginSuccessNotification"


