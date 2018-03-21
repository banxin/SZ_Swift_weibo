//
//  SZNewFeatureView.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/21.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

/// 新特性视图
class SZNewFeatureView: UIView {
    
    @IBOutlet weak var scrollerView: UIScrollView!
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    /// 进入微博
    @IBAction func enterStatus() {
        
        removeFromSuperview()
    }

    class func newFeatureView() -> SZNewFeatureView {
        
        let nib = UINib(nibName: "SZNewFeatureView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! SZNewFeatureView
        
        // 从 xib 加载的视图，默认是 600 * 600
        v.frame = UIScreen.main.bounds
        
        return v
    }
    
    override func awakeFromNib() {
        
        // 如果使用自动布局设置的界面，从 XIB 加载，默认是 600 * 600
        // 添加 4 个 图像视图
        let count = 4
        let rect = UIScreen.main.bounds
        
        for i in 0..<count {
            
            let imageName = "new_feature_\(i + 1)"
            
            let iv = UIImageView.init(image: UIImage.init(named: imageName))
            
            // 设置大小
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            
            scrollerView.addSubview(iv)
        }
        
        // 指定 scroller 的属性
        scrollerView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        // 禁用弹簧效果，防止左侧显示不正
        scrollerView.bounces = false
        scrollerView.isPagingEnabled = true
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.showsVerticalScrollIndicator = false
        
        scrollerView.delegate = self
        
        // 隐藏按钮
        enterButton.isHidden = true
    }
}

// MARK: - UIScrollViewDelegate
extension SZNewFeatureView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 1. 滚动到最后一屏，让视图删除
        let page = Int(scrollerView.contentOffset.x / scrollerView.bounds.width)
        
        // 2. 判断是否最后一页
        if page == scrollerView.subviews.count {
            
            removeFromSuperview()
        }
        
        // 3. 如果是倒数第二页，显示按钮
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0. 一旦滚动，隐藏按钮
        enterButton.isHidden = true
        
        // 1. 计算当前的偏移量
        let page = Int(scrollerView.contentOffset.x / scrollerView.bounds.width + 0.5)
        
        // 2. 设置分页控件
        pageControl.currentPage = page
        
        // 3. 分页控件的隐藏
        pageControl.isHidden = (page == scrollView.subviews.count)
    }
}
























