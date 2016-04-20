//
//  HQCustomAlertView.m
//  HunterQuiz
//
//  Created by test on 12/14/15.
//  Copyright © 2015 com.asgardgame. All rights reserved.
//

#import "ZYLCustomAlertView.h"
static NSString *const kFinishAnimationKey = @"HQCustomAlertView.FinishAnimation";
@interface ZYLCustomAlertView()
//点击手势
@property(nonatomic, weak) UITapGestureRecognizer *tapGR;
//显示View
@property(nonatomic, strong) UIView *contentView_p;
//背景View
@property(nonatomic, weak) UIView *backgroundView_p;
@end
@implementation ZYLCustomAlertView

- (instancetype)init
{
    if(self = [super init]) {
        UIWindow *keyWindow = [self keyWindow_p];
        [keyWindow.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[self class]]) {
                [obj removeFromSuperview];
            }
        }];
        self.frame = CGRectMake(0, 0, keyWindow.frame.size.width, keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        //背景View
        UIView *backgroundView = [[UIView alloc] init];
        [self addSubview:backgroundView];
        backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backgroundView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(backgroundView)]];
        backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView_p = backgroundView;
        
        
        //点击空白区域 ,消失弹框
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismissSheetView:)];
        [backgroundView addGestureRecognizer:tap];
        _tapGR = tap;
        
        
        //设置默认属性
        self.alertBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.entableAnimation = YES;
        self.entableTapDismiss = YES;
        self.autoBecomeFirstResponder = YES;
    }
    return self;
}



//获取App KeyWindow
- (UIWindow *)keyWindow_p
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
        if([[UIApplication sharedApplication].delegate window].keyWindow) {
            keyWindow = [[UIApplication sharedApplication].delegate window];
        }
    }
    return keyWindow;
}

//点击展示View之外区域操作
- (void)tapToDismissSheetView:(UITapGestureRecognizer *)tapGR
{
    if(!CGRectContainsPoint(self.contentView_p.frame, [tapGR locationInView:self])) {
        [self dismissSheetView];
    }
}

- (void)setEntableTapDismiss:(BOOL)entableTapDismiss
{
    _entableTapDismiss = entableTapDismiss;
    self.tapGR.enabled = entableTapDismiss;
}

- (void)show
{
    NSAssert(self.contentView_p, @"must have contentView");
    NSAssert(self.contentView_p.frame.size.width || self.contentView_p.frame.size.height, @"must have size");
    
    //解决Xib View过大的问题
    if(CGRectGetWidth(self.contentView_p.frame) > CGRectGetWidth([UIScreen mainScreen].bounds)) {
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        UIView *contentView_addNib = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(self.contentView_p.frame) * (screenWidth /CGRectGetWidth(self.contentView_p.frame)))];
        [contentView_addNib addSubview:self.contentView_p];
        
        UIView *teamView = self.contentView_p;
        teamView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView_addNib addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[teamView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(teamView)]];
        [contentView_addNib addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[teamView]|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(teamView)]];
        self.contentView_p = contentView_addNib;
    }
    
    
    UIWindow *keyWindow = [self keyWindow_p];
    [keyWindow addSubview:self];
    [self addSubview: self.contentView_p];
    
    UIView *contentView = self.contentView_p;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    switch (_showStyle) {
        case HQShowAlertFromBottom:{
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[contentView(%f)]-(-%f)-|", CGRectGetHeight(contentView.frame),CGRectGetHeight(contentView.frame) ] options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[contentView(%f)]", CGRectGetWidth(contentView.frame)] options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
            
            //X轴居中显示
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[contentView(height)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : @(CGRectGetHeight(contentView.frame))} views:@{@"superview" : self, @"contentView" : contentView}]];
            
            //更新约束，确定原始位置
            [self updateConstraints];
            [self layoutIfNeeded];
            
            
            if(self.contentView) {
                [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(obj.firstItem == self && obj.firstAttribute == NSLayoutAttributeBottom && obj.secondItem == contentView) {
                        obj.constant = 0;
                        *stop = YES;
                    }
                }];
                
                //更新约束，添加动画
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateConstraints];
                    [self layoutIfNeeded];
                    _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                }];
            }else if(self.contentInputView){
                
                UIView<HQCustomInputView> *inputContentView = (UIView<HQCustomInputView> *)self.contentView_p;
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handldNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
                
                if(self.autoBecomeFirstResponder) {
                    [inputContentView inputViewBecomeFirstResponder];
                }else {
                    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if(obj.firstItem == self && obj.firstAttribute == NSLayoutAttributeBottom && obj.secondItem == contentView) {
                            obj.constant = 0;
                            *stop = YES;
                        }
                    }];
                    
                    //更新约束，添加动画
                    [UIView animateWithDuration:0.25 animations:^{
                        [self updateConstraints];
                        [self layoutIfNeeded];
                        _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                    }];
                }
                [UIView animateWithDuration:0.25 animations:^{
                    _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                }];
                
            }
            break;
        }
            
        case HQShowAlertFromCenter:{
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superview]-(<=1)-[contentView(width)]" options:NSLayoutFormatAlignAllCenterY metrics:@{@"width" : @(CGRectGetWidth(contentView.frame))} views:@{@"superview" : self, @"contentView" : contentView}]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[contentView(height)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : @(CGRectGetHeight(contentView.frame))} views:@{@"superview" : self, @"contentView" : contentView}]];
            

            if(self.entableAnimation) {
                [self.contentView_p.layer addAnimation:[self transfromAnimation] forKey:@"hhh"];
                [UIView animateWithDuration:0.25 animations:^{
                    _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                }];
            }else {
                _backgroundView_p.backgroundColor = self.alertBackgroundColor;
            }

            
            break;
        }
        default:
            break;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handldNotification:(NSNotification *)notifacation
{
    NSDictionary *userInfo = notifacation.userInfo;
    CGRect beginR = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endR = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat heightKeyboard = beginR.origin.y-endR.origin.y;
    
    if(heightKeyboard > -100) {  //弹出
        [self showOrHideEditView:self.contentView_p WithShow:YES andHeight:heightKeyboard];
    }else {
        [self showOrHideEditView:self.contentView_p WithShow:NO andHeight:heightKeyboard];
    }
    
    void(^animations)() = ^{
        [self updateConstraints];
        [self layoutIfNeeded];
    };
    
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}


- (void)dismissSheetView
{
    switch (_showStyle) {
        case HQShowAlertFromBottom:{
            
            if(self.contentView) {
                [self updateConstraints];
                [self layoutIfNeeded];
                
                
                [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   if(obj.firstItem == self && obj.firstAttribute == NSLayoutAttributeBottom && obj.secondItem == self.contentView_p) {
                       obj.constant = -CGRectGetHeight(self.contentView_p.frame);
                       *stop = YES;
                   }
                }];
                
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateConstraints];
                    [self layoutIfNeeded];
                    _backgroundView_p.backgroundColor = [UIColor clearColor];
                }completion:^(BOOL finished) {
                    if(finished) {
                        if(self.tapDismissHandle) { self.tapDismissHandle(); }
                        [self removeFromSuperview];
                    }
                }];
            }else if(self.contentInputView) {
                [self.contentInputView inputViewResignFirstResponder];
                [UIView animateWithDuration:0.25 animations:^{
                    _backgroundView_p.backgroundColor = [UIColor clearColor];
                }completion:^(BOOL finished) {
                    if(finished) {
                        if(self.tapDismissHandle) { self.tapDismissHandle(); }
                        [self removeFromSuperview];
                    }
                }];
            }
            
            break;
        }
        case HQShowAlertFromCenter:{
            if(self.entableAnimation) {
                [self.contentView_p.layer addAnimation:[self dismissTransfromAnimation] forKey:kFinishAnimationKey];
                [UIView animateWithDuration:0.15 animations:^{
                    _backgroundView_p.backgroundColor = [UIColor clearColor];
                } completion:^(BOOL finished) {
                    if(self.tapDismissHandle) { self.tapDismissHandle(); }
                    [self removeFromSuperview];
                }];
            }else {
                [self removeFromSuperview];
            }
            
            break;
        }
        default:
            break;
    }
    
    
}

- (CABasicAnimation *)dismissTransfromAnimation
{
    CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fooAnimation.fromValue = @(1);
    fooAnimation.duration = 0.15;
    fooAnimation.toValue = @(0);
    fooAnimation.fillMode = kCAFillModeForwards;
    fooAnimation.removedOnCompletion = NO;
    return fooAnimation;
}

- (CABasicAnimation *)transfromAnimation
{
    CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fooAnimation.fromValue = @(0);
    fooAnimation.duration = 0.15;
    fooAnimation.toValue = @(1);
    return fooAnimation;
}


- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    _contentView_p = contentView;
}


- (void)setContentInputView:(UIView<HQCustomInputView> *)contentInputView
{
    _contentInputView = contentInputView;
    _contentView_p = contentInputView;
}

- (void)showOrHideEditView:(id)editView WithShow:(BOOL)show andHeight:(CGFloat)height
{
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.firstItem==self && obj.secondItem == editView && obj.firstAttribute == NSLayoutAttributeBottom) {
            if(show) {
                if(ABS(height) < 100) {
                    obj.constant += height;
                }else {
                    obj.constant = ABS(height);
                }
            }else {
                obj.constant = -150;
            }
            
            *stop = YES;
        }
    }];
    
}


@end
