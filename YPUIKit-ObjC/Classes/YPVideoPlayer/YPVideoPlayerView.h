//
//  YPVideoPlayerView.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YPVideoSource.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YPVideoPlayerStateUnknown = 0,       // 初始状态，未加载资源
    YPVideoPlayerStatePreparing,         // 正在准备（初始化资源、加载中）
    YPVideoPlayerStateReadyToPlay,       // 缓冲完成，准备播放
    YPVideoPlayerStatePlaying,           // 正在播放
    YPVideoPlayerStatePaused,            // 被用户或系统暂停
    YPVideoPlayerStateStalled,           // 播放卡顿，等待缓冲
    YPVideoPlayerStateEnded,             // 播放完成
    YPVideoPlayerStateFailed             // 播放失败
} YPVideoPlayerState;

@interface YPVideoPlayerView : UIView

@property (nonatomic, readonly) BOOL playing;
@property (nonatomic, assign) CMTime currentTime;   // 播放时间
@property (nonatomic, copy) void (^onProgressUpdate)(float progress);
@property (nonatomic, copy) void (^onCompletion)(float progress);
@property (nonatomic, copy) void (^onRotateButtonTapped)(void);
@property (nonatomic, copy) void (^onBackButtonTapped)(void);

@property (nonatomic, readonly) YPVideoPlayerState state;  // 播放状态

- (void)playWithSource:(YPVideoSource *)videoSource;

- (void)play;

- (void)pause;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
