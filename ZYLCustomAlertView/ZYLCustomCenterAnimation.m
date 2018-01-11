//
//  ZYLCustomAnimation.m
//  Pods
//
//  Created by Relly on 21/11/2016.
//
//

#import "ZYLCustomCenterAnimation.h"
@implementation ZYLCustomCenterAnimation


//MARK: 获取动画效果
+ (CABasicAnimation *)dismissCenterScaleAnimation
{
    CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fooAnimation.fromValue = @(1);
    fooAnimation.duration = 0.1;
    fooAnimation.toValue = @(0);
    fooAnimation.fillMode = kCAFillModeForwards;
    fooAnimation.removedOnCompletion = NO;
    fooAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.84 :.14 :.95 :0.42];
    return fooAnimation;
}

+ (CABasicAnimation *)dismissCenterTransfromTranslateAnimationToValue:(CGFloat)toValue
{
    CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    fooAnimation.duration = 0.25;
    fooAnimation.toValue = @(toValue);
    fooAnimation.fillMode = kCAFillModeForwards;
    fooAnimation.removedOnCompletion = NO;
    return fooAnimation;
}
+ (CAAnimation *)showCenterScaleAnimationWithSpring
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        
        if (@available(iOS 9.0, *)) {
            CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
            spring.damping = 80;
            spring.stiffness = 230;
            spring.mass = 1.2;
            spring.initialVelocity = 20;
            spring.fromValue = @(0);
            spring.toValue = @(1);
            spring.duration = spring.settlingDuration;
            return spring;
        }
        return nil;
        
    }else {
        return [self showCenterScaleAnimationWithBasic];
    }
}

+ (CAAnimation *)showCenterScaleAnimationWithBasic
{
    CABasicAnimation *fooAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fooAnimation.fromValue = @(0);
    fooAnimation.duration = 0.25;
    fooAnimation.toValue = @(1);
    fooAnimation.fillMode = kCAFillModeForwards;
    fooAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.03 :.54 :.07 :0.98];
    fooAnimation.removedOnCompletion = NO;
    return fooAnimation;
}
@end
