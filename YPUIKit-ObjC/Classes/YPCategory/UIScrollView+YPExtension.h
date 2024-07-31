//
//  UIScrollView+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (YPExtension)

/// 滚动到底部
/// @param animated 动画
- (void)yp_scrollToBottomWithAnimated:(BOOL)animated;

/// 滚动到头部
/// @param animated 动画
- (void)yp_scrollToTopWithAnimated:(BOOL)animated;

/// 滚动到指定试图
/// @param toView 试图
/// @param animated 动画
-(void)yp_scrollToView:(UIView *)toView animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
