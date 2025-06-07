//
//  UIView+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YPExtension)

/// 获取view垂直位置最底部的subview
- (UIView *)yp_verticalBottomView;

/// 获取view水平位置最右部的subview
- (UIView *)yp_horizontalBottomView;

/// 找出当前视图subviews中所有是 class（UIView）类
/// @param aClass 类
- (NSArray <UIView *>*)yp_searchAllSubviewsForClass:(Class)aClass;

/// 返回视图的截屏图片
/// @param scale 比例
- (UIImage *)yp_screenshotsImageWithScale:(CGFloat)scale;
- (UIImage *)yp_screenshotsImage;

/// 找出当前试图下所有的 class 类
/// @param viewClass 寻找的类
- (NSArray <UIView *>*)yp_findSubviewsOfClass:(Class)viewClass;

/// 找出当前父视图所有的 class 类
/// @param viewClass 寻找的类
- (NSArray <UIView *>*)yp_findSuperviewsOfClass:(Class)viewClass;

@end

@interface UIView (YPCornerRadius)

/// 快速绘制圆角
/// @param corners 例如顶部圆角=UIRectCornerTopLeft  | UIRectCornerTopRight 顶部圆角
/// @param radius 大小
- (void)yp_viewRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end

@interface UIView (CPGradientColor)

/// 添加渐变色背景
/// @param colors 渐变颜色数组（UIColor）
/// @param locations 渐变位置（可为 nil）
/// @param startPoint 开始点（0~1）
/// @param endPoint 结束点（0~1）
- (void)yp_addGradientColors:(NSArray<UIColor *> *)colors
                   locations:(nullable NSArray<NSNumber *> *)locations
                  startPoint:(CGPoint)startPoint
                    endPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
