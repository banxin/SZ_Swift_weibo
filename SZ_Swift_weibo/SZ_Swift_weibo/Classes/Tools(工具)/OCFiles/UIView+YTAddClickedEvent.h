//
//  UIView+YTAddClickedEvent.h
//  ytmallApp
//
//  Created by yanl on 2017/9/20.
//  Copyright © 2017年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YTAddClickedEvent)

- (void)addClickedBlock:(void(^)(id obj))tapAction;

@end
