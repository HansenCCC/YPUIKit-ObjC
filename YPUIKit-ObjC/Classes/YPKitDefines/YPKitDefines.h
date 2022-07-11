//
//  YPKitDefines.h
//  YPUIKit
//
//  Created by Hansen on 2022/7/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


// 是否是 ipad
#define YP_IS_IPAD                         ([YPKitDefines instance].isIpad)

// 导航栏宽高
#define YP_HEIGHT_NAV_STATUS               ([YPKitDefines instance].statusBarSizeHeight)
#define YP_HEIGHT_NAV_CONTENTVIEW          ([YPKitDefines instance].navigationViewHeight)
#define YP_HEIGHT_NAV_BAR                  (YP_HEIGHT_NAV_STATUS + YP_HEIGHT_NAV_CONTENTVIEW)

// 屏幕宽高
#define YP_UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define YP_UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

// tab高度
#define YP_HEIGHT_IPHONEX_BOTTOM_MARGIN    ([YPKitDefines instance].safeAreaInsets.bottom)
#define YP_HEIGHT_TAB_BAR                  (YP_HEIGHT_IPHONEX_BOTTOM_MARGIN + 49)

// 搜索search 高度
#define YP_HEIGHT_SEARCH_BAR               44


@interface YPKitDefines : NSObject

+ (instancetype)instance;

- (UIEdgeInsets)safeAreaInsets;

- (CGFloat)navigationViewHeight;

- (CGFloat)statusBarSizeHeight;

- (BOOL)isIpad;

- (BOOL)isIPhoneXorLater;

@end

NS_ASSUME_NONNULL_END
