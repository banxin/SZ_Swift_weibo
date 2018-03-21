//
//  SZVistorView.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/15.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import SnapKit

/// 访客视图
class SZVistorView: UIView {
    
    // 注册按钮
    lazy var registerBtn: UIButton = UIButton.init(
        title: "注册",
        fontSize: 16,
        normalColor: UIColor.orange,
        highlightColor: UIColor.black,
        backImageName: "common_button_white_disable")
    
    // 登录按钮
    lazy var loginBtn: UIButton = UIButton.init(
        title: "登录",
        fontSize: 16,
        normalColor: UIColor.darkGray,
        highlightColor: UIColor.black,
        backImageName: "common_button_white_disable")
    
    /// 访客视图的信息字典 [imageName / message]
    /// 提示：如果是首页，imageName = ""
    var vistorInfo: [String: String]? {
        
        didSet {
            
            // 1> 取字典信息
            guard let imageName = vistorInfo?["imageName"], let message = vistorInfo?["message"] else {
                
                return
            }
            
            // 2> 设置消息
            tipLabel.text = message
            
            // 3> 设置图像，首页不需要设置
            if imageName == "" {
                
                startAnimation()
                
                return
            }
            
            iconView.image = UIImage.init(named: imageName)
            
            // 其他控制器不需要显示 小房子图片 / 遮罩图片
            houseIconView.isHidden = true
            iconMaskView.isHidden = true
        }
    }

    // MARK: - 构造函数
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 首页访客视图图标旋转动画
    private func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = 2 * Double.pi
        animation.repeatCount = MAXFLOAT
        animation.duration = 15
        // 动画完成不删除，如果iconView被释放，动画会一起被销毁！
        // 在设置连续播放动画，非常有用
        animation.isRemovedOnCompletion = false
        
        iconView.layer.add(animation, forKey: nil)
    }
    
    // MARK: - 设置访客视图的信息（以字典的方式）--- 使用属性进行替代，重写set方法
    /// 使用字典设置访客视图的信息
    ///
    /// - Parameter dict: ["imageName": "图片", "message": "提示语"]
    /// 提示：如果是首页，imageName = ""
//    func setupInfo(dict: [String: String]) {
//
//        // 1> 取字典信息
//        guard let imageName = dict["imageName"], let message = dict["message"] else {
//
//            return
//        }
//
//        // 2> 设置消息
//        tipLabel.text = message
//
//        // 3> 设置图像，首页不需要设置
//        if imageName == "" {
//
//            startAnimation()
//
//            return
//        }
//
//        iconView.image = UIImage.init(named: imageName)
//        houseIconView.isHidden = true
//        iconMaskView.isHidden = true
//    }
    
    // MARK: - 私有控件
    /*
     懒加载属性细节：
     
     只有调用 UIKit 控件的指定构造函数，其他都需要使用类型，建议都加
     */
    // 图像视图
    private lazy var iconView: UIImageView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_smallicon"))
    
    // 遮罩视图 - 不要使用maskView，与系统重名了
    private lazy var iconMaskView: UIImageView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_mask_smallicon"))
    
    // 小房子
    private lazy var houseIconView: UIImageView = UIImageView.init(image: UIImage.init(named: "visitordiscover_feed_image_house"))
    
    // 提示标签
    private lazy var tipLabel: UILabel = UILabel.init(
        title: "关注一些人，回这里看看有没有什么惊喜关注一些人，回这里看看有没有什么惊喜",
        fontSize: 14,
        color: UIColor.darkGray)
    
//    // 注册按钮
//    private lazy var registerBtn: UIButton = UIButton.init(
//        title: "注册",
//        fontSize: 16,
//        normalColor: UIColor.orange,
//        highlightColor: UIColor.black,
//        backImageName: "common_button_white_disable")
//
//    // 登录按钮
//    private lazy var loginBtn: UIButton = UIButton.init(
//        title: "登录",
//        fontSize: 16,
//        normalColor: UIColor.darkGray,
//        highlightColor: UIColor.black,
//        backImageName: "common_button_white_disable")
}

// MARK: - 设置界面
extension SZVistorView {
    
    func setupUI() {
        
        // 0.开发的时候，如果能使用颜色，就不使用图像，颜色效率更高
        backgroundColor = UIColor.colorWithHex(hexString: "ededed")
        
        // 1.添加控件
        addSubview(iconView)
        addSubview(iconMaskView)
        addSubview(houseIconView)
        addSubview(tipLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        // 文本居中
        tipLabel.textAlignment = .center
        
        // 2.取消 autoresizing --> 使用 snapkit 不需要这一步
        //        for v in subviews {
        //
        //            v.translatesAutoresizingMaskIntoConstraints = false
        //        }
        
        // 3.自动布局
        // 1> 图像视图
        iconView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-60)
        }
        
        // 2> 房子视图
        houseIconView.snp.makeConstraints { (make) in
            
            make.centerX.centerY.equalTo(iconView)
        }
        
        // 3> 提示标签
        tipLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(iconView.snp.bottom).offset(20)
            make.width.equalTo(266)
        }
        
        // 4> 注册按钮
        registerBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(tipLabel.snp.left)
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            make.width.equalTo(100)
        }
        
        // 5> 登录按钮
        loginBtn.snp.makeConstraints { (make) in
            
            make.right.equalTo(tipLabel.snp.right)
            make.top.equalTo(tipLabel.snp.bottom).offset(20)
            make.width.equalTo(registerBtn)
        }
        
        // 6> 遮罩图像
        iconMaskView.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.bottom.equalTo(tipLabel.snp.top).offset(-15)
        }
    }
}






















