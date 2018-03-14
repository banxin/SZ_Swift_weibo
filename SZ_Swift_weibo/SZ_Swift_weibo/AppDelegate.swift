//
//  AppDelegate.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = WBMainViewController()
        
        window?.makeKeyAndVisible()
        
        //        loadAppInfo()
        
        return true
    }
}

// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    
    private func loadAppInfo() {
        
        // 1.模拟异步
        DispatchQueue.global().async {
            
            // 1>.url
            let url = "/Users/yanl/Movies/Practice Project/weibo/传智微博/传智微博/Classes/View(视图和控制器)/Main/主控制器/main.json"
            
            // 2> data
            let data = try? String.init(contentsOfFile: url).data(using: .utf8)
            
            // 3> 写入磁盘
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
            // /Users/yanl/Library/Developer/CoreSimulator/Devices/DE29EADC-0D0F-4329-96D0-F92DF9278426/data/Containers/Data/Application/701B38D3-6EAF-467B-9B4F-F67FB818079C/Documents/main.json
            
            // 直接保存在沙盒，等待下一次程序启动使用
            (data!! as NSData).write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕 \(jsonPath)")
        }
    }
}

