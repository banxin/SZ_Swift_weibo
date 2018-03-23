//
//  SZStatusToolBar.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/23.
//  Copyright © 2018年 yanl. All rights reserved.
//

import UIKit

class SZStatusToolBar: UIView {
    
    var viewModel: SZStatusViewModel? {
        
        didSet {
            
//            retweetBtn.setTitle("  \(viewModel?.status.reposts_count ?? 0)", for: .normal)
//            commentBtn.setTitle("  \(viewModel?.status.comments_count ?? 0)", for: .normal)
//            likeBtn.setTitle("  \(viewModel?.status.attitudes_count ?? 0)", for: .normal)
            
            retweetBtn.setTitle(viewModel?.retweetStr, for: .normal)
            commentBtn.setTitle(viewModel?.commentStr, for: .normal)
            likeBtn.setTitle(viewModel?.likeStr, for: .normal)
        }
    }
    
    /// 转发
    @IBOutlet weak var retweetBtn: UIButton!
    
    /// 评论
    @IBOutlet weak var commentBtn: UIButton!
    
    /// 点赞
    @IBOutlet weak var likeBtn: UIButton!
}
