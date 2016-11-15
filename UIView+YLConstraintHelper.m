//
//  UIView+YLConstraintHelper.m
//  Pods
//
//  Created by Yun on 15/11/2016.
//
//

#import "UIView+YLConstraintHelper.h"

@implementation UIView (YLConstraintHelper)

- (NSLayoutConstraint *)yl_oneselfConstrainToHeight:(CGFloat)height
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:height];
}

- (NSLayoutConstraint *)yl_oneselfConstrainToWidth:(CGFloat)width
{
    return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:width];
}

- (NSLayoutConstraint *)yl_centerYConstrainToSubview:(UIView *)subview offset:(CGFloat)offset
{
    return [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:offset];
}

- (NSLayoutConstraint *)yl_centerXConstrainToSubview:(UIView *)subview offset:(CGFloat)offset
{
    return [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:offset];
}

- (NSArray *)yl_edgeConstrainToSubview:(UIView *)subview inset:(UIEdgeInsets)inset
{
    NSMutableArray *temArray = [NSMutableArray array];
    [temArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[subview]-(right)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"left" : @(inset.left), @"right" : @(inset.right)} views:NSDictionaryOfVariableBindings(subview)]];
    
    [temArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[subview]-(bottom)-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:@{@"top" : @(inset.top), @"bottom" : @(inset.bottom)} views:NSDictionaryOfVariableBindings(subview)]];
    return temArray;
}


- (void)yl_addOneselfConstrainToSize:(CGSize)size
{
    [self addConstraint:[self yl_oneselfConstrainToWidth:size.width]];
    [self addConstraint:[self yl_oneselfConstrainToHeight:size.height]];
}
- (void)yl_addOneselfConstrainToHeight:(CGFloat)height
{
    [self addConstraint:[self yl_oneselfConstrainToHeight:height]];
}
- (void)yl_addOneselfConstrainToWidth:(CGFloat)height
{
    [self addConstraint:[self yl_oneselfConstrainToWidth:height]];
}

- (void)yl_addCenterYConstrainToSubview:(UIView *)subview offset:(CGFloat)offsetY
{
    [self addConstraint:[self yl_centerYConstrainToSubview:subview offset:offsetY]];
}
- (void)yl_addCenterXConstrainToSubview:(UIView *)subview offset:(CGFloat)offsetX
{
    [self addConstraint:[self yl_centerXConstrainToSubview:subview offset:offsetX]];
}
- (void)yl_addCenterConstrainToSubview:(UIView *)subview offset:(CGPoint)offset
{
    [self addConstraint:[self yl_centerYConstrainToSubview:subview offset:offset.y]];
    [self addConstraint:[self yl_centerXConstrainToSubview:subview offset:offset.x]];
}
- (void)yl_addEdgeConstrainToSubview:(UIView *)subview inset:(UIEdgeInsets)inset
{
    [self addConstraints:[self yl_edgeConstrainToSubview:subview inset:inset]];
}
@end
