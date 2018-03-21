//
//  NSString+Extension.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/20.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation

extension String {
    
    static func getSandBoxFilePath(fileName: String) -> String {
        
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = (docDir as NSString).appendingPathComponent(fileName)
        
        return filePath
    }
}
