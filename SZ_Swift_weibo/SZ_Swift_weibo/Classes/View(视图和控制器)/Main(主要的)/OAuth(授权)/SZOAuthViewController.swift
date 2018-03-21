//
//  SZOAuthViewController.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/20.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 通过 webview 加载 新浪微博 授权页面控制器
class SZOAuthViewController: UIViewController {

    private lazy var webView = UIWebView()
    
    override func loadView() {
        
        view = webView
        
        view.backgroundColor = UIColor.white
        
        // 取消滚动视图 - 新浪微博服务器，返回的授权页面默认就是手机全屏
        webView.scrollView.isScrollEnabled = false
        
        // 设置代理
        webView.delegate = self
        
        // 设置导航栏标题
        title = "登录新浪微博"
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem  = UIBarButtonItem.init(title: "返回", target: self, action: #selector(close), isBackButton: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "自动填充", target: self, action: #selector(autoFill))
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 加载授权页面
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(SZAppKey)&redirect_uri=\(SZRedirectURI)"
        
        // 1> URL 确定要访问的资源
        guard let url = URL.init(string: urlStr) else {
                
            return
        }
        
        // 2> 建立请求
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }

    // MARK: - 监听方法
    
    /// 关闭当前页面
    @objc private func close() {
        
        SVProgressHUD.dismiss()
        
        dismiss(animated: true, completion: nil)
    }
    
    /// 自动填充 - webview 的注入，直接通过 js 修改 本地浏览器中缓存的页面内容
    /// 点击 登录 按钮， 执行 submit 时，将本地数据提交给服务器
    @objc private func autoFill() {
        
        // 准备 js
        let js = "document.getElementById('userId').value = '13355713728';"
                + "document.getElementById('passwd').value = 'lang3728hbfs';"
        
        // 让 webview 执行 js
        webView.stringByEvaluatingJavaScript(from: js)
    }
}

extension SZOAuthViewController: UIWebViewDelegate {
    
    /// webview 将要加载请求
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: 将要加载的请求
    ///   - navigationType: 导航类型
    /// - Returns: 是否加载 request
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 确认思路：
        
        // 1. 如果请求地址 包含 "http://www.baidu.com" 不加载页面，否则加载页面
        // request.url?.absoluteString.hasPrefix(SZRedirectURI) 返回的是可选项 true / false / nil
        if request.url?.absoluteString.hasPrefix(SZRedirectURI) == false {
            
            // 如果不是 http://www.baidu.com 前缀，继续加载
            return true
        }
        
//        print("加载请求 --- \(request.url?.absoluteString ?? "")")
        // query（查询字符串） 就是 url 中 ？后面所有部分
//        print("加载请求 --- \(request.url?.query ?? "")")
        
        // 2. 从 http://www.baidu.com 回调地址的字符串中，查找 'code='
        // 如果有 code ，授权成功，否则授权失败
        if request.url?.query?.hasPrefix("code=") == false {
            
            print("取消授权")
            
            // 关闭该页面
            close()
            
            return false
        }
        
        // 3. 从 query 字符串中，取出授权码
        // 代码走到此处，url 中，一定有查询字符串，并且包含 "code="
        // code=25109e68ecb01ccb3c1bf162fbce47d0
        // substring 在 4.0 被废弃
//        let code = request.url?.query?.substring(from: "code=".endIndex) ?? ""
//
//        print("获取授权码...\(code)")
        
        let code = request.url?.query?.suffix(from: "code=".endIndex) ?? ""
        
//        print("获取授权码...\(code)")
        
        // 4. 使用授权码来获取[换取] accessToken
        SZNetworkManager.shared.loadAccessToken(code: String(code)) { (isSuccess) in
            
            if !isSuccess {
                
                SVProgressHUD.showInfo(withStatus: "网络请求失败！")
                
            } else {
                
                SVProgressHUD.showSuccess(withStatus: "登录成功！")
                
                // 下一步做什么？ 跳转界面 ？如何跳转 ？-- 发送登录成功消息
                
                // 1> 发送通知 - 不关心有没有监听者
                NotificationCenter.default.post(
                    name  : NSNotification.Name(rawValue: SZUserLoginSuccessNotification),
                    object: nil)
                
                // 2> 关闭窗口
                self.close()
            }
        }
    
        return false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        SVProgressHUD.dismiss()
    }
}





















