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
            
            // 设置配图视图的高度
            pictureView.heightCons.constant = viewModel?.pictureViewSize.height ?? 0
            // 设置配图视图的 URL 数据
            pictureView.urls = viewModel?.status.pic_urls
            
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}











