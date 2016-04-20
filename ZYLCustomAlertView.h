//
//  HQCustomAlertView.h
//  HunterQuiz
//
//  Created by test on 12/14/15.
//  Copyright © 2015 com.asgardgame. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HQCustomInputView
@required
- (void)inputViewBecomeFirstResponder;
- (void)inputViewResignFirstResponder;
@end

typedef NS_ENUM(NSInteger, HQShowAlertStyle) {
    HQShowAlertFromBottom,
    HQShowAlertFromCenter,
    HQShowAlertFromCustom
};
@interface ZYLCustomAlertView : UIView
/**&lt; 展示View 只需设置size  */
@property(nonatomic, strong) UIView *contentView;
/**&lt; 带有InputView */
@property(nonatomic, strong) UIView<HQCustomInputView> *contentInputView;
/**&lt; 背景 defult [UIColor red:0 green:0 blue:0 alpha:0.5]; */
@property(nonatomic, strong) UIColor *alertBackgroundColor;
/**&lt; 展示的位置 */
@property(nonatomic, assign) HQShowAlertStyle showStyle;
/**&lt; 点击其他区域是否隐藏 defult Yes */
@property(nonatomic, assign) BOOL entableTapDismiss;
/**&lt; 隐藏时的操作 */
@property(nonatomic, copy) void(^tapDismissHandle)(void);

//打开动画
@property(nonatomic, assign) BOOL entableAnimation;
/**&lt; 自动成为响应者 defult YES */
@property (nonatomic, assign) BOOL autoBecomeFirstResponder;

/**&lt; 展示 */
- (void)show;

/**&lt; 隐藏 */
- (void)dismissSheetView;
@end
