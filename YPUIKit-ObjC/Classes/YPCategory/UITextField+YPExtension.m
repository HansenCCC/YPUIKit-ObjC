//
//  UITextField+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UITextField+YPExtension.h"
#import <objc/runtime.h>

static char kMaxLength;

@implementation UITextField (YPExtension)

/// 获取光标位置
- (NSRange)yp_selectedRange {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    return NSMakeRange(location, length);
}

/// 设置光标位置
/// @param range 光标位置
- (void)yp_setSelectedRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange *selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectionRange];
}

#pragma mark - setters | getters

- (void)setYp_maxLength:(NSUInteger)yp_maxLength {
    objc_setAssociatedObject(self, &kMaxLength, @(yp_maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (yp_maxLength) {
        [self addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

- (NSUInteger)yp_maxLength {
    NSNumber *number = objc_getAssociatedObject(self, &kMaxLength);
    return [number unsignedIntegerValue];
}

- (void)textChange:(UITextField *)textField {
    NSString *destText = textField.text;
    NSUInteger maxLength = textField.yp_maxLength;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (destText.length > maxLength) {
            NSRange range;
            NSUInteger inputLength = 0;
            for (int i = 0; i < destText.length && inputLength <= maxLength; i += range.length) {
                range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
                inputLength += [destText substringWithRange:range].length;
                if (inputLength > maxLength) {
                    NSString *newText = [destText substringWithRange:NSMakeRange(0, range.location)];
                    textField.text = newText;
                }
            }
        }
    }
}

@end
