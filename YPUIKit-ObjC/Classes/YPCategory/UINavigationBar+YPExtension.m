//
//  UINavigationBar+YPExtension.m
//  YPLaboratory
//
//  Created by Hansen on 2023/6/6.
//

#import "UINavigationBar+YPExtension.h"
#import <objc/runtime.h>

static char kyp_enableScrollEdgeAppearanceKey;
static char kyp_translucentKey;
static char kyp_transparentKey;
static char kyp_hideBottomLineKey;
static char kyp_titleFontKey;
static char kyp_titleColorKey;
static char kyp_backgroundColorKey;
static char kyp_tintColorKey;

@implementation UINavigationBar (YPExtension)

// 重置导航栏
- (void)yp_resetConfiguration {
    self.yp_enableScrollEdgeAppearance = YES;// default YES
    self.yp_translucent = YES;// default YES
    self.yp_transparent = NO;// default NO
    self.yp_hideBottomLine = NO;// default NO
    self.yp_titleFont = [UIFont boldSystemFontOfSize:18.f];
    self.yp_titleColor = [UIColor blackColor];
    self.yp_backgroundColor = nil;
    self.yp_tintColor = [UIColor blueColor];
    
    [self yp_configuration];
}

- (void)yp_configuration {
    NSMutableDictionary *titleTextAttributes = [[NSMutableDictionary alloc] init];
    if (self.yp_titleFont) {
        [titleTextAttributes setObject:self.yp_titleFont forKey:NSFontAttributeName];
    }
    if (self.yp_titleColor) {
        [titleTextAttributes setObject:self.yp_titleColor forKey:NSForegroundColorAttributeName];
    }
    BOOL translucent = self.yp_translucent;
    self.translucent = translucent;
    self.barTintColor = self.yp_backgroundColor;
    self.titleTextAttributes = titleTextAttributes;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        if (self.yp_transparent) {
            [appearance configureWithTransparentBackground];
        } else {
            [appearance configureWithDefaultBackground];
        }
        appearance.backgroundColor = self.yp_backgroundColor;
        appearance.titleTextAttributes = titleTextAttributes;
        if (self.yp_hideBottomLine) {
            appearance.shadowImage = [UIImage new];
            appearance.shadowColor = [UIColor clearColor];
        }
        self.standardAppearance = appearance;
        if (self.yp_enableScrollEdgeAppearance) {
            self.scrollEdgeAppearance = appearance;
        } else {
            self.scrollEdgeAppearance = nil;
        }
    } else {
        // iOS 13以下的适配代码
        if (self.yp_transparent) {
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsCompact];
            [self setShadowImage:[UIImage new]];
        } else {
            // 恢复默认背景图像和阴影图像
            [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
            [self setShadowImage:nil];
        }
        self.barTintColor = self.yp_backgroundColor;
        self.titleTextAttributes = titleTextAttributes;
    }
}

#pragma mark - getters | setters

- (void)setYp_enableScrollEdgeAppearance:(BOOL)yp_enableScrollEdgeAppearance {
    NSNumber *value = @(yp_enableScrollEdgeAppearance);
    objc_setAssociatedObject(self, &kyp_enableScrollEdgeAppearanceKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yp_enableScrollEdgeAppearance {
    NSNumber *value = objc_getAssociatedObject(self, &kyp_enableScrollEdgeAppearanceKey);
    return [value boolValue];
}

- (void)setYp_translucent:(BOOL)yp_translucent {
    NSNumber *value = @(yp_translucent);
    objc_setAssociatedObject(self, &kyp_translucentKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yp_translucent {
    NSNumber *value = objc_getAssociatedObject(self, &kyp_translucentKey);
    return [value boolValue];
}

- (void)setYp_transparent:(BOOL)yp_transparent {
    NSNumber *value = @(yp_transparent);
    objc_setAssociatedObject(self, &kyp_transparentKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yp_transparent {
    NSNumber *value = objc_getAssociatedObject(self, &kyp_transparentKey);
    return [value boolValue];
}

- (void)setYp_hideBottomLine:(BOOL)yp_hideBottomLine {
    NSNumber *value = @(yp_hideBottomLine);
    objc_setAssociatedObject(self, &kyp_hideBottomLineKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yp_hideBottomLine {
    NSNumber *value = objc_getAssociatedObject(self, &kyp_hideBottomLineKey);
    return [value boolValue];
}

- (void)setYp_titleFont:(UIFont *)yp_titleFont {
    objc_setAssociatedObject(self, &kyp_titleFontKey, yp_titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIFont *)yp_titleFont {
    return objc_getAssociatedObject(self, &kyp_titleFontKey);
}

- (void)setYp_titleColor:(UIColor *)yp_titleColor {
    objc_setAssociatedObject(self, &kyp_titleColorKey, yp_titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yp_titleColor {
    return objc_getAssociatedObject(self, &kyp_titleColorKey);
}

- (void)setYp_backgroundColor:(UIColor *)yp_backgroundColor {
    objc_setAssociatedObject(self, &kyp_backgroundColorKey, yp_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yp_backgroundColor {
    return objc_getAssociatedObject(self, &kyp_backgroundColorKey);
}

- (void)setYp_tintColor:(UIColor *)yp_tintColor {
    objc_setAssociatedObject(self, &kyp_tintColorKey, yp_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yp_tintColor {
    return objc_getAssociatedObject(self, &kyp_tintColorKey);
}

@end
