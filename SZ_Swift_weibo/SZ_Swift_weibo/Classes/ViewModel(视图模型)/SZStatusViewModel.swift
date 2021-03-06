//
//  SZStatusViewModel.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/22.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation

/// 单条微博的视图模型
/*
 如果没有任何父类，在开发时调试，输出调试信息，需要：
 
 1. 遵守 CustomStringConvertible 协议
 2. 实现 description 计算型属性
 
 然后就可以跟踪调试
 */
/*
 关于表格的性能优化：（用内存 换 CPU）
 
 - 尽量少计算，所有需要的属性提前计算
 - 控件上，不要设置圆角半径，所有图像渲染属性都要考虑
 - 不要动态创建控件，所有需要的控件都要提前创建好，在显示的时候，根据数据 隐藏 / 显示
 - CELL 中 控件的层次越少越好，数量越少越好
 - 要测量，不要猜测
 */
class SZStatusViewModel: CustomStringConvertible {
    
    /// 微博模型
    var status: SZStatus
    
    /// 会员图标 - 存储型属性（用内存换CPU）
    var memberImage: UIImage?
    
    /// 认证类型，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
    var vipIcon: UIImage?
    
    /// 转发文字
    var retweetStr: String?
    
    /// 评论文字
    var commentStr: String?
    
    /// 点赞文字
    var likeStr: String?
    
    /// 配图视图大小
    var pictureViewSize = CGSize()
    
    /// 如果是被转发的微博，原创微博一定没有图
    var picUrls: [SZStatusPicture]? {
        
        // 如果有被转发的微博，那返回被转发微博的配图
        // 如果没有被转发的微博，返回原创微博的配图
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    
    /// 被转发微博的文字
    var retweetedText: String?
    
    /// 行高
    var rowHeight: CGFloat?
    
    /// 构造函数
    ///
    /// - Parameter model: 微博模型
    ///
    /// return: 微博的视图模型
    init(model: SZStatus) {
        
        self.status = model
        
        // 会员等级 0-6
        guard let mbrank = model.user?.mbrank else {
            
            memberImage = UIImage.init(named: "common_icon_membership_expired")
            
            return
        }
        
        var imageName = "common_icon_membership_expired"
        
        
        if mbrank > 0 && mbrank < 7 {
            
            imageName = "common_icon_membership_level\(mbrank)"
        }
        
        memberImage = UIImage.init(named: imageName)
        
        // 认证图标 ，-1：没有认证，0，认证用户，2,3,5: 企业认证，220: 达人
        switch model.user?.verified_type ?? -1 {
            
        case 0:
            vipIcon = UIImage.init(named: "avatar_vip")
        case 2, 3, 5:
            vipIcon = UIImage.init(named: "avatar_enterprise_vip")
        case 220:
            vipIcon = UIImage.init(named: "avatar_grassroot")
        default:
            break
        }
        
        // 设置底部计数字符串
//        // 测试大于一万
//        status.reposts_count = Int(arc4random_uniform(100000))
        retweetStr = countString(count: status.reposts_count, defaultStr: "转发")
        commentStr = countString(count: status.comments_count, defaultStr: "评论")
        likeStr = countString(count: status.attitudes_count, defaultStr: "赞")
        
        // 计算配图视图大小（有原创的计算原创的，有转发的计算转发的）
//        pictureViewSize = calcPictureViewSize(count: status.pic_urls?.count)
        pictureViewSize = calcPictureViewSize(count: picUrls?.count)
        
        // 设置被转发微博的文字 - 
        retweetedText = "@" + (status.retweeted_status?.user?.screen_name ?? "")
        
        retweetedText = retweetedText! + ":" + (status.retweeted_status?.text ?? "")
        
        // 计算行高
        updateRowHeight()
    }
    
    /// 视图模型 描述信息
    var description: String {
        
        return status.yy_modelDescription()
    }

    /// 使用单个图像 更新单个视图的大小
    ///
    /// 新浪针对单张图片，都是缩略图，但是偶尔会出现一张特别大的图 7000 * 9000
    /// 新浪微博，为了鼓励原创，支持长微博，长图，但是有的时候有特别长的微博，长到宽度只有 1 个点
    /// - Parameter image: 网络缓存的单张图像
    func updateSimgleImageSize(image: UIImage) {
        
        var size = image.size
        
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40
        
        // 过宽图像处理
        if size.width > maxWidth {
            
            // 设置最大宽度
            size.width = maxWidth
            
            // 等比例调整高度
            // 要特殊处理，不然高度太大，影响体验
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        // 过窄的图像处理
        if size.width < minWidth {
            
            size.width = minWidth
            // 等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        // 注意，尺寸需要增加顶部的 12 ，便于布局
        size.height += SZStatusPictureViewOutterMargin
        
        // 重新设置配图视图大小
        pictureViewSize = size
        
        // 更新行高
        updateRowHeight()
    }
    
    /// 根据当前的视图模型内容计算行高
    func updateRowHeight() {
        
        // 原创微博：顶部分隔视图（12）+ 间距（12）+ 图像的高度（34）+ 间距（12）+ 正文高度（需要计算）+ 配图视图高度（需要计算）+ 间距（12）+ 底部视图（35）
        // 转发微博：顶部分隔视图（12）+ 间距（12）+ 图像的高度（34）+ 间距（12）+ 正文高度（需要计算）+ 间距（12）+ 间距（12）+ 转发文本的高度（需计算）+ 配图视图高度（需要计算）+ 间距（12）+ 底部视图（35）
        
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolBarHeight: CGFloat = 35
        
        let viewSize = CGSize(width: UIScreen.main.screenWidth - 2 * margin, height: CGFloat(MAXFLOAT))
        let originFont = UIFont.systemFont(ofSize: 15)
        let retweetFont = UIFont.systemFont(ofSize: 14)
        
        var height: CGFloat = 0
        // 1. 计算顶部位置
        height = 2 * margin + iconHeight + margin
        
        // 2. 正文高度
        if let text = status.text {
            
            /*
             1> 预期尺寸，宽度固定，高度尽量大
             2> 选项，换行文本，统一使用 usesLineFragmentOrigin
             3> attributes 指定字体字典
             */
            height += (text as NSString).boundingRect(with: viewSize,
                                            options: [.usesLineFragmentOrigin],
                                            attributes: [NSAttributedStringKey.font: originFont],
                                            context: nil).height
        }
        
        // 3. 判断是否转发微博
        if status.retweeted_status != nil {
            
            height += 2 * margin
            
            // 转发文本的高度 - 一定用 retweetedText ，拼接了 @用户名：微博文字
            if let text = retweetedText {
                
                height += (text as NSString).boundingRect(with: viewSize,
                                                          options: [.usesLineFragmentOrigin],
                                                          attributes: [NSAttributedStringKey.font: retweetFont],
                                                          context: nil).height
            }
        }
        
        // 4. 配图视图高度
        height += pictureViewSize.height
        
        height += margin
        
        // 5. 底部工具栏
        height += toolBarHeight
        
        // 6. 使用属性记录
        rowHeight = height
    }
    
    /// 给定一个数字，返回对应的描述结果
    ///
    /// - Parameters:
    ///   - count: 数字
    ///   - defaultStr: 默认字符串 转发 / 评论 / 赞
    /// - Returns: 对应的描述结果
    /*
     需求：
     
     = 0，显示默认标题
     小于10000，显示实际值
     大于10000，显示x.xx万
     */
    private func countString(count: Int, defaultStr: String) -> String {
        
        if count == 0 {
            
            return ("  " + defaultStr)
        }
        
        if count < 10000 {
            
            return "  \(count.description)"
        }
        
        return String(format: "  %.2f万", Double(count) / 10000)
    }
    
    /// 计算指定数量的图片对应的配图视图的大小
    ///
    /// - Parameter count: 配图数量
    /// - Returns: 配图大小
    private func calcPictureViewSize(count: Int?) -> CGSize  {
        
        guard let count = count else {
            
            return CGSize()
        }
        
        if count == 0 {
            
            return CGSize()
        }
        
        // 1. 计算配图视图的宽度 
        
        // 2. 计算高度
        // 1> 根据 count 计算行数 1 ~ 9
        let row = CGFloat((count - 1) / 3 + 1)
        
        // 2> 根据行数算高度
        let height = SZStatusPictureViewOutterMargin + row * SZStatusPictureViewItemWidth + (row - 1) * SZStatusPictureViewInnerMargin
        
        return CGSize(width: SZStatusPictureViewWidth, height: height)
    }
}
















