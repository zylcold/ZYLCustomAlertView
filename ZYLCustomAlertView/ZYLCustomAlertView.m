//
//  ZYLCustomAlertView.m
//  HunterQuiz
//
//  Created by test on 12/14/15.
//  Copyright © 2015 com.asgardgame. All rights reserved.
//

#import "ZYLCustomAlertView.h"

#import "UIView+YLConstraintHelper.h"
#import "ZYLCustomCenterAnimation.m"

static NSString *const kFinishAnimationKey = @"ZYLCustomAlertToolsView.FinishAnimation";
@interface ZYLCustomAlertToolsView : UIView<UIGestureRecognizerDelegate>
@property(nonatomic, weak) UITapGestureRecognizer *tapGR;
@property(nonatomic, weak) UIPanGestureRecognizer *panGR;
@property(nonatomic, weak) UIView *backgroundView_p;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) UIView<ZYLCustomInputView> *contentInputView;
@property(nonatomic, strong) UIColor *alertBackgroundColor;
@property(nonatomic, assign) ZYLShowAlertStyle showStyle;
@property(nonatomic, assign) BOOL entableTapDismiss;
@property(nonatomic, copy) void(^tapDismissHandle)(void);
@property(nonatomic, assign) CGPoint offset;
@property(nonatomic, assign) BOOL entableAnimation;
@property(nonatomic, assign) BOOL autoBecomeFirstResponder;
@property(nonatomic, assign) BOOL entablePanGestureRecognizer;
@property(nonatomic, assign) BOOL panToDismiss;
@property(nonatomic, strong) UIView *contentView_p;
@property(nonatomic, strong) ZYLCustomAlertView *tools;
@property(nonatomic, assign) CGPoint transformBegan;
@property(nonatomic, assign, getter=isKeyboardShow) BOOL keyboardShow;

@property(nonatomic, assign) ZYLAlertCompass compass;

@property(nonatomic, strong) UIView *toAddView;

- (void)show;
- (void)dismissAlertView;
@end
@implementation ZYLCustomAlertToolsView

- (instancetype)initWithAddView:(UIView *)view
{
    if(self = [super initWithFrame:view.bounds]) {
        [self p_setupCustomViewWithAddView:view];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.contentView_p.layer removeAllAnimations];
}

- (void)p_setupCustomViewWithAddView:(UIView *)view
{
    if(view) {
        self.toAddView = view;
    }else {
        self.toAddView = [self keyWindow_p];
    }
    [self.toAddView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[self class]]) {
            [obj removeFromSuperview];
        }
    }];
    self.frame = CGRectMake(0, 0, self.toAddView.frame.size.width, self.toAddView.frame.size.height);
    self.backgroundColor = [UIColor clearColor];
    //背景View
    UIView *backgroundView = [[UIView alloc] init];
    [self addSubview:backgroundView];
    backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self yl_addEdgeConstrainToSubview:backgroundView inset:UIEdgeInsetsZero];
    
    backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView_p = backgroundView;
    
    
    //点击空白区域 ,消失弹框
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTodismissAlertView:)];
    [backgroundView addGestureRecognizer:tap];
    _tapGR = tap;
    
    self.keyboardShow = NO;
    self.panToDismiss = NO;
}


- (void)handldPanGRForNoShowCustom:(UIPanGestureRecognizer *)panGR
{
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:{
            _transformBegan =  [panGR translationInView: self.contentView_p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGPoint transformChanged =  [panGR translationInView: self.contentView_p];
            CGFloat transformY = transformChanged.y-_transformBegan.y >= 0 ? transformChanged.y-_transformBegan.y : 0;
            CGFloat screenHeight = CGRectGetHeight([self mainScreen]);
            CGFloat progressToDismiss = (screenHeight - CGRectGetMinY(self.contentView_p.frame)  + .5*CGRectGetHeight(self.contentView_p.frame)) / (screenHeight - ((CGRectGetMinY(self.contentView_p.frame))-transformY) + .5*CGRectGetHeight(self.contentView_p.frame));
            self.contentView_p.transform = CGAffineTransformMakeTranslation(0, transformY);
            [UIView animateWithDuration:0.15 animations:^{
                self.backgroundView_p.alpha = progressToDismiss;
            }];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            CGPoint transformChanged =  [panGR translationInView: self.contentView_p];
            if(transformChanged.y-_transformBegan.y > CGRectGetHeight(self.contentView_p.frame)*.3) {
                self.panToDismiss = YES;
                [self dismissAlertView];
            }else {
                [UIView animateWithDuration:0.15 animations:^{
                    self.contentView_p.transform = CGAffineTransformIdentity;
                    self.backgroundView_p.alpha = 1;
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
    
    //解决直接加载Xib时 View过大的问题
    if(CGRectGetWidth(self.contentView_p.frame) > CGRectGetWidth([self mainScreen])) {
        CGFloat screenWidth = CGRectGetWidth([self mainScreen]);
        UIView *contentView_addNib = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, CGRectGetHeight(self.contentView_p.frame) * (screenWidth / CGRectGetWidth(self.contentView_p.frame)))];
        [contentView_addNib addSubview:self.contentView_p];
        
        UIView *teamView = self.contentView_p;
        teamView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView_addNib yl_addEdgeConstrainToSubview:teamView inset:UIEdgeInsetsZero];
        
        self.contentView_p = contentView_addNib;
    }
    
    
    [self.toAddView addSubview:self];
    [self addSubview: self.contentView_p];
    
    UIView *contentView = self.contentView_p;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    switch (_showStyle) {
        case ZYLShowAlertFromBottom:{
            [self handldShowForBottomWithContentView:contentView];
            break;
        }
        case ZYLShowAlertFromCenter:{
            [self handldShowForCenterWithContentView:contentView];
            break;
        }
        case ZYLShowAlertFromCustom:{
            [self handldShowForCustomWithContentView:contentView];
            break;
        }
        case ZYLShowAlertFromTop:{
            [self handldShowForTopWithContentView:contentView];
            break;
        }
        default:
            break;
    }
}

- (void)handldShowForTopWithContentView:(UIView *)contentView
{
    self.backgroundView_p.userInteractionEnabled = self.entableTapDismiss;
    self.userInteractionEnabled = self.entableTapDismiss;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(-%f)-[contentView(%f)]", CGRectGetHeight(contentView.frame),CGRectGetHeight(contentView.frame) ] options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    
    [contentView yl_addOneselfConstrainToWidth:CGRectGetWidth(contentView.frame)];
    
    //X轴居中显示
    [self yl_addCenterXConstrainToSubview:contentView offset:0];
    
    //更新约束，确定原始位置
    [self updateConstraints];
    [self layoutIfNeeded];
    
    [self finderTopConstraintForView:contentView].constant = 0;
    //更新约束，添加动画
    [UIView animateWithDuration:0.25 animations:^{
        [self updateConstraints];
        [self layoutIfNeeded];
        _backgroundView_p.backgroundColor = self.alertBackgroundColor;
    }];
}


- (void)handldShowForBottomWithContentView:(UIView *)contentView
{
    self.backgroundView_p.userInteractionEnabled = YES;
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[contentView(%f)]-(-%f)-|", CGRectGetHeight(contentView.frame),CGRectGetHeight(contentView.frame) ] options:0 metrics:nil views:NSDictionaryOfVariableBindings(contentView)]];
    
    [contentView yl_addOneselfConstrainToWidth:CGRectGetWidth(contentView.frame)];
    [self yl_addCenterXConstrainToSubview:contentView offset:0];
    
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
    
}

- (void)handldShowForCenterWithContentView:(UIView *)contentView
{
    self.backgroundView_p.userInteractionEnabled = YES;
    [contentView yl_addOneselfConstrainToSize:contentView.frame.size];
    [self yl_addCenterConstrainToSubview:contentView offset:self.offset];
    
    if(self.entableAnimation) {
        [self.contentView_p.layer addAnimation:[self transfromAnimation] forKey:@"hhh"];
        [UIView animateWithDuration:0.25 animations:^{
            _backgroundView_p.backgroundColor = self.alertBackgroundColor;
        }];
    }else {
        _backgroundView_p.backgroundColor = self.alertBackgroundColor;
    }
}


- (void)handldShowForCustomWithContentView:(UIView *)contentView
{
    self.backgroundView_p.userInteractionEnabled = YES;
    CGFloat screenW = CGRectGetWidth([self mainScreen]);
    CGFloat contentViewX = CGRectGetMinX(contentView.frame);
    CGFloat contentViewY = CGRectGetMinY(contentView.frame);
    CGFloat contentViewH = CGRectGetHeight(contentView.frame);
    CGFloat contentViewW = CGRectGetWidth(contentView.frame);
    CGFloat contentMarginL = contentViewX;
    CGFloat contentMarginR = screenW-CGRectGetMaxX(contentView.frame);
    CGFloat contentMarginT = contentViewY;
    
    CGFloat viewX = 0;
    CGFloat viewY = 0;
    if(contentMarginT >= contentViewH) {  //上面
        if(contentMarginL >= contentViewW / 2  && contentMarginR >= -contentViewW*0.5) { //中间
            contentView.layer.anchorPoint = CGPointMake(0.5, 1);
            viewX = contentViewX - contentViewW * .5;
            viewY = contentViewY - contentViewH * .5;
            self.compass = ZYLAlertCompassForTop | ZYLAlertCompassForCenter;
        }else {
            if(contentMarginL < contentViewW / 2) { //右上
                contentView.layer.anchorPoint = CGPointMake(0, 1);
                viewX = contentViewX-contentViewW * .5;
                viewY = contentViewY-contentViewH * .5;
                self.compass = ZYLAlertCompassForRight | ZYLAlertCompassForTop;
            }else { //左上
                contentView.layer.anchorPoint = CGPointMake(1, 1);
                viewX = contentViewX-contentViewW*.5;
                viewY = contentViewY-contentViewH*.5;
                self.compass = ZYLAlertCompassForTop | ZYLAlertCompassForLeft;
            }
        }
    }else {
        if(contentMarginL >= contentViewW / 2  && contentMarginR >= -contentViewW*0.5) { //中间
            contentView.layer.anchorPoint = CGPointMake(0.5, 0);
            viewX = contentViewX-contentViewW*.5;
            viewY = contentViewY-contentViewH*.5;
            self.compass = ZYLAlertCompassForBottom | ZYLAlertCompassForCenter;
        }else {
            if(contentMarginL < contentViewW / 2) { //右下
                contentView.layer.anchorPoint = CGPointMake(0, 0);
                viewX = contentViewX-contentViewW*.5;
                viewY = contentViewY-contentViewH*.5;
                self.compass = ZYLAlertCompassForBottom | ZYLAlertCompassForRight;
            }else { //左下
                contentView.layer.anchorPoint = CGPointMake(1, 0);
                viewX = contentViewX-contentViewW*.5;
                viewY = contentViewY-contentViewH*.5;
                self.compass = ZYLAlertCompassForBottom | ZYLAlertCompassForLeft;
            }
        }
    }
    
    NSDictionary *metricsDict = @{@"width" : @(contentViewW), @"height" : @(contentViewH), @"viewX" : @(viewX), @"viewY" : @(viewY)};
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(contentView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(viewX)-[contentView(width)]" options:NSLayoutFormatAlignAllCenterY metrics:metricsDict views:viewDict]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(viewY)-[contentView(height)]" options:NSLayoutFormatAlignAllCenterX metrics:metricsDict views:viewDict]];
    
    if(self.entableAnimation) {
        [contentView.layer addAnimation:[self transfromAnimation] forKey:@"hhhh"];
        [UIView animateWithDuration:0.15 animations:^{
            _backgroundView_p.backgroundColor = self.alertBackgroundColor;
        }];
    }else {
        _backgroundView_p.backgroundColor = self.alertBackgroundColor;
    }
    
}





- (void)tapTodismissAlertView
{
    [self.tools dismissAlertView];
}

- (void)dismissAlertView
{
    void(^finishedHandld)(BOOL finished) = ^(BOOL finished){
        if(finished) {
            if(self.tapDismissHandle) { self.tapDismissHandle(); }
            self.tools = nil;
            [self.contentView_p removeFromSuperview];
            self.contentView_p = nil;
            self.contentView = nil;
            self.contentInputView = nil;
            [self removeFromSuperview];
        }
    };
    switch (_showStyle) {
        case ZYLShowAlertFromBottom:{
            [self handldDismissFromBottomWithFinish:finishedHandld];
            break;
        }
        case ZYLShowAlertFromCenter:{
            [self handldDismissFromCenterWithFinish:finishedHandld];
            break;
        }
        case ZYLShowAlertFromCustom:{
            [self handldDismissFromCustomWithFinish:finishedHandld];
            break;
        }
            
        case ZYLShowAlertFromTop:{
            [self handldDismissFromTopWithFinish:finishedHandld];
            break;
        }
            
    }
}

- (void)handldDismissFromTopWithFinish:(void(^)(BOOL))finishedHandld
{
    [self finderTopConstraintForView:self.contentView_p].constant = -CGRectGetHeight(self.contentView_p.frame);
    [UIView animateWithDuration:0.25 animations:^{
        [self updateConstraints];
        [self layoutIfNeeded];
        _backgroundView_p.backgroundColor = [UIColor clearColor];
    }completion:finishedHandld];
}

- (void)handldDismissFromCustomWithFinish:(void(^)(BOOL))finishedHandld
{
    if(self.entableAnimation) {
        [self.contentView_p.layer addAnimation:[self dismissTransfromAnimation] forKey:kFinishAnimationKey];
        [UIView animateWithDuration:0.25 animations:^{
            _backgroundView_p.backgroundColor = [UIColor clearColor];
        } completion:finishedHandld];
    }else {
        finishedHandld(YES);
    }
}

- (void)handldDismissFromCenterWithFinish:(void(^)(BOOL))finishedHandld
{
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

}

- (void)handldDismissFromBottomWithFinish:(void(^)(BOOL))finishedHandld
{
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
            [UIView animateWithDuration:0.3 animations:^{
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

- (void)showEditView:(UIView *)editView withHeight:(CGFloat)height
{
    [self finderBottomConstraintForView:editView].constant = height;
}

- (void)dismissEditView:(id)editView andHeight:(CGFloat)height
{
    [self finderBottomConstraintForView:editView].constant = -height;
}

- (NSLayoutConstraint *)finderTopConstraintForView:(UIView *)view
{
    __block NSLayoutConstraint *temConstraint = nil;
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.firstItem==view && obj.firstAttribute == NSLayoutAttributeTop) {
            temConstraint = obj;
            *stop = YES;
        }
    }];
    return temConstraint;
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


//MARK: 处理监听回调
//点击展示View之外区域操作
- (void)tapTodismissAlertView:(UITapGestureRecognizer *)tapGR
{
    if(!CGRectContainsPoint(self.contentView_p.frame, [tapGR locationInView:self])) {
        [self tapTodismissAlertView];
    }
}

- (void)panToSheetView:(UIPanGestureRecognizer *)panGR
{
    
    switch (self.showStyle) {
        case ZYLShowAlertFromBottom:
        case ZYLShowAlertFromCenter:
            [self handldPanGRForNoShowCustom:panGR];
            break;
        case ZYLShowAlertFromCustom:
            break;
        case ZYLShowAlertFromTop:
            break;
    }
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
        }
    }
    return NO;
}

- (void)handldNotification:(NSNotification *)notifacation
{
    NSDictionary *userInfo = notifacation.userInfo;
    CGRect beginR = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endR = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    if(beginR.origin.y == [UIScreen mainScreen].bounds.size.height) {
        self.keyboardShow = YES;
        [self showEditView:self.contentView_p withHeight:endR.size.height];
    }else if(endR.origin.y == [UIScreen mainScreen].bounds.size.height) {
        [self dismissEditView:self.contentView_p andHeight:CGRectGetHeight(self.contentView_p.frame)];
    }else {
        self.keyboardShow = YES;
        [self showEditView:self.contentView_p withHeight:endR.size.height];
    }
    
    void(^animations)() = ^{
        [self updateConstraints];
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}



//MARK: 获取
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

//获取展示区域的大小
- (CGRect)mainScreen
{
    return self.toAddView.bounds;
}


//MARK: 获取动画效果
- (CABasicAnimation *)dismissTransfromAnimation
{
    return [ZYLCustomCenterAnimation dismissCenterScaleAnimation];
}

- (CABasicAnimation *)dismissTransfromTranslateAnimation
{
    return [ZYLCustomCenterAnimation dismissCenterTransfromTranslateAnimationToValue:[self mainScreen].size.height-CGRectGetMinX(self.contentView_p.frame)];
}
- (CAAnimation *)transfromAnimation
{
    return [ZYLCustomCenterAnimation showCenterScaleAnimationWithSpring];
}

@end



@interface ZYLCustomAlertView()
@property(nonatomic, strong) ZYLCustomAlertToolsView *customAlertView;
@end

@implementation ZYLCustomAlertView
- (instancetype)initWithContentView:(UIView *)contentView
{
    return [self initWithContentView:contentView addedTo:nil];
}

- (instancetype)initWithContentView:(UIView *)contentView addedTo:(UIView *)view
{
    if(self = [super init]) {
        [self p_setUpWithAddView:view];
        self.customAlertView.contentView = contentView;
    }
    return self;
}

- (instancetype)initWithContentInputView:(UIView<ZYLCustomInputView> *)contentView
{
    if(self = [super init]) {
        [self p_setUpWithAddView:nil];
        self.customAlertView.contentInputView = contentView;
        
    }
    return self;
}

- (instancetype)init
{
    if(self = [super init]) {
        [self p_setUpWithAddView:nil];
    }
    return self;
}

- (void)p_setUpWithAddView:(UIView *)addView
{
    self.customAlertView = [[ZYLCustomAlertToolsView alloc] initWithAddView:addView];
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
    self.customAlertView.contentView = contentView;
}

- (UIView *)contentView
{
    return self.customAlertView.contentView;
}

- (void)setContentInputView:(UIView<ZYLCustomInputView> *)contentInputView
{
    self.customAlertView.contentInputView = contentInputView;
}

- (UIView<ZYLCustomInputView> *)contentInputView
{
    return self.customAlertView.contentInputView;
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

- (void)dismissAlertView
{
    [self.customAlertView dismissAlertView];
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

+ (instancetype)showCustomView:(UIView *)customView addedTo:(UIView *)view forPosition:(ZYLShowAlertStyle)position animaton:(BOOL)animaton
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] initWithContentView:view addedTo:view];
    alertView.showStyle = position;
    alertView.entableAnimation = animaton;
    return alertView;
}

- (void)dismissSheetView
{
    [self dismissAlertView];
}

@end
