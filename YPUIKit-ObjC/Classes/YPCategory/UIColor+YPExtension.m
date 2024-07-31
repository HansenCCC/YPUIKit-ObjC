//
//  UIColor+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UIColor+YPExtension.h"

@implementation UIColor (YPExtension)

/// 十六进制转化为图片 例如: #FFFFFF
/// @param hexString 十六进制字符
+ (UIColor *)yp_colorWithHexString:(NSString *)hexString {
    return [self yp_colorWithHexString:hexString withAlpha:1.0f];
}

+ (UIColor *)yp_colorWithHexString:(NSString *)hexString withAlpha:(CGFloat)alpha {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#"withString:@""] uppercaseString];
    CGFloat red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = alpha;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = 16 - [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = alpha;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return [UIColor clearColor];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

/// 随机颜色
+ (UIColor *)yp_randomColor {
    UIColor *color = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:1];
    return color;
}

/// 通过把color对象颜色转化为十六进制
/// @param color uicollor
+ (NSString *)yp_hexStringFromColor:(UIColor *)color {
    //http://blog.sina.com.cn/s/blog_a5b73bad0102x01x.html
    if (color == nil) {
        return nil;
    }
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    NSString *r,*g,*b;
    (int)((CGColorGetComponents(color.CGColor))[0]*255.0) == 0?(r = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0)]):(r = [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0)]);
    (int)((CGColorGetComponents(color.CGColor))[1]*255.0) == 0?(g = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[1]*255.0)]):(g = [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[1]*255.0)]);
    (int)((CGColorGetComponents(color.CGColor))[2]*255.0) == 0?(b = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[2]*255.0)]):(b = [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[2]*255.0)]);
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)yp_blackColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#000000"];
    });
    return color;
}

+ (UIColor *)yp_darkColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#262a30"];
    });
    return color;
}

+ (UIColor *)yp_grayColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#8e8e93"];
    });
    return color;
}

+ (UIColor *)yp_gray2Color {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#aeaeb2"];
    });
    return color;
}

+ (UIColor *)yp_gray3Color {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#c7c7cc"];
    });
    return color;
}

+ (UIColor *)yp_gray4Color {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#d1d1d6"];
    });
    return color;
}

+ (UIColor *)yp_gray5Color {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#e5e5ea"];
    });
    return color;
}

+ (UIColor *)yp_gray6Color {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#f2f2f7"];
    });
    return color;
}

+ (UIColor *)yp_redColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#ff3b30"];
    });
    return color;
}

+ (UIColor *)yp_orangeColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#ff9500"];
    });
    return color;
}

+ (UIColor *)yp_yellowColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#ffcc00"];
    });
    return color;
}

+ (UIColor *)yp_blueColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#007aff"];
    });
    return color;
}

+ (UIColor *)yp_pinkColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#ff2d55"];
    });
    return color;
}

+ (UIColor *)yp_linkColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#007aff"];
    });
    return color;
}

+ (UIColor *)yp_whiteColor {
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor yp_colorWithHexString:@"#ffffff"];
    });
    return color;
}

+ (NSArray <NSString *>*)yp_allColors {
    static NSArray *colors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = @[
            [UIColor yp_hexStringFromColor:[UIColor blackColor]],
            [UIColor yp_hexStringFromColor:[UIColor darkGrayColor]],
            [UIColor yp_hexStringFromColor:[UIColor lightGrayColor]],
            [UIColor yp_hexStringFromColor:[UIColor whiteColor]],
            [UIColor yp_hexStringFromColor:[UIColor grayColor]],
            [UIColor yp_hexStringFromColor:[UIColor redColor]],
            [UIColor yp_hexStringFromColor:[UIColor greenColor]],
            [UIColor yp_hexStringFromColor:[UIColor blueColor]],
            [UIColor yp_hexStringFromColor:[UIColor cyanColor]],
            [UIColor yp_hexStringFromColor:[UIColor yellowColor]],
            [UIColor yp_hexStringFromColor:[UIColor magentaColor]],
            [UIColor yp_hexStringFromColor:[UIColor orangeColor]],
            [UIColor yp_hexStringFromColor:[UIColor purpleColor]],
            [UIColor yp_hexStringFromColor:[UIColor brownColor]],
            [UIColor yp_hexStringFromColor:[UIColor purpleColor]],
        ];
    });
    return colors;
}


- (UIColor *)yp_alpha:(CGFloat)alpha {
    UIColor *color = [self copy];
    NSString *hexStr = [UIColor yp_hexStringFromColor:color];
    return [UIColor yp_colorWithHexString:hexStr withAlpha:alpha];
}

@end
