//
//  YPVideoSource.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/4/27.
//

#import "YPVideoSource.h"
#import "NSString+YPExtension.h"
#import "YPVideoPlayerManager.h"

NSString *const kYPVideoSourceLastPlayTimeKey = @"kYPVideoSourceLastPlayTimeKey";

@implementation YPVideoSource

- (void)saveLastPlayTime {
    // 保存当前播放的时间
    CGFloat currentTime = [YPVideoPlayerManager shareInstance].currentTime;
    if (!([YPVideoPlayerManager shareInstance].player && self.url.absoluteString.length > 0 && currentTime > 5.f)) {
        return;
    }
    CGFloat lastPlayTime = currentTime;
    NSString *key = [NSString stringWithFormat:@"%@_%@", kYPVideoSourceLastPlayTimeKey, self.url.absoluteString.yp_md5];
    [[NSUserDefaults standardUserDefaults] setObject:@(lastPlayTime) forKey:key];
}

- (void)clearLastPlayTime {
    // 清空播放进度
    CGFloat lastPlayTime = 0.f;
    NSString *key = [NSString stringWithFormat:@"%@_%@", kYPVideoSourceLastPlayTimeKey, self.url.absoluteString.yp_md5];
    [[NSUserDefaults standardUserDefaults] setObject:@(lastPlayTime) forKey:key];
}

- (CGFloat)lastPlayTime {
    if (self.url.absoluteString.length == 0) {
        return 0.f;
    }
    NSString *key = [NSString stringWithFormat:@"%@_%@", kYPVideoSourceLastPlayTimeKey, self.url.absoluteString.yp_md5];
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

@end
