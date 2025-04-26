//
//  YPVideoPlayerManager.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import "YPVideoPlayerManager.h"

NSString *const kYPVideoPlayerManagerUpdateUIKey = @"kYPVideoPlayerManagerUpdateUIKey";         /// 发送更新 UI 通知
NSString *const kYPVideoPlayerManagerPlaybackRateKey = @"kYPVideoPlayerManagerPlaybackRateKey"; /// 当前播放速率
NSString *const kYPVideoPlayerManagerVolumeKey = @"kYPVideoPlayerManagerVolumeKey";             /// 当前播放器声音

@implementation YPVideoPlayerManager

+ (instancetype)shareInstance {
    static YPVideoPlayerManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[YPVideoPlayerManager alloc] init];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kYPVideoPlayerManagerPlaybackRateKey]) {
            m.playbackRate = 1.0;
        }
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kYPVideoPlayerManagerVolumeKey]) {
            m.volume = 1.0;
        }
    });
    return m;
}

- (void)needUpdateUI {
    [[NSNotificationCenter defaultCenter] postNotificationName:kYPVideoPlayerManagerUpdateUIKey object:nil];
}

- (BOOL)isPlaying {
    return self.player.rate != 0;
}

- (void)play {
    if (self.player) {
        [self.player play];
    }
}

- (void)pause {
    if (self.player) {
        [self.player pause];
    }
}

- (void)stop {
    if (self.player) {
        [self.player pause];
        [self.player seekToTime:kCMTimeZero];
    }
}

#pragma mark - getters | setters

- (void)setPlaybackRate:(float)playbackRate {
    [[NSUserDefaults standardUserDefaults] setFloat:playbackRate forKey:kYPVideoPlayerManagerPlaybackRateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)playbackRate {
    CGFloat playbackRate = [[NSUserDefaults standardUserDefaults] floatForKey:kYPVideoPlayerManagerPlaybackRateKey];
    return playbackRate;
}

- (void)setVolume:(float)volume {
    [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:kYPVideoPlayerManagerVolumeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (float)volume {
    CGFloat volume = [[NSUserDefaults standardUserDefaults] floatForKey:kYPVideoPlayerManagerVolumeKey];
    return volume;
}

- (void)setBrightness:(float)brightness {
    [[UIScreen mainScreen] setBrightness:brightness];
}

- (float)brightness {
    return [UIScreen mainScreen].brightness;
}

@end
