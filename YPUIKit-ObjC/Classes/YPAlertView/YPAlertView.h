//
//  YPAlertView.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPAlertView : UIView

+ (void)alertText:(NSString *)text;

+ (void)alertText:(NSString *)text complete:(void (^)())complete;

+ (void)alertText:(NSString *)text duration:(CGFloat)duration;

+ (void)alertText:(NSString *)text duration:(CGFloat)duration complete:(void (^)())complete;

+ (void)alertText:(NSString *)text inWindow:(UIWindow *)window duration:(CGFloat)duration complete:(void (^)())complete;

@end

NS_ASSUME_NONNULL_END
