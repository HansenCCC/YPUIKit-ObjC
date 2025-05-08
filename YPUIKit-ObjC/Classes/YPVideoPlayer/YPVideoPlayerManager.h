//
//  YPVideoPlayerManager.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "YPVideoSource.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kYPVideoPlayerManagerUpdateUIKey;

@interface YPVideoPlayerManager : NSObject

@property (nonatomic, assign) float playbackRate;        // 播放速度
@property (nonatomic, assign) float volume;              // 声音
@property (nonatomic, assign) float brightness;          // 屏幕亮度

@property (nonatomic, weak) YPVideoSource *videoSource;  // 挂载正在播放的 videoSource
@property (nonatomic, weak) AVPlayer *player;            // 挂载正在播放的 player
@property (nonatomic, assign) BOOL isPlaying;            // 是否在播放
@property (nonatomic, assign) float currentTime;         // 当前播放时间
@property (nonatomic, assign) float duration;            // 总时间

+ (instancetype)shareInstance;

- (void)needUpdateUI;

- (void)play;

- (void)pause;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
