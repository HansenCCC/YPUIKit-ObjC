//
//  UILabel+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (YPExtension)

@property (nonatomic, assign) CGFloat yp_lineSpacing;

/// 快速初始化
/// @param font font
/// @param textColor color
+ (instancetype)yp_labelWithFont:(UIFont *)font textColor:(UIColor *)textColor;

@end

NS_ASSUME_NONNULL_END
