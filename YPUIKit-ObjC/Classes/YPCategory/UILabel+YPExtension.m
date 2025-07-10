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
    NSAttributedString *currentAttributedText;
    if (self.attributedText) {
        currentAttributedText = [self.attributedText mutableCopy];
    } else if (self.text) {
        currentAttributedText = [[NSAttributedString alloc] initWithString:self.text];
    } else {
        return; // 没有文本，直接返回
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    NSMutableAttributedString *newAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:currentAttributedText];
    [newAttributedText addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, newAttributedText.length)];
    if (!self.attributedText) {
        [newAttributedText addAttribute:NSFontAttributeName
                                 value:self.font
                                 range:NSMakeRange(0, newAttributedText.length)];
    }
    self.attributedText = newAttributedText;
}

- (CGFloat)cp_lineSpacing {
    NSNumber *value = objc_getAssociatedObject(self, kLineSpacingKey);
    return value ? value.floatValue : 0;
}

@end
