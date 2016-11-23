//
//  ZYLToastAlertView.h
//  Pods
//
//  Created by Relly on 21/11/2016.
//
//

#import <Foundation/Foundation.h>

@interface ZYLToastAlertView : NSObject
+ (void)topToastMessage:(NSString *)message;
+ (void)topToastMessageAttr:(NSAttributedString *)message;
+ (void)topToastMessageAttr:(NSAttributedString *)message inset:(UIEdgeInsets)inset;
@end
