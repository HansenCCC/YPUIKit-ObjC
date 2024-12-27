//
//  UIView+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UIView+YPExtension.h"

@implementation UIView (YPExtension)

/// 获取view垂直位置最底部的subview
- (UIView *)yp_verticalBottomView {
    UIView *view = nil;
    for (UIView *subview in self.subviews) {
        if (CGRectGetMaxY(subview.frame) > CGRectGetMaxY(view.frame)) {
            view = subview;
        };
    }
    return view;
}

/// 获取view水平位置最右部的subview
- (UIView *)yp_horizontalBottomView {
    UIView *view = nil;
    for (UIView *subview in self.subviews) {
        if (CGRectGetMaxX(subview.frame) > CGRectGetMaxX(view.frame)) {
            view = subview;
        };
    }
    return view;
}

/// 找出当前视图subviews中所有是 class（UIView）类
/// @param aClass 类
- (NSArray <UIView *>*)yp_searchAllSubviewsForClass:(Class)aClass {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:aClass]) {
            [views addObject:v];
        }
        [views addObjectsFromArray:[v yp_searchAllSubviewsForClass:aClass]];
    }
    return views.count > 0 ? views : nil;
}

/// 找出当前父视图所有的 class 类
/// @param viewClass 寻找的类
- (NSArray <UIView *>*)yp_findSuperviewsOfClass:(Class)viewClass {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    UIView *currentView = self.superview;
    while (currentView) {
        if ([currentView isKindOfClass:viewClass]) {
            [views addObject:currentView];
        }
        currentView = currentView.superview;
    }
    return views.count > 0 ? views : nil;
}

/// 返回视图的截屏图片
/// @param scale 比例
- (UIImage *)yp_screenshotsImageWithScale:(CGFloat)scale {
    CGRect bounds = self.bounds;
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, scale);
    //    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)yp_screenshotsImage {
    UIImage *image = [self yp_screenshotsImageWithScale:0.0];
    return image;
}

/// 找出当前试图下所有的 class 类
/// @param viewClass 寻找的类
- (NSArray <UIView *>*)yp_findSubviewsOfClass:(Class)viewClass {
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:viewClass]) {
            [views addObject:v];
        }
        [views addObjectsFromArray:[v yp_findSubviewsOfClass:viewClass]];
    }
    return views.count > 0 ? views : nil;
}

@end

@implementation UIView (YPCornerRadius)

/// 快速绘制圆角
/// @param corners 例如顶部圆角=UIRectCornerTopLeft  | UIRectCornerTopRight 顶部圆角
/// @param radius 大小
- (void)yp_viewRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    [self layoutIfNeeded];
    CGSize cornerSize = CGSizeMake(radius, radius);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerSize];
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = maskPath.CGPath;
    self.layer.mask = borderLayer;
}

@end
