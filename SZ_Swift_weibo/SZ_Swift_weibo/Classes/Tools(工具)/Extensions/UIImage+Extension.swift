//
//  UIImage+Extension.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/22.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation

extension UIImage {
    
    /// 创建圆角头像
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - backColor: 背景颜色
    ///   - lineColor: border 颜色
    /// - Returns: 裁切后的图像
    func sz_avatarImage(size: CGSize?, backColor: UIColor = UIColor.white, lineColor: UIColor = UIColor.lightGray) -> UIImage? {
        
        var size = size
        
        if size == nil {
            
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        // 1. 开启图片上下文 - 图片上下文，会在内存中开辟一个地址，与屏幕无关！
        /*
         参数：
         1> size：绘图的尺寸
         2> opaque：不透明 false（透明） / true（不透明）
         混合模式影响性能，会消耗GPU的计算，所以画图时应使用 true（不透明），减少 GPU 的混合计算
         3> scale；屏幕分辨率 如果不指定，默认生成的图像使用 1.0 分辨率，图像质量不好
         可以指定 0 ，会选择当前设备的屏幕分辨率
         */
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        // 0> 背景填充
        backColor.setFill()
        // 矩形填充
        UIRectFill(rect)
        
        // 设置圆角
        // 1> 实例化一个圆形路径
        let path = UIBezierPath(ovalIn: rect)
        
        // 2> 进行路径裁切 - 后续的绘图，都会出现在圆形的内部，外部的全部移除
        path.addClip()
        
        // 2. 绘图 drawInRect 就是在指定区域内，拉伸屏幕
        draw(in: rect)
        
        // 3> 设置内切的圆 - 画 border
        let ovalPath = UIBezierPath(ovalIn: rect)
        lineColor.setStroke()
        ovalPath.lineWidth = 2
        ovalPath.stroke()
        
        // 3. 取出结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 5. 返回 图片
        return result
    }
    
    /// 获取指定大小的图片
    ///
    /// - Parameters:
    ///   - size: 大小
    ///   - backColor: 背景颜色
    /// - Returns: 指定大小的图片
    func sz_image(size: CGSize? = nil, backColor: UIColor = UIColor.white) -> UIImage? {
        
        var size = size
        
        if size == nil {
            
            size = self.size
        }
        
        let rect = CGRect(origin: CGPoint(), size: size!)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        
        backColor.setFill()
        UIRectFill(rect)
        
//        let path = UIBezierPath(ovalIn: rect)
//
//        path.addClip()
        
        draw(in: rect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
}























