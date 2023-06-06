//
//  UINavigationBar+YPExtension.h
//  YPLaboratory
//
//  Created by Hansen on 2023/6/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (YPExtension)

@property (nonatomic, assign) BOOL yp_enableScrollEdgeAppearance;// 导航外观是否根据滚动边缘变化
@property (nonatomic, assign) BOOL yp_translucent;// 是否半透明 default YES
@property (nonatomic, assign) BOOL yp_transparent;// 是否全透明
@property (nonatomic, assign) BOOL yp_hideBottomLine;// 是否隐藏底部线条
@property (nonatomic, strong) UIFont *yp_titleFont;// 设置标题字体大小
@property (nonatomic, strong) UIColor *yp_titleColor;// 设置标题字体颜色
@property (nonatomic, strong) UIColor *yp_backgroundColor;// 导航栏背景颜色
@property (nonatomic, strong) UIColor *yp_tintColor;// 导航栏主题色

/// 重置导航栏
- (void)yp_resetConfiguration;

/// 修改配置之后需要调用次方法才会修改
- (void)yp_configuration;

@end

NS_ASSUME_NONNULL_END

