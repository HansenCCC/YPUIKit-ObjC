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
- (UIView *)yp_horizontalBottomView;

/// 获取view水平位置最右部的subview
- (UIView *)yp_verticalRightView;

/// 找出当前视图subviews中所有是 class（UIView）类
/// @param aClass 类
- (NSArray <UIView *>*)yp_searchAllSubviewsForClass:(Class)aClass;

/// 返回视图的截屏图片
/// @param scale 比例
- (UIImage *)yp_screenshotsImageWithScale:(CGFloat)scale;
- (UIImage *)yp_screenshotsImage;

@end

@interface UIView (YPCornerRadius)

/// 快速绘制圆角
/// @param corners 例如顶部圆角=UIRectCornerTopLeft  | UIRectCornerTopRight 顶部圆角
/// @param radius 大小
- (void)yp_viewRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
