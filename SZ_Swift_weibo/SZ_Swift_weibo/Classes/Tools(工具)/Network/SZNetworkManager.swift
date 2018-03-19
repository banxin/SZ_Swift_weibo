//
//  SZNetworkManager.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/19.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import AFNetworking

/// Swift 的枚举支持任意数据类型
/// Switch / enum 在OC中只支持整数
enum SZHTTPMethod {
    
    case GET
    case POST
}

class SZNetworkManager: AFHTTPSessionManager {
    
    /// 静态区 / 常量 / 闭包
    /// 在第一次访问时，执行闭包，并且将结果保存在shared常量中
    static let shared = SZNetworkManager()
    
    /// 访问令牌，所有网络请求，都基于此令牌（登录除外）
    /// 为了保护用户安全，token是有时限的，默认用户是 三天
    var accessToken: String? = "2.00agKp7GmmCIeCc2f7e5c3d26H97nD"
    
    // 模拟 token 过期 -> 服务器返回的状态码是 403，需要处理
//    var accessToken: String? = "2.00agKp7GmmCIeCc2f7e5c3d26H97nD我是token"
    
    /// 专门负责拼接 token 的网络请求方法
    func tokenRequest(method: SZHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 处理 token 字典
        // 0> 判断 token 是否 为nil，如果为 nil， 直接返回
        guard let token = accessToken else {
            
            // FIXME: 发送通知，提示用户登录
            print("没有 token，需要登录")
            
            completion(nil, false)
            
            return
        }
        
        // 1> 判断 参数字典是否存在，如果为 nil ，应该新建一个字典
        var parameters = parameters
        
        if parameters == nil {
            
            // 实例化字典
            parameters = [String: AnyObject]()
        }
        
        // 2> 设置参数字典，代码在此处 parameters 一定有值
        parameters!["access_token"] = token as AnyObject
        
        // 调用 request ，发起真正的网络请求方法
        request(method: method, URLString: URLString, parameters: parameters, completion: completion)
    }

    /// 封装 AFN 的 get / post 请求
    ///
    /// - Parameters:
    ///   - method: GET / POST
    ///   - URLString: URLString
    ///   - parameters: 参数字典
    ///   - completion: 完成回调[json(字典/数组), 是否成功]
    func request(method: SZHTTPMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ json: AnyObject?, _ isSuccess: Bool) -> ()) {
        
        // 成功回调
        let success = { (task: URLSessionDataTask, json: Any?) -> () in
            
            completion(json as AnyObject, true)
        }
        
        // 失败回调
        let failure = { (task: URLSessionDataTask?, error: Error) -> () in
            
            // 针对 403，处理用户 token 过期
            // 可选不可以参与计算，但是可以参与比较
            if (task?.response as? HTTPURLResponse)?.statusCode == 403 {
                
                print("token 过期了")
                
                // FIXME: 发送通知，提示用户再次登录（本方法不知道被谁调用，谁接收到通知，谁处理）
            }
            
            // error 通常比较吓人，很多很杂的东西，例如：编号XXX，错误信息一堆英文！
            print("网络请求错误 -> \(error)")
            
            completion(nil, false)
        }
        
        if method == .GET {
            
            get(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
            
        } else {
            
            post(URLString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
