//
//  UIAlertController+YTDefine.h
//  ytmallApp
//
//  Created by yanl on 2018/1/12.
//  Copyright © 2018年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (YTDefine)

+ (instancetype _Nullable )yt_alertControllerWithTitle:(nullable NSString *)title titleColor:(UIColor *_Nullable)titleColor message:(nullable NSString *)message messageColor:(UIColor *_Nullable)messageColor preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
