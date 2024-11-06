//
//  YPBadgeView.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2024/11/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPBadgeView : UILabel

@property (nonatomic, assign) NSInteger badgeInteger; /// 用数字设置未读数，0表示不显示未读数
@property (nonatomic, strong) NSString *badgeString; /// 用字符串设置未读数，nil 表示不显示未读数
@property (nonatomic, assign) BOOL isBadge; /// 是否显示角标 默认NO  红点和角标

/// 展示未读消息在试图右上角上面
/// - Parameters:
///   - view: 要展示的试图
///   - badgeInteger: 要展示的未读消息数量
+ (void)showBadgeToView:(UIView *)view badgeInteger:(NSInteger )badgeInteger;

/// 展示红点在试图右上角上面
/// - Parameter view: 要展示的试图
+ (void)showBadgeToView:(UIView *)view;

/// 隐藏角标
/// - Parameter view: 要展示的试图
+ (void)hiddenBadgeToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
