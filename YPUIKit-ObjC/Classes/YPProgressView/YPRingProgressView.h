//
//  YPRingProgressView.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPRingProgressView : UIView

/// 显示进度
+ (void)showProgress:(CGFloat)progress;

/// 显示进度，并展示文字
/// - Parameter loadingText: 提示文字
+ (void)showProgress:(CGFloat)progress text:(NSString *)text;

/// 隐藏进度
+ (void)hideProgress;

@end

NS_ASSUME_NONNULL_END
