//
//  SZStatusCell.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/22.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZStatusCell: UITableViewCell {
    
    /// 微博视图模型
    var viewModel: SZStatusViewModel? {
        
        didSet {
            
            /// 姓名
            nameLabel?.text = viewModel?.status.user?.screen_name
            /// 微博文本
            statusLabel?.text = viewModel?.status.text
            /// 设置会员图标 - 直接获取属性，不需要计算
            memberIconView.image = viewModel?.memberImage
            /// 认证图标
            vipIconView.image = viewModel?.vipIcon
            /// 用户头像
            iconView.sz_setImage(urlStr: viewModel?.status.user?.profile_image_url, placeholder: UIImage.init(named: "avatar_default_big"), isAvadar: true)
            /// 底部工具栏
            toolBar.viewModel = viewModel
            
            // 设置配图视图的高度 - 改为使用视图模型传入，pictureView 内部处理
            //            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            
            // 设置配图视图模型
            pictureView.viewModel = viewModel
            
            // 设置配图视图的 URL 数据
//            // 测试 4 张图片
//            if viewModel!.status.pic_urls!.count > 4 {
//
//                // 修改数组，将末尾的数据全部移除
//                var picUrls = viewModel?.status.pic_urls
//
//                picUrls!.removeSubrange((picUrls!.startIndex + 4)..<picUrls!.endIndex)
//
//                pictureView.urls = picUrls
//
//            } else {
//
//                // 设置配图视图的 URL 数据
//                pictureView.urls = viewModel?.status.pic_urls
//            }
            
            // 设置配图（包含了被转发和原创）
//            pictureView.urls = viewModel?.status.pic_urls
            pictureView.urls = viewModel?.picUrls
            
            // 设置被转发微博的文字
            retweetedLabel?.text = viewModel?.retweetedText
        }
    }

    /// 头像
    @IBOutlet weak var iconView: UIImageView!
    
    /// 姓名
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 会员图标
    @IBOutlet weak var memberIconView: UIImageView!
    
    /// 时间
    @IBOutlet weak var timeLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// VIP 认证图标
    @IBOutlet weak var vipIconView: UIImageView!
    
    /// 微博正文
    @IBOutlet weak var statusLabel: UILabel!
    
    /// 底部工具栏
    @IBOutlet weak var toolBar: SZStatusToolBar!
    
    /// 配图视图
    @IBOutlet weak var pictureView: SZStatusPictureView!
    
    /// 被转发微博的文字 - 原创微博没有该控件，一定要用 '？' 可选
    @IBOutlet weak var retweetedLabel: UILabel?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // 离屏渲染 - 异步绘制
        self.layer.drawsAsynchronously = true
        // 栅格化 - 异步绘制之后，会生成一张独立的图像，cell在屏幕滚动的时候，本质上滚动的是这张图片
        // cell 优化，要尽量减少图层的数量，相当于就只有一层
        // 停止滚动之后，可以接收监听
        self.layer.shouldRasterize = true
        
        // 使用栅格化，必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    
}











