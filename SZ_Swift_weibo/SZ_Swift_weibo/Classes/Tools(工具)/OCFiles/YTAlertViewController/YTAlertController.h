//
//  YTAlertController.h
//  ytmallApp
//
//  Created by yanl on 2018/1/15.
//  Copyright © 2018年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 同系统的UIAlertController使用，只是多了些自定义
 */
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YTAlertActionStyle) {
    
    // 前三种与系统一致
    YTAlertActionStyleDefault = 0,
    YTAlertActionStyleCancel,
    YTAlertActionStyleDestructive,
    // 红底白字
    YTAlertActionStyleAction,
    // YT 自定义Cancel（444444，不加粗）
    YTAlertActionStyleYTCancel
};

typedef NS_ENUM(NSInteger, YTAlertControllerStyle) {
    
    YTAlertControllerStyleAlert = 0,
    YTAlertControllerStyleActionSheet // 暂未实现，如果项目后期有需要，继续开发
};

@interface YTAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YTAlertActionStyle)style handler:(void (^ __nullable)(YTAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) YTAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface YTAlertController : UIViewController

@property (nonatomic, readonly) NSArray<YTAlertAction *> *actions;
@property (nullable, nonatomic, readonly) NSArray<UITextField *> *textFields;
@property (nonatomic, readonly) YTAlertControllerStyle preferredStyle;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, assign) NSTextAlignment messageAlignment;

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(YTAlertControllerStyle)preferredStyle;
- (void)addAction:(YTAlertAction *)action;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@end

NS_ASSUME_NONNULL_END
