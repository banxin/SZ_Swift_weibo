//
//  SZWelcomeView.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/21.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit
import SDWebImage

/// 欢迎视图
class SZWelcomeView: UIView {
    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    class func welcomeView() -> SZWelcomeView {
        
        let nib = UINib(nibName: "SZWelcomeView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! SZWelcomeView
        
        // 从 xib 加载的视图，默认是 600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
//    required init?(coder aDecoder: NSCoder) {
//
//        super.init(coder: aDecoder)
//
//        // 提示：initWithCorder 只是刚刚从 XIB 的二进制文件将试图数据加载完成
//        // 还没有和代码连线，建立起关系，开发时，千万不要在这个方法中处理 UI
////        print("initWithCorder + \(iconView)")
//    }
    
    /// 从 XIB 加载完成调用
    override func awakeFromNib() {
        
        // awakeFromNib 不用 super
//        super.awakeFromNib()
    
        // 1. url
        guard let urlStr = SZNetworkManager.shared.userAccount.avatar_large else {
            
            return
        }
        
        // 2. 设置头像 - 如果网络图像没有加载完成，先显示占位图像
        // 如果不指定占位图像，之前设定的图像会被清空
        iconView.sd_setImage(with: URL.init(string: urlStr), placeholderImage: UIImage.init(named: "avatar_default_big"))
        
        // 3. 设置圆角 - （iconView 的 bounds 还没有值）
        iconView.clipsToBounds = true
        iconView.layer.cornerRadius = 42.5
    }
    
    /// 自动布局系统更新完成约束后，会自动调用该方法
    /// 通常对子视图布局进行修改
//    override func layoutSubviews() {
//
//    }
    
    /// 视图被添加到 window 上，表示视图已经显示
    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        // 视图是使用自动布局来设置的，只是设置了约束
        // - 当视图被添加到窗口上时，根据父视图的大小，计算约束值，才能够更新约束位置
        // - layoutIfNeeded 会直接按照当前的约束直接更新控件位置
        // - 执行之后，控件所在的位置，就是 XIB 中布局的位置
        self.layoutIfNeeded()
        
        bottomCons.constant = bounds.size.height - 200
        
        // 如果的控件们的 frame 还没有计算好！所有控件的约束会一起动画！
        UIView.animate(withDuration: 1.6,           // 动画时长
                       delay: 0,                    // 延时时间
                       usingSpringWithDamping: 0.7, // 弹力系数，0~1，越小越弹
                       initialSpringVelocity: 0,    // 初始速度，模拟重力加速度
                       options: [],                 // 动画选项
                       animations: {
            
            // 更新约束
            self.layoutIfNeeded()
            
        }) { (_) in
            
            UIView.animate(withDuration: 1.0, animations: {
                
                self.tipLabel.alpha = 1
                
            }, completion: { (_) in
                
                // 动画完成后移除
                self.removeFromSuperview()
            })
        }
    }
}










