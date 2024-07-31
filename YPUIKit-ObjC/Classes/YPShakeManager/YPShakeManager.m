//
//  YPShakeManager.m
//  Pods
//
//  Created by Hansen on 2023/5/17.
//

#import "YPShakeManager.h"
#import <AudioToolbox/AudioToolbox.h>

NSString *kYPShakeManagerIsEnableShareKey = @"kYPShakeManagerIsEnableShareKey";

@implementation YPShakeManager

+ (instancetype)shareInstance {
    static YPShakeManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[YPShakeManager alloc] init];
    });
    return m;
}

- (void)tapShare {
    AudioServicesPlaySystemSound(1519);
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//    // 可以自己设定震动间隔与时常（毫秒）
//    // 是否生效, 时长, 是否生效, 时长……
//    NSArray *pattern = @[@YES, @30, @NO, @1];
//    dictionary[@"VibePattern"] = pattern; // 模式
//    dictionary[@"Intensity"] = @.9; // 强度（测试范围是0.3～1.0）
//    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dictionary);
//    AudioServicesPlaySystemSound(kAudioServicesPropertyIsUISound);
}

- (void)longPressShare {
    AudioServicesPlaySystemSound(1521);
}

#pragma mark - setters | setters

- (BOOL)isEnableShare {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kYPShakeManagerIsEnableShareKey];
}

- (void)setIsEnableShare:(BOOL)isEnableShare {
    [[NSUserDefaults standardUserDefaults] setBool:isEnableShare forKey:kYPShakeManagerIsEnableShareKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
