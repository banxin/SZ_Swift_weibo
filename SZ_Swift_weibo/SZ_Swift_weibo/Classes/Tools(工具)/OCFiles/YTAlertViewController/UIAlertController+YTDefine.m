//
//  UIAlertController+YTDefine.m
//  ytmallApp
//
//  Created by yanl on 2018/1/12.
//  Copyright © 2018年 ios. All rights reserved.
//

#import "UIAlertController+YTDefine.h"

@implementation UIAlertController (YTDefine)

+ (instancetype _Nullable )yt_alertControllerWithTitle:(nullable NSString *)title titleColor:(UIColor *_Nullable)titleColor message:(nullable NSString *)message messageColor:(UIColor *_Nullable)messageColor preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    UIAlertController *alertController = [self alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if (title != nil && titleColor != nil) {
        
        // 修改title
        NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
        
        [alertControllerStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, title.length)];
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    }
    
    if (message != nil && messageColor != nil) {
        
        NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
        
        [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:messageColor range:NSMakeRange(0, message.length)];
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    }
    
    return alertController;
}

@end
