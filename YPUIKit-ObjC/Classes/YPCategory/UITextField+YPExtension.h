//
//  UITextField+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (YPExtension)

/// 设置输入框输入长度
@property (assign, nonatomic) IBInspectable NSUInteger yp_maxLength;

/// 获取光标位置
- (NSRange)yp_selectedRange;

/// 设置光标位置
/// @param range 光标位置
- (void)yp_setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
