//
//  UITextView+YPExtension.h
//  Pods
//
//  Created by Hansen on 2022/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (YPExtension)

/// 获取光标位置
- (NSRange)yp_selectedRange;

/// 设置光标位置
/// @param range 光标位置
- (void)yp_setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
