//
//  UIButton+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UIButton+YPExtension.h"

@implementation UIButton (YPExtension)

/// 快速初始化
/// @param font font
/// @param textColor color
/// @param state status
+ (instancetype)yp_buttonWithFont:(UIFont *)font textColor:(UIColor *)textColor forState:(UIControlState)state {
    UIButton *button = [[UIButton alloc] init];
    if (textColor) {
        [button setTitleColor:textColor forState:state];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    return button;
}

@end
