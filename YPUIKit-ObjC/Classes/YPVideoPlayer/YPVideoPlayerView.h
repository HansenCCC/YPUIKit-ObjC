//
//  YPVideoPlayerView.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YPVideoItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPVideoPlayerView : UIView

@property (nonatomic, readonly) BOOL playing;
@property (nonatomic, assign) CMTime currentTime;   // 播放时间
@property (nonatomic, copy) void (^onProgressUpdate)(float progress);
@property (nonatomic, copy) void (^onCompletion)(float progress);

- (void)playWithURL:(YPVideoItem *)videoItem;
- (void)play;
- (void)pause;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
