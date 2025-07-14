//
//  UIApplication+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (YPExtension)

/// 获取当前获取 window
+ (UIWindow *)yp_activeWindow;

@end

NS_ASSUME_NONNULL_END
