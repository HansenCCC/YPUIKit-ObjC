//
//  YPAppManager.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2024/12/11.
//

#import "YPAppManager.h"
#import <sys/utsname.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <arpa/inet.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <WebKit/WebKit.h>
#import "YPReachability.h"// 出自三方库
#import "YPKeychain.h"
#import "NSString+YPExtension.h"
#import "UIViewController+YPExtension.h"
#import <MessageUI/MessageUI.h>
#import "YPAlertView.h"

@interface YPAppManager () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *appInfoPlist;
@property (nonatomic, strong) NSString *userAgent;

@end

@implementation YPAppManager

+ (instancetype)shareInstance {
    static YPAppManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[YPAppManager alloc] init];
        [m requestUserAgent:nil];
    });
    return m;
}

- (void)openAppStoreForReview {
    NSString *appID = [self appID];
    if (appID.length == 0) {
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review", appID];
    NSURL *appStoreReviewURL = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:appStoreReviewURL]) {
        [[UIApplication sharedApplication] openURL:appStoreReviewURL options:@{} completionHandler:nil];
    }
}

- (void)openAppStoreForApp {
    [self openAppStoreWithAppID:[self appID]];
}

- (void)openAppStoreWithAppID:(NSString *)appID {
    if (appID.length == 0) {
        return;
    }
    NSURL *appStoreURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID]];
    if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
        [[UIApplication sharedApplication] openURL:appStoreURL options:@{} completionHandler:nil];
    }
}

- (void)shareAppLink {
    NSString *appId = [self appID];
    NSString *appLink = [NSString stringWithFormat:@"https://apps.apple.com/app/id%@",appId];
    NSArray *itemsToShare = @[appLink];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    // 在 iPad 上，设置 popoverPresentationController 的 sourceView 和 sourceRect
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = [[UIViewController yp_topViewController] view]; // 设置来源视图
        activityVC.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX([[UIViewController yp_topViewController] view].bounds),
                                                                         CGRectGetMidY([[UIViewController yp_topViewController] view].bounds),
                                                                         0,
                                                                         0); // 设置来源矩形区域
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny; // 设置箭头方向
    }
    [[UIViewController yp_topViewController] presentViewController:activityVC animated:YES completion:nil];
}

- (void)sendEmailWithSubject:(NSString *)subject messageBody:(NSString *)messageBody {
    NSString *email = self.authorMail;
    if (email.length == 0) {
        [YPAlertView alertText:@"方法不可用，请开发者在 info.plist 设置 yp_author_mail".yp_localizedString duration:3.f];
        return;
    }
    if (![MFMailComposeViewController canSendMail]) {
        // 处理无法发送邮件的情况
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法发送邮件".yp_localizedString
                                                                       message:@"请在设备上设置邮件账户。".yp_localizedString
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定".yp_localizedString style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [[UIViewController yp_topViewController] presentViewController:alert animated:YES completion:nil];
        return;
    }
    MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
    mailComposeVC.mailComposeDelegate = self; // 记得实现MFMailComposeViewControllerDelegate
    [mailComposeVC setToRecipients:@[email]]; // 设置收件人
    [mailComposeVC setSubject:subject];
    [mailComposeVC setMessageBody:messageBody isHTML:NO];
    [[UIViewController yp_topViewController] presentViewController:mailComposeVC animated:YES completion:nil];
}

- (void)sendFeedbackEmail {
    NSString *subject = [NSString stringWithFormat:@"%@ %@", self.appName, @"意见反馈".yp_localizedString];
    NSString *messageBody = @"亲爱的用户，感谢您使用我的应用！\n我非常重视您的反馈。\n请在下方输入您的意见或建议：\n------------------------------------\n您的意见：\n\n\n\n\n\n------------------------------------\n\n".yp_localizedString;
    [self sendEmailWithSubject:subject messageBody:messageBody];
}

- (void)requestUserAgent:(nullable void(^)(NSString *userAgent))callback {
    if (self.userAgent.length > 0) {
        if (callback) {
            callback(self.userAgent);
        }
        return;
    }
    static WKWebView *sharedWebView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWebView = [WKWebView new];
    });
    __weak typeof(self) weakSelf = self;
    [sharedWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable ua, NSError * _Nullable error) {
        if ([ua isKindOfClass:[NSString class]]) {
            sharedWebView.customUserAgent = ua;
            weakSelf.userAgent = ua;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callback) {
                    callback(weakSelf.userAgent);
                }
            });
        }
    }];
}

- (void)copyToPasteboard:(NSString *)text {
    if (text.length == 0) return;
    [UIPasteboard generalPasteboard].string = text;
    [YPAlertView alertText:@"复制成功！"];
}

#pragma mark - getter | setter

- (NSDictionary *)appInfoPlist {
    if (!_appInfoPlist) {
        _appInfoPlist = [[NSBundle mainBundle] infoDictionary];
    }
    return _appInfoPlist;
}

- (NSString *)version {
    return self.appInfoPlist[@"CFBundleShortVersionString"];
}

- (NSString *)appName {
    return self.appInfoPlist[@"CFBundleDisplayName"];
}

- (NSString *)build {
    return self.appInfoPlist[@"CFBundleVersion"];
}

- (NSString *)bundleID {
    return self.appInfoPlist[@"CFBundleIdentifier"];
}

- (NSString *)appID {
    return self.appInfoPlist[@"yp_appid"];
}

- (NSString *)author {
    return self.appInfoPlist[@"yp_author"];
}

- (NSString *)authorMail {
    return self.appInfoPlist[@"yp_author_mail"];
}

- (NSString *)deviceString {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if (!deviceString) return @"Unknown Unknown";
    return deviceString;
}

- (NSString *)deviceName {
    NSString *deviceString = [self deviceString];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7"; //国行、日版、港行
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus"; //国行、港行
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7"; //美版、台版
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus"; //美版、台版
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8"; //国行(A1863)、日行(A1906)
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus"; //国行(A1864)、日行(A1898)
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X"; //国行(A1865)、日行(A1902)
    if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8"; //美版(Global/A1905)
    if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus"; //美版(Global/A1897)
    if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";//美版(Global/A1901)
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])    return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])    return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])    return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"])    return @"iPhone SE"; //(2nd generation)
    if ([deviceString isEqualToString:@"iPhone13,1"])    return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,2"])    return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"])    return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"])    return @"iPhone 12 Pro Max";
    if ([deviceString isEqualToString:@"iPhone14,2"])    return @"iPhone 13 Pro";
    if ([deviceString isEqualToString:@"iPhone14,3"])    return @"iPhone 13 Pro Max";
    if ([deviceString isEqualToString:@"iPhone14,4"])    return @"iPhone 13 mini";
    if ([deviceString isEqualToString:@"iPhone14,5"])    return @"iPhone 13";
    if ([deviceString isEqualToString:@"iPhone14,6"])    return @"iPhone SE"; //(2nd generation)
    if ([deviceString isEqualToString:@"iPhone14,7"])    return @"iPhone 14";
    if ([deviceString isEqualToString:@"iPhone14,8"])    return @"iPhone 14 Plus";
    if ([deviceString isEqualToString:@"iPhone15,2"])    return @"iPhone 14 Pro";
    if ([deviceString isEqualToString:@"iPhone15,3"])    return @"iPhone 14 Pro Max";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])     return @"iPad 5th";
    if ([deviceString isEqualToString:@"iPad6,12"])     return @"iPad 5th";
    if ([deviceString isEqualToString:@"iPad7,1"])      return @"iPad Pro 12.9 2nd";
    if ([deviceString isEqualToString:@"iPad7,2"])      return @"iPad Pro 12.9 2nd";
    if ([deviceString isEqualToString:@"iPad7,3"])      return @"iPad Pro 10.5";
    if ([deviceString isEqualToString:@"iPad7,4"])      return @"iPad Pro 10.5";
    if ([deviceString isEqualToString:@"iPad7,5"])      return @"iPad 6th";
    if ([deviceString isEqualToString:@"iPad7,6"])      return @"iPad 6th";
    if ([deviceString isEqualToString:@"iPad8,1"])      return @"iPad Pro 11";
    if ([deviceString isEqualToString:@"iPad8,2"])      return @"iPad Pro 11";
    if ([deviceString isEqualToString:@"iPad8,3"])      return @"iPad Pro 11";
    if ([deviceString isEqualToString:@"iPad8,4"])      return @"iPad Pro 11";
    if ([deviceString isEqualToString:@"iPad8,5"])      return @"iPad Pro 12.9 3rd";
    if ([deviceString isEqualToString:@"iPad8,6"])      return @"iPad Pro 12.9 3rd";
    if ([deviceString isEqualToString:@"iPad8,7"])      return @"iPad Pro 12.9 3rd";
    if ([deviceString isEqualToString:@"iPad8,8"])      return @"iPad Pro 12.9 3rd";
    if ([deviceString isEqualToString:@"iPad11,1"])      return @"iPad mini 5th";
    if ([deviceString isEqualToString:@"iPad11,2"])      return @"iPad mini 5th";
    if ([deviceString isEqualToString:@"iPad11,3"])      return @"iPad Air 3rd";
    if ([deviceString isEqualToString:@"iPad11,4"])      return @"iPad Air 3rd";
    if ([deviceString isEqualToString:@"iPad11,6"])      return @"iPad 8th";
    if ([deviceString isEqualToString:@"iPad11,7"])      return @"iPad 8th";
    if ([deviceString isEqualToString:@"iPad12,1"])      return @"iPad 9th";
    if ([deviceString isEqualToString:@"iPad12,2"])      return @"iPad 9th";
    if ([deviceString isEqualToString:@"iPad14,1"])      return @"iPad mini 6th";
    if ([deviceString isEqualToString:@"iPad14,2"])      return @"iPad mini 6th";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch (6 Gen)";
    if ([deviceString isEqualToString:@"iPod9,1"])      return @"iPod Touch (7 Gen)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator Simulator";
    
    return deviceString;
}

- (NSString *)systemName {
    return [UIDevice currentDevice].systemName;
}

- (NSString *)systemVersion {
    return [UIDevice currentDevice].systemVersion;
}

- (CGFloat)batteryLevel {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    return [UIDevice currentDevice].batteryLevel;
}

- (NSString *)batteryState {
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged"; // 未充电
        case UIDeviceBatteryStateCharging:
            return @"Charging";  // 充电中
        case UIDeviceBatteryStateFull:
            return @"Full";      // 已充满
        default:
            return @"Unknown";   // 未知状态
    }
}

- (NSString *)networkType {
    NSString *netconnType = @"";
    YPReachability *reach = [YPReachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentYPReachabilityStatus]) {
        case YPNotReachable: {
            // 没有网络
            netconnType = @"无网络".yp_localizedString;
        }
            break;
        case YPReachableViaWiFi:{
            // Wifi
            netconnType = @"WiFi";
        }
            break;

        case YPReachableViaWWAN: {
            // 手机自带网络
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentStatus = info.currentRadioAccessTechnology;
            if ([currentStatus isEqualToString:CTRadioAccessTechnologyGPRS]) {
                netconnType = @"2G";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyEdge]) {
                netconnType = @"2.75G EDGE";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyWCDMA]) {
                netconnType = @"3G";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSDPA]) {
                netconnType = @"3.5G HSDPA";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyHSUPA]) {
                netconnType = @"3.5G HSUPA";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
                netconnType = @"2G";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
                netconnType = @"3G";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
                netconnType = @"3G";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
                netconnType = @"3G";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyeHRPD]) {
                netconnType = @"HRPD";
            } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyLTE]) {
                netconnType = @"4G";
            } else if (@available(iOS 14.1, *)) {
                if ([currentStatus isEqualToString:CTRadioAccessTechnologyNRNSA]) {
                    netconnType = @"5G (NSA)";
                } else if ([currentStatus isEqualToString:CTRadioAccessTechnologyNR]) {
                    netconnType = @"5G (SA)";
                }
            }
        }
            break;
        default:
            break;
    }
    return netconnType;
}

- (NSString *)carrierName {
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSDictionary<NSString *, CTCarrier *> *carriers = networkInfo.serviceSubscriberCellularProviders;
    NSMutableArray *carrierNames = [NSMutableArray array];
    for (NSString *key in carriers) {
        CTCarrier *carrier = carriers[key];
        if (carrier.carrierName) {
            [carrierNames addObject:carrier.carrierName];
        }
    }
    return carrierNames.count > 0 ? [carrierNames componentsJoinedByString:@", "] : @"Unknown";
}


- (NSString *)ipAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // 获取所有网络接口
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // 获取Wi-Fi的IP地址
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return @"0.0.0.0";
}

- (NSString *)wifiSSID {
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *networkInfo = (__bridge_transfer NSDictionary *)myDict;
            return networkInfo[(NSString *)kCNNetworkInfoKeySSID] ?: @"Unknown";
        }
    }
    return @"Unknown";
}

- (NSString *)deviceUUID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

- (NSString *)yp_deviceIdentifier {
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *deviceIdentifierKeychainServiceName = [NSString stringWithFormat:@"%@.yp.deviceIdentifier", bundleIdentifier];
    NSString *savedDeviceIdentifier = [YPKeychain loadObjectForKey:deviceIdentifierKeychainServiceName];
    NSString *savedDeviceIdentifierDeviceOnly = [YPKeychain loadDeviceOnlyObjectForKey:deviceIdentifierKeychainServiceName];
    if (savedDeviceIdentifier.length) {
        [YPKeychain deleteObjectForKey:deviceIdentifierKeychainServiceName];
    }
    if (savedDeviceIdentifierDeviceOnly.length && !([savedDeviceIdentifierDeviceOnly rangeOfString:@"00000000"].length > 0)) {
        return savedDeviceIdentifierDeviceOnly;
    }
    NSString *identifier = self.p_deviceIdentifier;
    if (savedDeviceIdentifier.length && !([savedDeviceIdentifier rangeOfString:@"00000000"].length > 0)) {
        identifier = savedDeviceIdentifier;
    }
    [YPKeychain saveDeviceOnlyObject:identifier forKey:deviceIdentifierKeychainServiceName];
    return identifier;
}

- (NSString *)p_deviceIdentifier {
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    NSString *bundleIdentifier = [NSBundle mainBundle].bundleIdentifier;
    NSString *identifier = [NSString stringWithFormat:@"%@+%@", uuid.UUIDString, bundleIdentifier];
    return identifier.yp_md5.localizedUppercaseString;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    // 提示用户邮件发送结果
    NSString *message;
    switch (result) {
        case MFMailComposeResultCancelled:
            message = @"邮件取消发送。".yp_localizedString;
            break;
        case MFMailComposeResultSaved:
            message = @"邮件已保存到草稿。".yp_localizedString;
            break;
        case MFMailComposeResultSent:
            message = @"邮件发送成功！".yp_localizedString;
            break;
        case MFMailComposeResultFailed:
            message = [NSString stringWithFormat:@"邮件发送失败：%@".yp_localizedString, error.localizedDescription];
            break;
        default:
            break;
    }
    [YPAlertView alertText:message];
    [[UIViewController yp_topViewController] dismissViewControllerAnimated:YES completion:nil];
}

@end
