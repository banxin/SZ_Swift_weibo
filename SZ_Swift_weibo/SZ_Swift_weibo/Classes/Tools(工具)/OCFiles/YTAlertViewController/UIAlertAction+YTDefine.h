//
//  UIAlertAction+YTDefine.h
//  ytmallApp
//
//  Created by yanl on 2018/1/12.
//  Copyright © 2018年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertAction (YTDefine)

+ (instancetype _Nullable )yt_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style textColor:(UIColor *_Nullable)color handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

@end
