//
//  SZNetworkManager.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/19.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import AFNetworking

class SZNetworkManager: AFHTTPSessionManager {
    
    /// 静态区 / 常量 / 闭包
    /// 在第一次访问时，执行闭包，并且将结果保存在shared常量中
    static let shared = SZNetworkManager()

}
