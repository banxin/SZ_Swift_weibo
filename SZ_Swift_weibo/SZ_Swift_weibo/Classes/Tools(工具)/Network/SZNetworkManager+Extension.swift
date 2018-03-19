//
//  SZNetworkManager+Extension.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/19.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation

// MARK: - 封装新浪微博的网络请求方法
extension SZNetworkManager {
    
    /// 加载微博数据字典数组
    ///
    /// - Parameter completion: 完成回调[list: 微博字典数组 / 是否成功]
    func statusList(completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool) -> ()) {
        
        ///
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
//        let params = ["access_token": "2.00agKp7GmmCIeCc2f7e5c3d26H97nD"]
        
//        request(method: .GET, URLString: urlStr, parameters: params as AnyObject) { (json, isSuccess) in
        // 再次抽取
        tokenRequest(method: .GET, URLString: urlStr, parameters: nil) { (json, isSuccess) in
            
            // 从 JSON 中获取 statuses 字典数组
            // 如果 as? 失败，result 为 nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result, isSuccess)
        }
    }
}












