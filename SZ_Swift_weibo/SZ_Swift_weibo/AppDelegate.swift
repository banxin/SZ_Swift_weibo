//
//  AppDelegate.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // #available 检测 设备版本，如果 10.0 以上
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                
                print("授权" + (success ? "成功" : "失败"))
            }
            
        } else {
            
            // 10.0 以下
            // 取得用户授权显示通知[上方的提示条 / 声音 / badgeNum]
            let notifySetting = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            
            application.registerUserNotificationSettings(notifySetting)
        }
        
        window = UIWindow()
        
        window?.backgroundColor = UIColor.white
        
        window?.rootViewController = SZMainViewController()
        
        window?.makeKeyAndVisible()
        
        // 调用模拟从服务器加载应用程序信息
//        loadAppInfo()
        
        return true
    }
}

// MARK: - 模拟从服务器加载应用程序信息
extension AppDelegate {
    
    private func loadAppInfo() {
        
        // 1.模拟异步
        DispatchQueue.global().async {
            
            // 1>. 获取 本地JSON文件 url
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            
            // 2> 将文件内容转换为 data
            let data = NSData.init(contentsOf: url!)
        
            // 3> 写入磁盘
            // 取沙盒目录
            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
            
//            /Users/yanl/Library/Developer/CoreSimulator/Devices/1243B032-91F5-4DD6-852C-4C15AE648457/data/Containers/Data/Application/591CE458-FA16-463A-AF3A-3CE1663C9709/Documents/main.json
            
            // 直接保存在沙盒，等待下一次程序启动使用
            data?.write(toFile: jsonPath, atomically: true)
            
            print("应用程序加载完毕 \(jsonPath)")
        }
    }
}

