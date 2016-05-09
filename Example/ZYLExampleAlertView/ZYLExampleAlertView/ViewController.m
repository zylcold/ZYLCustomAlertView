//
//  ViewController.m
//  ZYLExampleAlertView
//
//  Created by Yun on 4/21/16.
//  Copyright © 2016 com.ZhuYunLong. All rights reserved.
//

#import "ViewController.h"
#import <ZYLCustomAlertView/ZYLCustomAlertView.h>
@interface ViewController ()<UITableViewDataSource>
@property(nonatomic, strong) NSArray *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self aCustomButtonWithTitle:@"底部展示" andFrame:CGRectMake(100, 100, 100, 30)] addTarget:self action:@selector(buttonOnClickToAlertBottom:) forControlEvents:UIControlEventTouchUpInside];
    [[self aCustomButtonWithTitle:@"中间展示" andFrame:CGRectMake(100, 140, 100, 30)] addTarget:self action:@selector(buttonOnClickToAlertCenter:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self aCustomButtonWithTitle:@"中间展示（无动画）" andFrame:CGRectMake(100, 180, 160, 30)] addTarget:self action:@selector(buttonOnClickToAlertCenterNoAnim) forControlEvents:UIControlEventTouchUpInside];
    
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


- (void)buttonOnClickToAlertBottom:(id)sender
{
//    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] initWithContentView:[self aCustomView]];
//    alertView.showStyle = ZYLShowAlertFromBottom;
//    [alertView show];
//    [[[ZYLCustomAlertView alloc] initWithContentView:[self aCustomView]] show];
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

- (void)buttonOnClickToAlertCenter:(id)sender
{
    ZYLCustomAlertView *alertView = [[ZYLCustomAlertView alloc] init];
    alertView.contentView = [self aCustomView];
    alertView.showStyle = ZYLShowAlertFromCenter;
    alertView.entablePanGestureRecognizer = YES;
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
