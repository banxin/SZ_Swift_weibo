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
    /// - Parameters:
    ///   - since_id: 返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0
    ///   - max_id: 返回ID小于或等于max_id的微博，默认为0
    ///   - Parameter completion: 完成回调[list: 微博字典数组 / 是否成功]
    func statusList(since_id: Int64 = 0, max_id: Int64 = 0, completion: @escaping (_ list: [[String: AnyObject]]?, _ isSuccess: Bool) -> ()) {
        
        /// URL
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
//        let params = ["access_token": "2.00agKp7GmmCIeCc2f7e5c3d26H97nD"]
        
//        request(method: .GET, URLString: urlStr, parameters: params as AnyObject) { (json, isSuccess) in
        
        // Swift中，Int可以转换成 AnyObject，但是 Int64 不行，解决办法，将 Int64 转成 String 就 OK 了
        let params = ["since_id": "\(since_id)" as AnyObject, "max_id": "\(max_id)" as AnyObject]
        
        // 再次抽取
        tokenRequest(method: .GET, URLString: urlStr, parameters: params) { (json, isSuccess) in
            
            // 从 JSON 中获取 statuses 字典数组
            // 如果 as? 失败，result 为 nil
            let result = json?["statuses"] as? [[String: AnyObject]]
            
            completion(result, isSuccess)
        }
    }
    
    // 返回微博的 未读数量 -- 定时调用，不需要提示是否失败！
    func unreadCount(completion: @escaping (_ count: Int) -> ()) {
        
//        guard let uid = uid else {
        guard let uid = userAccount.uid else {
        
            return
        }
        
        let url = "https://api.weibo.com/2/users/counts.json"
        
        let params = ["uid": uid as AnyObject]
        
        tokenRequest(method: .GET, URLString: url, parameters: params) { (json, isSuccess) in
            
//            print(json as Any)
            
            // FIXME: 该接口暂时不可用，直接返回假数据
//            guard let dict = json as? [String: AnyObject],
//                   let count = json?["status"] else {
//
//                    return;
//            }

//            let dict = json as? [String: AnyObject]
//
//            let count = dict?["status"] as? Int
//
//            completion(count ?? 0)
            
            completion(3)
        }
    }
}

// MARK: - 获取用户信息
extension SZNetworkManager {
    
    /// 加载当前用户信息 - 用户登录后 立即执行
    func loadUserInfo(completion: @escaping (_ dic: [String: AnyObject]) -> ()) {
        
        guard let uid = userAccount.uid else {
            
            return
        }
        
        let urlStr = "https://api.weibo.com/2/users/show.json"
        
        let params = ["uid": uid as AnyObject]
        
        // 发起网络请求
        tokenRequest(URLString: urlStr, parameters: params) { (json, isSuccess) in
            
//            print("加载用户信息完成 \(json as Any)")
            
            completion(json as? [String: AnyObject] ?? [:])
        }
    }
}

// MARK: - OAuth 相关方法
extension SZNetworkManager {
    
    /// 加载 accessToken
    /// 提问：网络请求异步到底应该返回什么？ -- 需要什么返回什么！
    
    /// 加载 token
    ///
    /// - Parameters:
    ///   - code: 授权码
    ///   - completion: 完成回调[是否成功]
    func loadAccessToken(code: String, completion: @escaping (_ isSucccess: Bool) -> ()) {
        
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        let params = [
                        "client_id"    : SZAppKey,
                        "client_secret": SZAppSecret,
                        "grant_type"   : "authorization_code",
                        "code"         : code,
                        "redirect_uri" : SZRedirectURI
                      ]
        
        // 发起请求
        request(method: .POST, URLString: urlStr, parameters: params as [String : AnyObject]) { (json, isSuccess) in
            
            // 如果请求失败，对用户账户数据不会有任何影响
            // 直接用字典设置 userAccount
            self.userAccount.yy_modelSet(with: (json as? [String: AnyObject]) ?? [:])
            
            // 加载用户信息
            self.loadUserInfo(completion: { (dict) in
                
                // 使用用户信息字典 设置用户信息（昵称和头像url）
                self.userAccount.yy_modelSet(with: dict)
                
                // 设置完用户信息之后再保存
                // 保存用户账号信息
                self.userAccount.saveAccount()
                
                // 加载用户信息完成之后，再回调
                completion(isSuccess)
            })
        }
    }
}












