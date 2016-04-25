//
//  HQCustomAlertView.h
//  HunterQuiz
//
//  Created by test on 12/14/15.
//  Copyright © 2015 com.asgardgame. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZYLCustomInputView
@required
- (void)inputViewBecomeFirstResponder;
- (void)inputViewResignFirstResponder;
@end

typedef NS_ENUM(NSInteger, ZYLShowAlertStyle) {
    ZYLShowAlertFromBottom,
    ZYLShowAlertFromCenter,
    ZYLShowAlertFromCustom
};
@interface ZYLCustomAlertView : UIView
/**&lt; 展示View 只需设置size  */
@property(nonatomic, strong) UIView *contentView;
/**&lt; 带有InputView */
@property(nonatomic, strong) UIView<ZYLCustomInputView> *contentInputView;
/**&lt; 背景 defult [UIColor red:0 green:0 blue:0 alpha:0.5]; */
@property(nonatomic, strong) UIColor *alertBackgroundColor;
/**&lt; 展示的位置 defult ZYLShowAlertFromBottom*/
@property(nonatomic, assign) ZYLShowAlertStyle showStyle;
/**&lt; 点击其他区域是否隐藏 defult Yes */
@property(nonatomic, assign) BOOL entableTapDismiss;
/**&lt; 隐藏时的操作 */
@property(nonatomic, copy) void(^tapDismissHandle)(void);

//打开动画
@property(nonatomic, assign) BOOL entableAnimation;
/**&lt; 自动成为响应者 defult YES */
@property (nonatomic, assign) BOOL autoBecomeFirstResponder;

- (instancetype)initWithContentView:(UIView *)contentView;

- (instancetype)initWithContentInputView:(UIView<ZYLCustomInputView> *)contentView;

/**&lt; 使用默认方式展示一个自定义View */
+ (instancetype)addCustomView:(UIView *)view forPosition:(ZYLShowAlertStyle)position;

/**&lt; 使用默认方式展示一个自定义View */
+ (instancetype)addCustomView:(UIView *)view forPosition:(ZYLShowAlertStyle)position animaton:(BOOL)animaton;

/**&lt; 展示 */
- (void)show;

/**&lt; 隐藏 */
- (void)dismissSheetView;
@end
