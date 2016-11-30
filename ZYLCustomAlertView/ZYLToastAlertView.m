//
//  ZYLToastAlertView.m
//  Pods
//
//  Created by Relly on 21/11/2016.
//
//

#import "ZYLToastAlertView.h"
#import "ZYLCustomAlertView.h"
#import "UIView+YLConstraintHelper.h"
@implementation ZYLToastAlertView
+ (UIView *)toastViewWithAttr:(NSAttributedString *)attr andInsets:(UIEdgeInsets)insets
{
    UIView *bgView = [[UIView alloc] init];
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.attributedText = attr;
    [bgView addSubview:messageLabel];
    bgView.backgroundColor = [UIColor whiteColor];
    messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [bgView yl_addEdgeConstrainToSubview:messageLabel inset:insets];
    CGSize messageSize = [attr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - insets.left - insets.right, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    bgView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, messageSize.height + insets.top + insets.bottom);
    
    return bgView;
}

+ (void)topToastMessage:(NSString *)message
{
    NSAttributedString *messageAttr = [[NSAttributedString alloc] initWithString:message attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [self topToastMessageAttr:messageAttr inset:UIEdgeInsetsMake(30, 10, 10, 10)];
}

+ (void)topToastMessageAttr:(NSAttributedString *)message
{
    [self topToastMessageAttr:message inset:UIEdgeInsetsMake(30, 10, 10, 10)];
}


+ (void)topToastMessageAttr:(NSAttributedString *)message inset:(UIEdgeInsets)inset
{
    NSAttributedString *messageAttr = message;
    UIView *toastView = [self toastViewWithAttr:messageAttr andInsets:inset];
    
    ZYLCustomAlertView *topTools = [ZYLCustomAlertView addCustomView:toastView forPosition:ZYLShowAlertFromTop];
    topTools.backgroundColor = [UIColor clearColor];
    topTools.entableTapDismiss = NO;
    [topTools show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [topTools dismissAlertView];
    });

}
@end
