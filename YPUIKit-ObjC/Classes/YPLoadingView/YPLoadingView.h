//
//  YPLoadingView.h
//  FanRabbit
//
//  Created by 程恒盛 on 2019/5/27.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YPLoadingView : UIView

/// 显示loading
+ (void)showLoading;

/// 展示带有loading文字的提示框
/// - Parameter loadingText: 提示文字
+ (void)showLoading:(NSString *)loadingText;

/// 隐藏loading
+ (void)hideLoading;

@end

