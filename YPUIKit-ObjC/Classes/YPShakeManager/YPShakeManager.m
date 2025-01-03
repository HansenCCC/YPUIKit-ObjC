//
//  YPShakeManager.m
//  Pods
//
//  Created by Hansen on 2023/5/17.
//

#import "YPShakeManager.h"
#import <AudioToolbox/AudioToolbox.h>

NSString *kYPShakeManagerIsEnableShareKey = @"kYPShakeManagerIsEnableShareKey";

@interface YPShakeManager ()

@property (nonatomic, assign) BOOL cache_isEnableShare;

@end

@implementation YPShakeManager

+ (instancetype)shareInstance {
    static YPShakeManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[YPShakeManager alloc] init];
        // 检查NSUserDefaults中是否有值，如果没有，设置默认值
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kYPShakeManagerIsEnableShareKey]) {
            m.isEnableShare = YES;
        }
        m.cache_isEnableShare = [[NSUserDefaults standardUserDefaults] boolForKey:kYPShakeManagerIsEnableShareKey];
    });
    return m;
}

- (void)tapShake {
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

- (void)longPressShake {
    if (!self.isEnableShare) {
        return;
    }
    AudioServicesPlaySystemSound(1521);
}

- (void)shakeWithId:(NSInteger)soundID {
    if (!self.isEnableShare) {
        return;
    }
    AudioServicesPlaySystemSound((int)soundID);
}

- (void)lightShake {
    if (!self.isEnableShare) {
        return;
    }
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    [feedbackGenerator impactOccurred];
}

- (void)mediumShake {
    if (!self.isEnableShare) {
        return;
    }
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedbackGenerator impactOccurred];
}

- (void)heavyShake {
    if (!self.isEnableShare) {
        return;
    }
    UIImpactFeedbackGenerator *feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
    [feedbackGenerator impactOccurred];
}

#pragma mark - setters | setters

- (BOOL)isEnableShare {
    return self.cache_isEnableShare;
}

- (void)setIsEnableShare:(BOOL)isEnableShare {
    [[NSUserDefaults standardUserDefaults] setBool:isEnableShare forKey:kYPShakeManagerIsEnableShareKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.cache_isEnableShare = isEnableShare;
}

@end
