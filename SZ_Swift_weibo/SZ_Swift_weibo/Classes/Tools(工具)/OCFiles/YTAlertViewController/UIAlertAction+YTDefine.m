//
//  UIAlertAction+YTDefine.m
//  ytmallApp
//
//  Created by yanl on 2018/1/12.
//  Copyright © 2018年 ios. All rights reserved.
//

#import "UIAlertAction+YTDefine.h"

@implementation UIAlertAction (YTDefine)

+ (instancetype)yt_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style textColor:(UIColor *)color handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *action = [self actionWithTitle:title style:style handler:handler];
    
    [action setValue:color forKey:@"titleTextColor"];
    
    return action;
}

@end
