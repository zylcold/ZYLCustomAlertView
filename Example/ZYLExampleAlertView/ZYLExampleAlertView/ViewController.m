//
//  ViewController.m
//  ZYLExampleAlertView
//
//  Created by Yun on 4/21/16.
//  Copyright © 2016 com.ZhuYunLong. All rights reserved.
//

#import "ViewController.h"
#import <ZYLCustomAlertView/ZYLCustomAlertView.h>
@interface ZYLDemoInputView : UIView<ZYLCustomInputView>
@property(nonatomic, strong) UITextView *textView;
- (void)inputViewBecomeFirstResponder;
- (void)inputViewResignFirstResponder;
@end

@implementation ZYLDemoInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor purpleColor];
        UITextView *textView = [[UITextView alloc] init];
        [self addSubview:textView];
        
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
        
        _textView = textView;
    }
    return self;
}

- (void)inputViewBecomeFirstResponder
{
    [_textView becomeFirstResponder];
}

- (void)inputViewResignFirstResponder
{
    [_textView resignFirstResponder];
}

@end

@interface ViewController ()<UITableViewDataSource>
@property(nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self aCustomButtonWithTitle:@"底部展示" andFrame:CGRectMake(100, 100, 200, 30)] addTarget:self action:@selector(buttonOnClickToAlertBottom:) forControlEvents:UIControlEventTouchUpInside];
    [[self aCustomButtonWithTitle:@"中间展示" andFrame:CGRectMake(100, 140, 200, 30)] addTarget:self action:@selector(buttonOnClickToAlertCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self aCustomButtonWithTitle:@"顶部展示" andFrame:CGRectMake(100, 340, 200, 30)] addTarget:self action:@selector(buttonOnClickToAlertTop:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self aCustomButtonWithTitle:@"中间展示（无动画）" andFrame:CGRectMake(100, 180, 260, 30)] addTarget:self action:@selector(buttonOnClickToAlertCenterNoAnim) forControlEvents:UIControlEventTouchUpInside];
    
    [[self aCustomButtonWithTitle:@"底部展示InputView" andFrame:CGRectMake(100, 240, 200, 30)] addTarget:self action:@selector(buttonOnClickToAlertInputBottom:) forControlEvents:UIControlEventTouchUpInside];
    [[self aCustomButtonWithTitle:@"底部展示InputView2" andFrame:CGRectMake(100, 300, 200, 30)] addTarget:self action:@selector(buttonOnClickToAlertInput2Bottom:) forControlEvents:UIControlEventTouchUpInside];
    
    self.datas = @[@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
    
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewToAlert:)];
    [self.view addGestureRecognizer:tapGR];

}

- (void)tapViewToAlert:(UITapGestureRecognizer *)tapGR
{
    CGPoint point = [tapGR locationInView:self.view];
    UIView *customView = [self aCustomView];
    customView.frame = (CGRect) {
        .size = customView.frame.size,
        .origin = point
    };
    ZYLCustomAlertView *alertView = [ZYLCustomAlertView addCustomView:customView forPosition:ZYLShowAlertFromCustom];
    alertView.entablePanGestureRecognizer = YES;
    [alertView show];
    
}

- (void)buttonOnClickToAlertInputBottom:(id)sender
{
    ZYLDemoInputView *inputView = [[ZYLDemoInputView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] initWithContentInputView:inputView];
    [alertView show];
}

- (void)buttonOnClickToAlertInput2Bottom:(id)sender
{
    ZYLDemoInputView *inputView = [[ZYLDemoInputView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] initWithContentInputView:inputView];
    alertView.autoBecomeFirstResponder = NO;
    [alertView show];
}


- (void)buttonOnClickToAlertBottom:(id)sender
{
    ZYLCustomAlertView *alertView = [ZYLCustomAlertView addCustomView:[self aCustomView] forPosition:ZYLShowAlertFromBottom];
    alertView.entablePanGestureRecognizer = YES;
    [alertView show];
}
- (void)buttonOnClickToAlertCenterNoAnim
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] init];
    alertView.contentView = [self aCustomView];
    alertView.showStyle = ZYLShowAlertFromCenter;
    alertView.entableAnimation = NO;

    [alertView show];
    
//    [ZYLCustomAlertView addCustomView:[self aCustomView] forPosition:ZYLShowAlertFromCenter animaton:NO];
}

- (void)buttonOnClickToAlertTop:(id)sender
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] init];
    alertView.contentView = [self aCustomView];
    alertView.offset = CGPointMake(0, 50);
    alertView.showStyle = ZYLShowAlertFromTop;
    alertView.entablePanGestureRecognizer = YES;
    [alertView show];
}

- (void)buttonOnClickToAlertCenter:(id)sender
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] init];
    alertView.contentView = [self aCustomView];
    alertView.offset = CGPointMake(0, 50);
    alertView.showStyle = ZYLShowAlertFromCenter;
    alertView.entablePanGestureRecognizer = YES;
    [alertView show];
}


- (UIButton *)aCustomButtonWithTitle:(NSString *)title andFrame:(CGRect)frame
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor blueColor];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.frame = frame;
    [self.view addSubview:button1];
    return button1;
}

- (UIView *)aCustomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
//    UITableView *tableView = [[UITableView alloc] initWithFrame:view.bounds];
//    [view addSubview:tableView];
//    tableView.dataSource = self;
//    tableView.rowHeight = 44;
    view.backgroundColor = [UIColor blueColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"hhhhh";
    
    return cell;
}

@end

