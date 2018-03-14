//
//  Bundle+Extentions.swift
//  反射机制
//
//  Created by yanl on 2017/11/12.
//  Copyright © 2017年 yanl. All rights reserved.
//

import Foundation

extension Bundle {
    
    // 返回命名空间字符串
//    func namespace() -> String {
//
//        // 1> 因为字典是可选的，因此需要解包再取值
//        //      如果字典为nil，就不取值
//        // 2> 通过key从字典中取值，如果key错了，就没有值了
//        //      Any? 表示不一定能获取到值
////        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
//        return infoDictionary?["CFBundleName"] as? String ?? ""
//    }
    
    // 计算型属性类似于函数，没有参数，有返回值
    var namespace: String {
        
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
