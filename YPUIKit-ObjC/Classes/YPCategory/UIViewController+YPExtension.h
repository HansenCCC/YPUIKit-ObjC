//
//  UIViewController+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YPExtension)

/// 当前显示的控制器
+ (UIViewController *)yp_topViewController;

@end

NS_ASSUME_NONNULL_END
