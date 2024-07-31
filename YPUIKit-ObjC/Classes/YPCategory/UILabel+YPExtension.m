//
//  UILabel+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UILabel+YPExtension.h"

@implementation UILabel (YPExtension)

/// 快速初始化
/// @param font font
/// @param textColor color
+ (instancetype)yp_labelWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] init];
    if (font) {
        label.font = font;
    }
    if (textColor) {
        label.textColor = textColor;
    }
    return label;
}

@end
