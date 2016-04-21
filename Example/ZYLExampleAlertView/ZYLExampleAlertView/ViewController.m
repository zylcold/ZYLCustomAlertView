//
//  ViewController.m
//  ZYLExampleAlertView
//
//  Created by Yun on 4/21/16.
//  Copyright © 2016 com.ZhuYunLong. All rights reserved.
//

#import "ViewController.h"
#import <ZYLCustomAlertView/ZYLCustomAlertView.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self aCustomButtonWithTitle:@"底部展示" andFrame:CGRectMake(100, 100, 100, 30)] addTarget:self action:@selector(buttonOnClickToAlertBottom:) forControlEvents:UIControlEventTouchUpInside];
    [[self aCustomButtonWithTitle:@"中间展示" andFrame:CGRectMake(100, 140, 100, 30)] addTarget:self action:@selector(buttonOnClickToAlertCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self aCustomButtonWithTitle:@"中间展示（无动画）" andFrame:CGRectMake(100, 180, 160, 30)] addTarget:self action:@selector(buttonOnClickToAlertCenterNoAnim) forControlEvents:UIControlEventTouchUpInside];
}



- (void)buttonOnClickToAlertBottom:(id)sender
{
//    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] initWithContentView:[self aCustomView]];
//    alertView.showStyle = HQShowAlertFromBottom;
//    [alertView show];
//    [[[ZYLCustomAlertView alloc] initWithContentView:[self aCustomView]] show];
    [ZYLCustomAlertView addCustomView:[self aCustomView] forPosition:HQShowAlertFromBottom];
}
- (void)buttonOnClickToAlertCenterNoAnim
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] init];
    alertView.contentView = [self aCustomView];
    alertView.showStyle = HQShowAlertFromCenter;
    alertView.entableAnimation = NO;
    [alertView show];
    
//    [ZYLCustomAlertView addCustomView:[self aCustomView] forPosition:HQShowAlertFromCenter animaton:NO];
}

- (void)buttonOnClickToAlertCenter:(id)sender
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] init];
    alertView.contentView = [self aCustomView];
    alertView.showStyle = HQShowAlertFromCenter;
    [alertView show];
}


- (UIButton *)aCustomButtonWithTitle:(NSString *)title andFrame:(CGRect)frame
{
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.backgroundColor = [UIColor greenColor];
    [button1 setTitle:title forState:UIControlStateNormal];
    button1.frame = frame;
    [self.view addSubview:button1];
    return button1;
}

- (UIView *)aCustomView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    view.backgroundColor = [UIColor blueColor];
    return view;
}


@end
