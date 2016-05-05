//
//  ZYLCustomAlertView.m
//  HunterQuiz
//
//  Created by test on 12/14/15.
//  Copyright © 2015 com.asgardgame. All rights reserved.
//

#import "ZYLCustomAlertView.h"
static NSString *const kFinishAnimationKey = @"ZYLCustomAlertToolsView.FinishAnimation";
@interface ZYLCustomAlertToolsView : UIView<UIGestureRecognizerDelegate>
@property(nonatomic, assign) CGPoint transformBegan;
@property(nonatomic, strong) ZYLCustomAlertToolsView *tools;
@property(nonatomic, weak) UITapGestureRecognizer *tapGR;
@property(nonatomic, weak) UIPanGestureRecognizer *panGR;
@property(nonatomic, strong) UIView *contentView_p;
@property(nonatomic, weak) UIView *backgroundView_p;
//@property(nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic, assign) BOOL panToDismiss;
@property (nonatomic, assign, getter=isKeyboardShow) BOOL keyboardShow;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView<ZYLCustomInputView> *contentInputView;
@property(nonatomic, strong) UIColor *alertBackgroundColor;
@property(nonatomic, assign) ZYLShowAlertStyle showStyle;
@property(nonatomic, assign) BOOL entableTapDismiss;
@property(nonatomic, copy) void(^tapDismissHandle)(void);
@property(nonatomic, assign) CGPoint offset;
@property(nonatomic, assign) BOOL entableAnimation;
@property (nonatomic, assign) BOOL autoBecomeFirstResponder;
@property(nonatomic, assign) BOOL entablePanGestureRecognizer;
- (void)show;
- (void)dismissSheetView;
@end
@implementation ZYLCustomAlertToolsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self p_setupCustomView];
    }
    return self;
}

- (void)p_setupCustomView
{
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
    
    self.keyboardShow = NO;
    self.panToDismiss = NO;
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

- (void)panToSheetView:(UIPanGestureRecognizer *)panGR
{

    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:{
            _transformBegan =  [panGR translationInView: self.contentView_p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint transformChanged =  [panGR translationInView: self.contentView_p];
            self.contentView_p.transform = CGAffineTransformMakeTranslation(0, transformChanged.y-_transformBegan.y >= 0 ? transformChanged.y-_transformBegan.y : 0);
            break;
        }
        case UIGestureRecognizerStateEnded:{
            CGPoint transformChanged =  [panGR translationInView: self.contentView_p];
            if(transformChanged.y-_transformBegan.y > CGRectGetHeight(self.contentView_p.frame)*.3) {
                self.panToDismiss = YES;
                [self dismissSheetView];
            }else {
                [UIView animateWithDuration:0.15 animations:^{
                    self.contentView_p.transform = CGAffineTransformIdentity;
                }];
            }
            _transformBegan =  CGPointZero;
            break;
        }
        default:{
            [UIView animateWithDuration:0.15 animations:^{
                self.contentView_p.transform = CGAffineTransformIdentity;
            }];
            break;
        }
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
    
    if(!self.panGR) {
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panToSheetView:)];
        [self.contentView_p addGestureRecognizer:panGR];
        panGR.delegate = self;
        self.panGR = panGR;
    }
    self.panGR.enabled = self.entablePanGestureRecognizer && self.entableAnimation && self.contentInputView == nil;
    
    
//    [self.contentView_p.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if([obj isKindOfClass:[UIScrollView class]]) {
//            self.scrollView = obj;
////            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//            *stop = YES;
//        }
//    }];
    
    //解决直接加载Xib时 View过大的问题
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
        case ZYLShowAlertFromBottom:{
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[contentView(%f)]-(-%f)-|", CGRectGetHeight(contentView.frame),CGRectGetHeight(contentView.frame) ] options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[contentView(%f)]", CGRectGetWidth(contentView.frame)] options:NSLayoutFormatAlignAllCenterX metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
            
            //X轴居中显示
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superview]-(<=1)-[contentView(height)]" options:NSLayoutFormatAlignAllCenterX metrics:@{@"height" : @(CGRectGetHeight(contentView.frame))} views:@{@"superview" : self, @"contentView" : contentView}]];
            
            //更新约束，确定原始位置
            [self updateConstraints];
            [self layoutIfNeeded];
            
            
            if(self.contentView) {
                [self finderBottomConstraintForView:contentView].constant = 0;
                //更新约束，添加动画
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateConstraints];
                    [self layoutIfNeeded];
                    _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                }];
            }else if(self.contentInputView){
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handldNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
                
                if(self.autoBecomeFirstResponder) {
                    [self.contentInputView inputViewBecomeFirstResponder];
                    [UIView animateWithDuration:0.25 animations:^{
                        _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                    }];
                }else {
                    [self finderBottomConstraintForView:contentView].constant = 0;
                    //更新约束，添加动画
                    [UIView animateWithDuration:0.25 animations:^{
                        [self updateConstraints];
                        [self layoutIfNeeded];
                        _backgroundView_p.backgroundColor = self.alertBackgroundColor;
                    }];
                }
                
                
            }
            break;
        }
            
        case ZYLShowAlertFromCenter:{
            
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
        [self dismissEditView:self.contentView_p andHeight:CGRectGetHeight(self.contentView_p.frame)];
    }
    void(^animations)() = ^{
        [self updateConstraints];
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}


- (void)dismissSheetView
{
    void(^finishedHandld)(BOOL finished) = ^(BOOL finished){
        if(finished) {
            if(self.tapDismissHandle) { self.tapDismissHandle(); }
            self.tools = nil;
            [self removeFromSuperview];

        }
    };
    switch (_showStyle) {
        case ZYLShowAlertFromBottom:{
            if(self.contentView) {
                [self finderBottomConstraintForView:self.contentView_p].constant = -CGRectGetHeight(self.contentView_p.frame);
                [UIView animateWithDuration:0.25 animations:^{
                    [self updateConstraints];
                    [self layoutIfNeeded];
                    _backgroundView_p.backgroundColor = [UIColor clearColor];
                }completion:finishedHandld];
            }else if(self.contentInputView) {
                if(self.isKeyboardShow) {
                    [self.contentInputView inputViewResignFirstResponder];
                    [UIView animateWithDuration:0.25 animations:^{
                        _backgroundView_p.backgroundColor = [UIColor clearColor];
                    }completion:finishedHandld];
                }else {
                    [self finderBottomConstraintForView:self.contentView_p].constant = -CGRectGetHeight(self.contentView_p.frame);
                    [UIView animateWithDuration:0.25 animations:^{
                        [self updateConstraints];
                        [self layoutIfNeeded];
                        _backgroundView_p.backgroundColor = [UIColor clearColor];
                    }completion:finishedHandld];
                }
            }
            
            break;
        }
        case ZYLShowAlertFromCenter:{
            if(self.entableAnimation) {
                
                if(self.panToDismiss) {
                    [self.contentView_p.layer addAnimation:[self dismissTransfromTranslateAnimation] forKey:kFinishAnimationKey];
                    [UIView animateWithDuration:0.25 animations:^{
                        self.backgroundView_p.backgroundColor = [UIColor clearColor];
                    } completion:finishedHandld];
                }else {
                    [self.contentView_p.layer addAnimation:[self dismissTransfromAnimation] forKey:kFinishAnimationKey];
                    [UIView animateWithDuration:0.15 animations:^{
                        _backgroundView_p.backgroundColor = [UIColor clearColor];
                    } completion:finishedHandld];
                }
                
            }else {
                finishedHandld(YES);
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
    fooAnimation.duration = 0.1;
    fooAnimation.toValue = @(0);
    fooAnimation.fillMode = kCAFillModeForwards;
    fooAnimation.removedOnCompletion = NO;
    return fooAnimation;
}

- (CABasicAnimation *)dismissTransfromTranslateAnimation
{
    CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    fooAnimation.duration = 0.25;
    fooAnimation.toValue = @([UIScreen mainScreen].bounds.size.height-CGRectGetMinX(self.contentView_p.frame));
    fooAnimation.fillMode = kCAFillModeForwards;
    fooAnimation.removedOnCompletion = NO;
    return fooAnimation;
}
- (CAAnimation *)transfromAnimation
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
        spring.damping = 15;
        spring.stiffness = 100;
        spring.mass = 1.1;
        spring.initialVelocity = 10;
        spring.fromValue = @(0);
        spring.toValue = @(1);
        spring.duration = spring.settlingDuration;
        return spring;
    }else {
        CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        fooAnimation.fromValue = @(0);
        fooAnimation.duration = 0.1;
        fooAnimation.toValue = @(1);
        fooAnimation.fillMode = kCAFillModeForwards;
        fooAnimation.removedOnCompletion = NO;
        return fooAnimation;
    }
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    _contentView_p = contentView;
}

- (void)setContentInputView:(UIView<ZYLCustomInputView> *)contentInputView
{
    _contentInputView = contentInputView;
    _contentView_p = contentInputView;
}

- (void)showOrHideEditView:(id)editView WithShow:(BOOL)show andHeight:(CGFloat)height
{
    self.keyboardShow = show;
    
    if(show) {
        if(ABS(height) < 100) {
            [self finderBottomConstraintForView:editView].constant += height;
        }else {
            [self finderBottomConstraintForView:editView].constant = ABS(height);
        }
    }else {
        [self finderBottomConstraintForView:editView].constant = 0;
    }
}

- (void)dismissEditView:(id)editView andHeight:(CGFloat)height
{
    [self finderBottomConstraintForView:editView].constant = -height;
}

- (NSLayoutConstraint *)finderBottomConstraintForView:(UIView *)view
{
    __block NSLayoutConstraint *temConstraint = nil;
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.firstItem==self && obj.secondItem == view && obj.firstAttribute == NSLayoutAttributeBottom) {
            temConstraint = obj;
            *stop = YES;
        }
    }];
    return temConstraint;
}

//同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (self.panGR == gestureRecognizer) {
        if ([otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scrollView = (UIScrollView *)otherGestureRecognizer.view;
            if (scrollView.contentOffset.y == 0) {
                scrollView.bounces = NO;
                return YES;
            }else {
                scrollView.bounces = YES;
                return NO;
            }
            
//            [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@", change);
}

@end



@interface ZYLCustomAlertView()
@property(nonatomic, strong) ZYLCustomAlertToolsView *customAlertView;
@end

@implementation ZYLCustomAlertView
- (instancetype)initWithContentView:(UIView *)contentView
{
    if(self = [super init]) {
        [self p_setUp];
        self.customAlertView.contentView = contentView;
    }
    return self;
}

- (instancetype)initWithContentInputView:(UIView<ZYLCustomInputView> *)contentView
{
    if(self = [super init]) {
        [self p_setUp];
        self.customAlertView.contentInputView = contentView;
        
    }
    return self;
}

- (instancetype)init
{
    if(self = [super init]) {
        [self p_setUp];
    }
    return self;
}

- (void)p_setUp
{
    self.customAlertView = [[ZYLCustomAlertToolsView alloc] init];
    self.customAlertView.tools = self;
    //设置默认属性
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.entableAnimation = YES;
    self.entableTapDismiss = YES;
    self.autoBecomeFirstResponder = YES;
    self.showStyle = ZYLShowAlertFromBottom;
    self.entablePanGestureRecognizer = NO;
    self.backgroundView = self.customAlertView.backgroundView_p;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.customAlertView.alertBackgroundColor = backgroundColor;
}

- (void)setShowStyle:(ZYLShowAlertStyle)showStyle
{
    _showStyle = showStyle;
    self.customAlertView.showStyle = showStyle;
}

- (void)setEntableAnimation:(BOOL)entableAnimation
{
    _entableAnimation = entableAnimation;
    self.customAlertView.entableAnimation = entableAnimation;
}

- (void)setEntableTapDismiss:(BOOL)entableTapDismiss
{
    _entableTapDismiss = entableTapDismiss;
    self.customAlertView.entableTapDismiss = entableTapDismiss;
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    self.customAlertView.contentView = contentView;
}

- (void)setContentInputView:(UIView<ZYLCustomInputView> *)contentInputView
{
    _contentInputView = contentInputView;
    self.customAlertView.contentInputView = contentInputView;
}

- (void)setTapDismissHandle:(void (^)(void))tapDismissHandle
{
    _tapDismissHandle = tapDismissHandle;
    self.customAlertView.tapDismissHandle = tapDismissHandle;
}

- (void)setEntablePanGestureRecognizer:(BOOL)entablePanGestureRecognizer
{
    _entablePanGestureRecognizer = entablePanGestureRecognizer;
    self.customAlertView.entablePanGestureRecognizer = entablePanGestureRecognizer;
}

- (void)setAutoBecomeFirstResponder:(BOOL)autoBecomeFirstResponder
{
    _autoBecomeFirstResponder = autoBecomeFirstResponder;
    self.customAlertView.autoBecomeFirstResponder = autoBecomeFirstResponder;
}

- (void)setOffset:(CGPoint)offset
{
    _offset = offset;
    self.customAlertView.offset = offset;
}

- (void)show
{
    [self.customAlertView show];
}

- (void)dismissSheetView
{
    [self.customAlertView dismissSheetView];
    self.customAlertView = nil;
}

+ (instancetype)addCustomView:(UIView *)view forPosition:(ZYLShowAlertStyle)position
{
    return [ZYLCustomAlertView addCustomView:view forPosition:position animaton:YES];
}

+ (instancetype)addCustomView:(UIView *)view forPosition:(ZYLShowAlertStyle)position animaton:(BOOL)animaton
{
    
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] initWithContentView:view];
    alertView.showStyle = position;
    alertView.entableAnimation = animaton;
    return alertView;
}


@end

