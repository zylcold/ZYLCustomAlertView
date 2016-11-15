//
//  ZYLCustomAlertView.h
//  HunterQuiz
//
//  Created by test on 12/14/15.
//  Copyright © 2015 com.asgardgame. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYLCustomInputView<NSObject>
@required
- (void)inputViewBecomeFirstResponder;
- (void)inputViewResignFirstResponder;
@end

//展示位置
typedef NS_ENUM(NSInteger, ZYLShowAlertStyle) {
    ZYLShowAlertFromBottom,
    ZYLShowAlertFromCenter,
    ZYLShowAlertFromCustom,
    ZYLShowAlertFromTop
};

//展示方向
typedef NS_OPTIONS(NSUInteger, ZYLAlertCompass) {
    ZYLAlertCompassForTop = 1 << 1,
    ZYLAlertCompassForBottom = 1 << 2,
    ZYLAlertCompassForLeft = 1 << 3,
    ZYLAlertCompassForRight = 1 << 4,
    ZYLAlertCompassForCenter = 1 << 5
};


@interface ZYLCustomAlertView : NSObject

/**&lt; 展示View 只需设置size  */
@property(nonatomic, strong) UIView *contentView;
/**&lt; 带有InputView */
@property(nonatomic, strong) UIView<ZYLCustomInputView> *contentInputView;
/**&lt; 展示的位置 defult ZYLShowAlertFromBottom*/
@property(nonatomic, assign) ZYLShowAlertStyle showStyle;
/**&lt; 打开拖拽手势 defult NO */
@property(nonatomic, assign) BOOL entablePanGestureRecognizer;
/**&lt; 偏移量 */
@property(nonatomic, assign) CGPoint offset; //ZYLShowAlertFromCenter only

/**&lt; 背景 defult [UIColor red:0 green:0 blue:0 alpha:0.5]; */
@property(nonatomic, strong) UIColor *backgroundColor;
/**&lt; 点击其他区域是否隐藏 defult Yes */
@property(nonatomic, assign) BOOL entableTapDismiss;
/**&lt; 背景 */
@property(nonatomic, weak) UIView *backgroundView;
/**&lt; 自动成为响应者 defult YES */
@property (nonatomic, assign) BOOL autoBecomeFirstResponder;
/**&lt; 打开动画 defult YES*/
@property(nonatomic, assign) BOOL entableAnimation;

/**&lt; 隐藏时的操作 */
@property(nonatomic, copy) void(^tapDismissHandle)(void);

- (instancetype)initWithContentView:(UIView *)contentView;

- (instancetype)initWithContentView:(UIView *)contentView addedTo:(UIView *)view;

- (instancetype)initWithContentInputView:(UIView<ZYLCustomInputView> *)contentView;

/**&lt; 使用默认方式展示一个自定义View */
+ (instancetype)addCustomView:(UIView *)view forPosition:(ZYLShowAlertStyle)position;
/**&lt; 使用默认方式展示一个自定义View */
+ (instancetype)addCustomView:(UIView *)view forPosition:(ZYLShowAlertStyle)position animaton:(BOOL)animaton;

/**&lt; 使用默认方式展示一个自定义View */
+ (instancetype)showCustomView:(UIView *)customView addedTo:(UIView *)view forPosition:(ZYLShowAlertStyle)position animaton:(BOOL)animaton;


/**&lt; 展示 */
- (void)show;

/**&lt; 隐藏 */
- (void)dismissAlertView;



@end



