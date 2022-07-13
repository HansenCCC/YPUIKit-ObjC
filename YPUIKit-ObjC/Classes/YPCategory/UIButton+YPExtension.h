//
//  UIButton+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YPExtension)

/// 快速初始化
/// @param font font
/// @param textColor color
/// @param state status
+ (instancetype)yp_buttonWithFont:(UIFont *)font textColor:(UIColor *)textColor forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
