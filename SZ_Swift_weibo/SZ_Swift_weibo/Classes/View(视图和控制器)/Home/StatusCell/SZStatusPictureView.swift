//
//  SZStatusPictureView.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/23.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation

class SZStatusPictureView: UIView {
    
    /// 配图视图数组
    var urls: [SZStatusPicture]? {
        
        didSet {
            
            // 1. 隐藏所有的 imageView
            for v in subviews {
                
                v.isHidden = true
            }
            
            // 2. 遍历 urls数组，顺序设置图像
            var index = 0
            for url in urls ?? [] {
                
                // 获得对应索引的 image
                let iv = subviews[index] as! UIImageView
                
                // 4 张图像处理
                if index == 1 && urls?.count == 4 {
                    
                    index += 1
                }
                
                // 设置图像
                iv.sz_setImage(urlStr: url.thumbnail_pic, placeholder: nil)
                
                // 显示图像
                iv.isHidden = false
                
                index += 1
            }
        }
    }
    
    /// 图片视图 高度约束
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        setupUI()
    }
}

// MARK: - 设置界面
extension SZStatusPictureView {
    
    // 1. Cell 中所有的空间，都是提前准备好
    // 2. 设置的时候，根据数据是否显示
    // 3. 不要动态创建控件
    private func setupUI() {
        
        // 设置背景颜色
        backgroundColor = superview?.backgroundColor
        
        // 超出边界的内容不显示
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect(x: 0, y: SZStatusPictureViewOutterMargin, width: SZStatusPictureViewItemWidth, height: SZStatusPictureViewItemWidth)
        
        // 循环创建9个Image
        for i in 0..<count * count {
            
            let iv = UIImageView.init()
            
            // 设置 contentMode
            iv.contentMode = .scaleAspectFit
            iv.clipsToBounds = true
            
            // 行 -> Y
            let row = CGFloat(i / count)
            
            // 列 -> X
            let col = CGFloat(i % count)
            
            /// x轴 偏移量
            let xOffset = col * (SZStatusPictureViewItemWidth + SZStatusPictureViewInnerMargin)
            /// y轴 偏移量
            let yOffset = row * (SZStatusPictureViewItemWidth + SZStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            
            addSubview(iv)
        }
    }
}


















