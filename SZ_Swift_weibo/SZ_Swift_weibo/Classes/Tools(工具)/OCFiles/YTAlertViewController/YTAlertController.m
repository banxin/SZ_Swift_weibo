//
//  YTAlertController.m
//  ytmallApp
//
//  Created by yanl on 2018/1/15.
//  Copyright © 2018年 ios. All rights reserved.
//

#import "YTAlertController.h"

#define ActionDefaultColor [UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1.00]
#define ActionDestructiveColor [UIColor colorWithRed:0.99 green:0.26 blue:0.24 alpha:1.00]
#define ButtonDisableColor [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.00]
#define AlertControllerHeight CGRectGetHeight([[UIScreen mainScreen] bounds])

@interface ActionButton : UIButton

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

@implementation ActionButton

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    
    if (enabled == NO) [self setTitleColor:ButtonDisableColor forState:UIControlStateNormal];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    [self setBackgroundImage:[self imageWithColor:backgroundColor] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@interface ActionScrollView : UIScrollView

@end

@implementation ActionScrollView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]]) return YES;
    return [super touchesShouldCancelInContentView:view];
}

@end

@interface YTAlertAction ()

@property (nonatomic, copy) void(^actionHandler)(YTAlertAction *action);

@end

@implementation YTAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YTAlertActionStyle)style handler:(void (^ __nullable)(YTAlertAction *))handler
{
    YTAlertAction *instance = [YTAlertAction new];
    instance -> _title = title;
    instance -> _style = style;
    instance.actionHandler = handler;
    instance.enabled = YES; // 默认可用
    
    return instance;
}

@end

static CGRect contentViewRect;
static CGRect textScrollViewRect;
static CGRect menuScrollViewRect;

@interface YTAlertController ()
{
    UIView *_contentView;
    
    UIEdgeInsets _contentMargin; // 默认边距
    CGFloat _contentViewWidth; // 默认alertView宽度
    CGFloat _maxHeight; // alertView的最大高度
    CGFloat _buttonHeight; // 默认按钮高度
    CGFloat _maxMenuHeight; // 按钮选项的最大高度
    CGFloat _textFieldHeight; // 默认输入框高度
    CGFloat _textFieldMargin; // 输入框之间的间距
    
    BOOL _firstDisplay;
    NSUInteger _count; // style == YTAlertActionStyleCancel的action的数量
}

@property (nonatomic, strong) UIScrollView *textScrollView;
@property (nonatomic, strong) ActionScrollView *menuScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLbel;
@property (nonatomic, strong) NSMutableArray *mutableActions;
@property (nonatomic, strong) NSMutableArray *mutableTextFields;

@end

@implementation YTAlertController

#pragma mark -- 初始化
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(YTAlertControllerStyle)preferredStyle
{
    YTAlertController *instance = [YTAlertController new];
    instance.title = title;
    instance.message = message;
    instance -> _preferredStyle = preferredStyle;
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self defaultConfig]; // 默认配置
    }
    return self;
}


#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    
    NSAssert(self.title.length || self.message.length || self.actions.count || self.textFields.count, @"YTAlertController must have a title, a message or an action to display");
    
    /** 调整actions元素顺序 */
    [self adjustIndexesforActions];
    
    /** 创建基础视图 */
    [self creatContentView];
    
    /** 创建按钮 */
    [self creatAllButtons];
    
    /** 设置textScrollView的frame */
    [self configTextScrollViewFrame];
    
    /** 设置menuScrollView的frame */
    [self configMenuScrollViewFrame];
    
    /** 设置弹出框的frame */
    [self configContentViewFrame];
    
    /** 添加通知 */
    [self addNotification];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    /** 显示弹出动画 */
    [self showAppearAnimation];
}

#pragma mark -- 默认配置
- (void)defaultConfig
{
    _contentMargin = UIEdgeInsetsMake(10, 24, 25, 24);
    _maxHeight = AlertControllerHeight * 0.9;
    _contentViewWidth = 302;
    
    _buttonHeight = 45;
    _maxMenuHeight = _buttonHeight * 1.5;
    
    _textFieldHeight = 30;
    _textFieldMargin = 5;
    
    _messageAlignment = NSTextAlignmentCenter;
    _firstDisplay = YES;
    _count = 0;
}

- (void)adjustIndexesforActions
{
    // 当只有两个action时，style == YTAlertActionStyleCancel的action始终居左显示
    if (self.mutableActions.count == 2) {
        [self.mutableActions enumerateObjectsUsingBlock:^(YTAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style == YTAlertActionStyleCancel) {
                [self.mutableActions exchangeObjectAtIndex:idx withObjectAtIndex:0];
            }
        }];
    }
    
    // 当多于两个action时，style == YTAlertActionStyleCancel的action始终居下显示
    if (self.mutableActions.count > 2) {
        [self.mutableActions enumerateObjectsUsingBlock:^(YTAlertAction *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.style == YTAlertActionStyleCancel) {
                [self.mutableActions removeObject:obj];
                [self.mutableActions addObject:obj];
            }
        }];
    }
}

#pragma mark -- 创建内部视图
- (void)creatContentView
{
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5;
    _contentView.clipsToBounds = YES;
    [self.view addSubview:_contentView];
}

- (void)creatAllButtons
{
    for (int i = 0; i < self.actions.count; i++) {
        
        ActionButton *button = [ActionButton buttonWithType:UIButtonTypeCustom];
        button.tag = 10 + i;
        
        [button setBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1] forState:UIControlStateHighlighted];
        
        switch (self.actions[i].style) {
                
            case YTAlertActionStyleDefault:
                
                // 蓝色 normal
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:ActionDefaultColor forState:UIControlStateNormal];
                
                break;
                
            case YTAlertActionStyleCancel:
                
                // 蓝色加粗
                button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
                [button setTitleColor:ActionDefaultColor forState:UIControlStateNormal];
                
                break;
                
            case YTAlertActionStyleYTCancel:
                
                // 4444444,normal
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f] forState:UIControlStateNormal];
                
                break;
                
            case YTAlertActionStyleDestructive:
                
                // 红色 normal
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:ActionDestructiveColor forState:UIControlStateNormal];
                
                break;
                
            case YTAlertActionStyleAction:
                
                // 红底白字 normal
                button.titleLabel.font = [UIFont systemFontOfSize:17];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
                
                break;
                
            default:
                break;
        }
        button.enabled = self.actions[i].enabled;
        [button setTitle:self.actions[i].title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.menuScrollView addSubview:button];
        
        // 绘制横向分割线
        CGFloat lineWidth = self.actions.count > 2 ? _contentViewWidth : _contentViewWidth / self.actions.count;
        CALayer *border_hor = [CALayer layer];
        border_hor.frame = CGRectMake(0, 0, lineWidth, 0.6);
        border_hor.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1].CGColor;
        [button.layer addSublayer:border_hor];
        
        // 当有两个按钮时，绘制竖向分割线
        if (self.actions.count == 2 && i == 1) {
            CALayer *border_ver = [CALayer layer];
            border_ver.frame = CGRectMake(0, 0, 0.6, _buttonHeight - 0.6);
            border_ver.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1].CGColor;
            [button.layer addSublayer:border_ver];
        }
    }
}

#pragma mark -- 设置内部控件frame
- (void)configTextScrollViewFrame
{
    CGFloat messageY = _contentMargin.top;
    CGFloat menuHeight = [self getMenuHeight];
    CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
    CGFloat textHeight = (!self.title.length && !self.message.length && !self.textFields.count) ? 0.0 : _contentMargin.top;
    
//    CALayer *headLayer = [CALayer layer];
//
//    headLayer.frame = CGRectMake(0, 0, _contentViewWidth, _contentMargin.top + [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height + _contentMargin.top / 2);
//    headLayer.backgroundColor = HexColor(@"f7f7f7").CGColor;
//
//    [self.textScrollView.layer addSublayer:headLayer];
    
    if (self.title.length) {
        CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        self.titleLabel.frame = CGRectMake(_contentMargin.left, _contentMargin.top, labelWidth, size.height);
        messageY =  CGRectGetMaxY(self.titleLabel.frame) + _contentMargin.bottom;
        textHeight = CGRectGetMaxY(self.titleLabel.frame) + _contentMargin.bottom;
    }
    
    if (self.message.length) {
        CGSize size = [self.messageLbel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)];
        self.messageLbel.frame = CGRectMake(_contentMargin.left, messageY, labelWidth, size.height);
        textHeight = CGRectGetMaxY(self.messageLbel.frame) + _contentMargin.bottom;
    }
    
    for (int i = 0; i < self.textFields.count; i++) {
        UITextField *textField = (UITextField *)self.textFields[i];
        textField.frame = CGRectMake(_contentMargin.left, textHeight + (_textFieldHeight + 5) * i, labelWidth, _textFieldHeight);
        [self.textScrollView addSubview:textField];
        if (i == self.textFields.count - 1) textHeight = CGRectGetMaxY(textField.frame) + _contentMargin.bottom;
    }
    
    if (textHeight + menuHeight <= _maxHeight) {
        
        self.textScrollView.frame = CGRectMake(0, 0, _contentViewWidth, textHeight);
        
    } else {
        
        self.textScrollView.frame = CGRectMake(0, 0, _contentViewWidth, _maxHeight - menuHeight);
    }
    
    self.textScrollView.contentSize = CGSizeMake(_contentViewWidth, textHeight);
    
    textScrollViewRect = self.textScrollView.frame;
}

- (void)configMenuScrollViewFrame
{
    if (!self.actions.count) return;
    
    CGFloat firstButtonY = CGRectGetMaxY(self.textScrollView.frame);
    CGFloat buttonWidth = self.actions.count > 2 ? _contentViewWidth : _contentViewWidth / self.actions.count;
    
    for (int i = 0; i < self.actions.count; i++) {
        UIButton *button = (UIButton *)[self.menuScrollView viewWithTag:10 + i];
        CGFloat buttonX = self.actions.count > 2 ? 0 : buttonWidth * i;
        CGFloat buttonY = self.actions.count > 2 ? _buttonHeight * i : 0;
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, _buttonHeight);
    }
    
    CGFloat buttonTotalHeight = self.actions.count == 2 ? _buttonHeight : _buttonHeight * self.actions.count;
    CGFloat menuHeight = buttonTotalHeight > (_maxHeight - firstButtonY) ? (_maxHeight - firstButtonY) : buttonTotalHeight;
    
    self.menuScrollView.frame = CGRectMake(0, firstButtonY, _contentViewWidth, menuHeight);
    self.menuScrollView.contentSize = CGSizeMake(_contentViewWidth, buttonTotalHeight);
    
    menuScrollViewRect = self.menuScrollView.frame;
}

- (void)configContentViewFrame
{
    CGFloat firstButtonY = CGRectGetMaxY(self.textScrollView.frame);
    
    CGRect rect = _contentView.frame;
    rect.size.width = _contentViewWidth;
    rect.size.height = firstButtonY + CGRectGetHeight(self.menuScrollView.frame);
    _contentView.frame = rect;
    _contentView.center = self.view.center;
    
    contentViewRect = _contentView.frame;
}

- (CGFloat)getMenuHeight
{
    CGFloat menuHeight;
    
    if (!self.actions.count) {
        menuHeight = 0;
    }else if (self.actions.count < 3) {
        menuHeight = _buttonHeight;
    }else{
        menuHeight = _maxMenuHeight;
    }
    
    return menuHeight;
}

#pragma mark -- 事件响应
- (void)buttonDidClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    YTAlertAction *action = self.actions[sender.tag - 10];
    if (action.actionHandler) action.actionHandler(action);
    
    [self showDisappearAnimation];
}

- (void)showAppearAnimation
{
    if (!_firstDisplay) return;
    
    _firstDisplay = NO;
    _contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)showDisappearAnimation
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 方法实现
- (void)addAction:(YTAlertAction *)action
{
    if (action.style == YTAlertActionStyleCancel) _count ++;
    
    NSAssert(_count < 2, @"YTAlertController can only have one action with a style of YTAlertActionStyleCancel");
    
    [self.mutableActions addObject:action];
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *))configurationHandler
{
    UITextField *textField = [UITextField new];
    textField.font = [UIFont systemFontOfSize:15];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.mutableTextFields addObject:textField];
    
    configurationHandler(textField);
}

#pragma mark -- 添加键盘通知
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark -- 键盘通知接收处理
- (void)keyboardNotify:(NSNotification *)notify
{
    NSValue *frameNum = [notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = frameNum.CGRectValue;
    CGFloat keyboardHeight = rect.size.height + 5; // 键盘高度 + 5
    CGFloat keyboardMinY = rect.origin.y - 5; // 键盘y坐标 - 5
    
    CGFloat duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]; // 获取键盘动画持续时间
    NSInteger curve = [[notify.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue]; // 获取动画曲线
    
    CGFloat marginBottom = AlertControllerHeight - CGRectGetMaxY(_contentView.frame);
    if (marginBottom >= keyboardHeight) return;
    
    CGFloat availableHeight = AlertControllerHeight * 0.95 - keyboardHeight;
    CGFloat alertViewMinX = CGRectGetMinX(contentViewRect);
    CGFloat alertViewWidth = CGRectGetWidth(contentViewRect);
    CGFloat alertViewHeight = CGRectGetHeight(contentViewRect);
    
    if (alertViewHeight <= availableHeight) {
        
        CGFloat alertViewMinY = keyboardMinY - alertViewHeight;
        
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            
            _contentView.frame = CGRectMake(alertViewMinX, alertViewMinY, alertViewWidth, alertViewHeight);
            
        } completion:nil];
        
    }else{
        
        CGFloat difference = keyboardHeight - (AlertControllerHeight * 0.95 - alertViewHeight);
        
        alertViewHeight -= difference;
        CGFloat alertViewMinY = AlertControllerHeight * 0.05;
        
        CGFloat textScrollViewMinX = CGRectGetMinX(textScrollViewRect);
        CGFloat textScrollViewMinY = CGRectGetMinY(textScrollViewRect);
        CGFloat textScrollViewWidth = CGRectGetWidth(textScrollViewRect);
        
        CGFloat menuScrollViewMinX = CGRectGetMinX(menuScrollViewRect);
        CGFloat menuScrollViewWidth = CGRectGetWidth(menuScrollViewRect);
        CGFloat menuMinHeight = CGRectGetHeight(menuScrollViewRect) < _maxMenuHeight ? CGRectGetHeight(menuScrollViewRect) : _maxMenuHeight;
        
        CGFloat menuMaxOffset = CGRectGetHeight(menuScrollViewRect) - menuMinHeight;
        CGFloat textScrollViewOffset = difference > menuMaxOffset ? difference - menuMaxOffset : 0;
        CGFloat textScrollViewHeight = CGRectGetHeight(textScrollViewRect) - textScrollViewOffset;
        CGFloat menuScrollViewMinY = CGRectGetMinY(menuScrollViewRect) - textScrollViewOffset;
        CGFloat menuScrollViewHeight = difference > menuMaxOffset ? menuMinHeight : CGRectGetHeight(menuScrollViewRect) - difference;
        
        [UIView animateWithDuration:duration delay:0 options:curve animations:^{
            
            _textScrollView.frame = CGRectMake(textScrollViewMinX, textScrollViewMinY, textScrollViewWidth, textScrollViewHeight);
            _menuScrollView.frame = CGRectMake(menuScrollViewMinX, menuScrollViewMinY, menuScrollViewWidth, menuScrollViewHeight);
            _contentView.frame = CGRectMake(alertViewMinX, alertViewMinY, alertViewWidth, alertViewHeight);
            
        } completion:nil];
    }
}

#pragma mark -- setter & getter
- (NSString *)title
{
    return [super title];
}

- (NSArray<YTAlertAction *> *)actions
{
    return [NSArray arrayWithArray:self.mutableActions];
}

- (NSArray<UITextField *> *)textFields
{
    return [NSArray arrayWithArray:self.mutableTextFields];
}

- (NSMutableArray *)mutableActions
{
    if (!_mutableActions) {
        _mutableActions = [NSMutableArray array];
    }
    return _mutableActions;
}

- (NSMutableArray *)mutableTextFields
{
    if (!_mutableTextFields) {
        _mutableTextFields = [NSMutableArray array];
    }
    return _mutableTextFields;
}

- (UIScrollView *)textScrollView
{
    if (!_textScrollView) {
        _textScrollView = [UIScrollView new];
        _textScrollView.showsHorizontalScrollIndicator = NO;
        [_contentView addSubview:_textScrollView];
    }
    return _textScrollView;
}

- (ActionScrollView *)menuScrollView
{
    if (!_menuScrollView) {
        _menuScrollView = [ActionScrollView new];
        _menuScrollView.showsHorizontalScrollIndicator = NO;
        _menuScrollView.delaysContentTouches = NO;
        [_contentView addSubview:_menuScrollView];
    }
    return _menuScrollView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        _titleLabel.text = self.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        CGFloat labelWidth = _contentViewWidth - _contentMargin.left - _contentMargin.right;
        
        // 添加头部背景
        CALayer *headLayer = [CALayer layer];
        
        headLayer.frame = CGRectMake(0, 0, _contentViewWidth, _contentMargin.top * 2 + [_titleLabel sizeThatFits:CGSizeMake(labelWidth, CGFLOAT_MAX)].height);
        
        headLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        
        [self.textScrollView.layer addSublayer:headLayer];
        
        [self.textScrollView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)messageLbel
{
    if (!_messageLbel) {
        
        _messageLbel = [UILabel new];
        _messageLbel.numberOfLines = 0;
        _messageLbel.font = [UIFont systemFontOfSize:15];
        _messageLbel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        
        // 如果有需求定制再修改 @山竹
//        _messageLbel.text = self.message;
        
        // 初始化NSMutableAttributedString
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.message];
        
        // 段落样式
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        
        // 行间距
        paragraph.lineSpacing = 6.f;
        
        // 添加段落设置
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paragraph
                                 range:NSMakeRange(0, self.message.length)];
        
        _messageLbel.attributedText = attributedString;
        _messageLbel.textAlignment = self.messageAlignment;
        
        [self.textScrollView addSubview:_messageLbel];
    }
    
    return _messageLbel;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    
    _messageLbel.text = message;
}

- (void)setMessageAlignment:(NSTextAlignment)messageAlignment
{
    _messageAlignment = messageAlignment;
    
    _messageLbel.textAlignment = messageAlignment;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
