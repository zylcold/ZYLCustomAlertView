//
//  ZYLCustomAnimation.h
//  Pods
//
//  Created by Relly on 21/11/2016.
//
//

#import <UIKit/UIKit.h>
@interface ZYLCustomCenterAnimation : NSObject
+ (CAAnimation *)showCenterScaleAnimationWithBasic;
+ (CAAnimation *)showCenterScaleAnimationWithSpring;
+ (CABasicAnimation *)dismissCenterScaleAnimation;
+ (CABasicAnimation *)dismissCenterTransfromTranslateAnimationToValue:(CGFloat)toValue;
@end
