//
//  UILabel+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UILabel+YPExtension.h"
#import <objc/runtime.h>

static const void *kLineSpacingKey = &kLineSpacingKey;

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

- (void)setCp_lineSpacing:(CGFloat)lineSpacing {
    objc_setAssociatedObject(self, kLineSpacingKey, @(lineSpacing), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.text) return;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSDictionary *attributes = @{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: self.font
    };
    self.attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:attributes];
}

- (CGFloat)cp_lineSpacing {
    NSNumber *value = objc_getAssociatedObject(self, kLineSpacingKey);
    return value ? value.floatValue : 0;
}

@end
