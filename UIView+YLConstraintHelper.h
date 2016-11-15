//
//  UIView+YLConstraintHelper.h
//  Pods
//
//  Created by Yun on 15/11/2016.
//
//

#import <UIKit/UIKit.h>

@interface UIView (YLConstraintHelper)
- (void)yl_addOneselfConstrainToHeight:(CGFloat)height;
- (void)yl_addOneselfConstrainToWidth:(CGFloat)height;
- (void)yl_addOneselfConstrainToSize:(CGSize)size;

- (void)yl_addCenterYConstrainToSubview:(UIView *)subview offset:(CGFloat)offset;
- (void)yl_addCenterXConstrainToSubview:(UIView *)subview offset:(CGFloat)offsetX;
- (void)yl_addCenterConstrainToSubview:(UIView *)subview offset:(CGPoint)offsetY;

- (void)yl_addEdgeConstrainToSubview:(UIView *)subview inset:(UIEdgeInsets)inset;
@end
