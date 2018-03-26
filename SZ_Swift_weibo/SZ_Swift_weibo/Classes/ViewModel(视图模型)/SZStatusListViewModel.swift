//
//  SZStatusListViewModel.swift
//  SZ_Swift_weibo
//
//  Created by yanl on 2018/3/19.
//  Copyright © 2018年 yanl. All rights reserved.
//

import Foundation
import SDWebImage

/// 微博首页数据列表视图模型

/*
 父类的选择：
 
 - 如果类需要使用 ‘KVC’ 或者 字典转模型框架设置属性值，类就需要继承自 NSObjet
 - 入股类只是包装一些逻辑代码（写了一些函数），可以不用任何父类，好处：更加轻量级，减少内存消耗
 - 提示：如果用 OC 写，一律继承自 NSObject 即可
 
 使命：负责微博的数据处理
 
 1.字典转模型
 2.下拉上拉数据处理
 */

/// 上拉最大尝试次数
private let maxPullupTryTimes = 3

class SZStatusListViewModel {
    
    /// 微博视图模型数组懒加载
    lazy var statusList = [SZStatusViewModel]()
    
    /// 上拉刷新错误次数
    private var pullupErrorTimes = 0
    
    /// 加载微博列表数据
    ///
    /// - Parameters:
    ///   - isPullUp: 是否上拉刷新标记
    ///   - completion: 完成回调[网络请求是否成功, 是否需要刷新表格]
    func loadStatus(isPullUp: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        // 判断是否是上拉刷新，同时检查刷新错误
        if isPullUp && pullupErrorTimes > maxPullupTryTimes {
            
            completion(true, false)
            
            return
        }
        
        // since_id ，下拉刷新，取出数组中第一条微博的 ID -- 如果是上拉刷新，就取 0，下拉的话，取第一条数据的 ID
        let since_id = isPullUp ? 0 : (statusList.first?.status.id ?? 0)
        
        // max_id ，上拉刷新，取出数组最后一条微博的 ID -- 如果不是上拉刷新，就取 0，上拉的话，取最后一条的 ID
        var max_id   = !isPullUp ? 0 : (statusList.last?.status.id ?? 0)
        
        // 解决下一页第一条与最后一条重复的问题
        max_id = max_id > 0 ? max_id - 1 : max_id
        
        SZNetworkManager.shared.statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            
            // 0. 判断网络请求是否成功
            if !isSuccess {
                
                // 直接回调翻翻
                completion(false, false)
                
                return
            }
            
            // 1. 字典转模型 （所有的第三方框架都支持嵌套的字典转模型）
            
            // 1> 定义结果可变数组
            var array = [SZStatusViewModel]()
            
            // 2> 遍历服务器返回的字典数组，字典转模型
            for dict in list ?? [] { // 遍历结束后，图片路径就已经有了
                
                // a) 创建微博模型 - 如果创建模型失败，继续后续的遍历
                guard let model = SZStatus.yy_model(with: dict) else {
                    
                    continue
                }
                
                // b) 将 视图模型 添加到数组
                array.append(SZStatusViewModel.init(model: model))
            }
            
//            guard let array = NSArray.yy_modelArray(with: SZStatus.self, json: list ?? []) as? [SZStatus] else {
//
//                // 字典转模型失败
//                completion(isSuccess, false)
//
//                return
//            }
            
            // 2. 拼接数据
            // 下拉刷新，应该将 结果数组拼接在数组前面
            //            self.statusList += array
            if isPullUp {
                
                print("加载到 \(array.count) 条数据！")
                
                // 上拉刷新结束后，将结果拼接在数组的末尾
                self.statusList += array
                
            } else {
                
                print("刷新到 \(array.count) 条数据！")
                
                // 下拉刷新结束后，将结果拼接在数组的起始
                self.statusList = array + self.statusList
            }
            
            // 3. 判断上拉刷新的数据量
            if isPullUp && array.count == 0 {
                
                self.pullupErrorTimes += 1
                
                completion(isSuccess, false)
                
            } else {
                
                // 缓存本次下载微博数据数组中的单张图像
                self.catchSimgleImage(list: array, finished: completion)
                
                // 4. 完成回调（真正有数据的回调）- 缓存完单张图像，并且修改过配图视图的大小之后，再回调，移到缓存单张图片调度组完成后
//                completion(isSuccess, true)
            }
        }
    }
    
    /// 缓存本次下载微博数据数组中的单张图像
    ///
    /// - *** 应该缓存完单张图像，并且修改过配图视图的大小之后，再回调，才能够保证表格等比例显示单张图像
    ///
    /// - Parameter list: 本次下载的视图模型数组
    private func catchSimgleImage(list: [SZStatusViewModel], finished: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool) -> ()) {
        
        /// 调度组
        let group = DispatchGroup()
        
        /// 记录数据长度
        var length = 0
        
        // 遍历数组，查找微博数据中有单张图像的，进行缓存
        // option + command + 左，折叠代码
        for vm in list {
            
            // 1> 判断图像数量
            if vm.picUrls?.count != 1 {
                
                continue
            }
            
            // 执行到此，数组中有且只有一张图片
            // 2> 获取 图像模型
            guard let pic = vm.picUrls?[0].thumbnail_pic,
                let url = URL.init(string: pic) else {
                    
                continue
            }
            
            // 下载图像
            // 1) downloadImage 是 SDWebImage 的核心方法
            // 2) 图像下载完成后，会自动保存在沙盒中，文件路径是 url 的 md5
            // 3) 如果沙盒中已经存在缓存的图像，后续使用 SD 通过 URL 加载图像，都会加载本地沙盒的图像
            // 4) 不会发起网络请求，同时，回调方法，同样会调用！
            // 5) 方法还是同样的方法，调用还是同样的调用，不过内部不会再发起网络请求！
            // *** 如果要缓存的图像，累计过大，要找后台协调对图像的处理
            
            // A> 入组
            group.enter()
            
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _) in
                
                // 将图像转换成 二进制数据
                if let image = image,
                    let data = UIImagePNGRepresentation(image) {
                    
                    // NSData 是 length
                    // 监听下图片的大小
                    length += data.count
                    
                    // 图像缓存成功，更新配图视图的大小
                    vm.updateSimgleImageSize(image: image)
                }
                
                // B> 出组 - 放在回调的最后一句
                group.leave()
            })
        }
        
        /// 监听调度组情况
        group.notify(queue: DispatchQueue.main) {
            
            print("图片缓存完成 -> \(length / 1024)K")
            
            finished(true, true)
        }
    }
}






















