//
//  UIView+YTAddClickedEvent.m
//  ytmallApp
//
//  Created by yanl on 2017/9/20.
//  Copyright © 2017年 ios. All rights reserved.
//

#import "UIView+YTAddClickedEvent.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, copy) void(^clickedAction)(id);

@end

@implementation UIView (YTAddClickedEvent)

- (void)setClickedAction:(void (^)(id))clickedAction
{
    objc_setAssociatedObject(self, @"AddClickedEvent", clickedAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(id))clickedAction
{
    return objc_getAssociatedObject(self, @"AddClickedEvent");
}

 - (void)addClickedBlock:(void(^)(id obj))clickedAction
{
    self.clickedAction = clickedAction;
    // hy:先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        // hy:添加单击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tap
{
    if (self.clickedAction) {
        
        self.clickedAction(self);
    }
}

@end
