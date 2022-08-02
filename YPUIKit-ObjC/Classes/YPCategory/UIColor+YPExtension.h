//
//  UIColor+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (YPExtension)

/// 十六进制转化为图片 例如: #FFFFFF
/// @param hexString 十六进制字符
+ (UIColor *)yp_colorWithHexString:(NSString *)hexString;

/// 十六进制转化为图片 例如: #FFFFFF
/// @param hexString 十六进制字符
/// @param alpha alpha
+ (UIColor *)yp_colorWithHexString:(NSString *)hexString withAlpha:(CGFloat)alpha;

/// 通过把color对象颜色转化为十六进制
/// @param color uicollor
+ (NSString *)yp_hexStringFromColor:(UIColor *)color;

+ (UIColor *)yp_randomColor;
+ (UIColor *)yp_blackColor;
+ (UIColor *)yp_darkColor;
+ (UIColor *)yp_grayColor;
+ (UIColor *)yp_gray2Color;
+ (UIColor *)yp_gray3Color;
+ (UIColor *)yp_gray4Color;
+ (UIColor *)yp_gray5Color;
+ (UIColor *)yp_gray6Color;
+ (UIColor *)yp_redColor;
+ (UIColor *)yp_orangeColor;
+ (UIColor *)yp_yellowColor;
+ (UIColor *)yp_blueColor;
+ (UIColor *)yp_pinkColor;
+ (UIColor *)yp_linkColor;
+ (UIColor *)yp_whiteColor;

/// 设置颜色透明度
/// @param alpha alpha
- (UIColor *)yp_alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
