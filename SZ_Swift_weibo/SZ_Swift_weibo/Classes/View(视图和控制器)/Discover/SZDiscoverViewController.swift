//
//  SZDiscoverViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/14.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZDiscoverViewController: SZBaseViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // 测试修改 token
        // 模拟没有token
//        SZNetworkManager.shared.userAccount.access_token = nil
        // 模拟过期
//        SZNetworkManager.shared.userAccount.access_token = "hello token"
        
        print("修改token")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
