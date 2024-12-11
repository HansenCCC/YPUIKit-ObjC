//
//  YPAppManager.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2024/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPAppManager : NSObject

@property (nonatomic, readonly) NSDictionary *appInfoPlist;// info.plist 里面的参数
@property (nonatomic, readonly) NSString *version;// 版本号
@property (nonatomic, readonly) NSString *appName;// 应用名称
@property (nonatomic, readonly) NSString *build;// build 号
@property (nonatomic, readonly) NSString *bundleID;// 包名bundleID
@property (nonatomic, readonly) NSString *appID;// 应用id，在 info.plist 设置 yp_appid

@property (nonatomic, readonly) NSString *deviceName;// 设备信号 例如 iPhone 12
@property (nonatomic, readonly) NSString *deviceString;// 设备信号字符 例如 iPhone13,2
@property (nonatomic, readonly) NSString *systemName;// 系统名称，如 iOS
@property (nonatomic, readonly) NSString *systemVersion;// 系统版本，如 16.0
@property (nonatomic, readonly) CGFloat batteryLevel;// 电池电量（0.0 - 1.0）
@property (nonatomic, readonly) NSString *batteryState;// 电池状态（如充电中）
@property (nonatomic, readonly) NSString *networkType;// 当前网络类型（Wi-Fi/蜂窝网络）
@property (nonatomic, readonly) NSString *carrierName;// 运营商名称
@property (nonatomic, readonly) NSString *ipAddress;// 当前 IP 地址
@property (nonatomic, readonly) NSString *wifiSSID;// 当前 Wi-Fi 名称
@property (nonatomic, readonly) NSString *userAgent;// User Agent 字符串
@property (nonatomic, readonly) NSString *deviceUUID;// 设备唯一标识符

@property (nonatomic, readonly) NSString *yp_deviceIdentifier;// 设备唯一标识符【删除应用也不会改变】

+ (instancetype)shareInstance;

/// 打开应用来评论
- (void)openAppStoreForReview;

/// 在 App Store 查看该应用
- (void)openAppStoreForApp;

/// 在 App Store 查看应用
/// - Parameter appID: 应用 id
- (void)openAppStoreWithAppID:(NSString *)appID;

/// 获取 userAgent
/// - callback 回调 userAgent
- (void)requestUserAgent:(nullable void(^)(NSString *userAgent))callback;

@end

NS_ASSUME_NONNULL_END
