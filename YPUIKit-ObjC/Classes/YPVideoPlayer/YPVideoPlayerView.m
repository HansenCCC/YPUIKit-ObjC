//
//  YPVideoPlayerView.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import "YPVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "YPVideoPlayerManager.h"
#import "YPVideoPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+YPExtension.h"

@interface YPVideoPlayerView ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) YPVideoPlayerControlView *controlView;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, strong) YPVideoSource *videoSource;
@property (nonatomic, assign) YPVideoPlayerState state;

@end

@implementation YPVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.state = YPVideoPlayerStateUnknown;
        [self setupSubviews];
        [self addObserverNotification];  // 添加进度更新
    }
    return self;
}

- (void)setupSubviews {
    [self.layer addSublayer:self.playerLayer];
    [self addSubview:self.controlView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect f1 = bounds;
    self.playerLayer.frame = f1;
    
    CGRect f2 = bounds;
    self.controlView.frame = f2;
}

- (void)addObserverNotification {
    __weak typeof(self) weakSelf = self;
    // 添加周期性时间观察者来回调进度  每秒回调一次
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 4) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float currentSeconds = CMTimeGetSeconds(time);
        float duration = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        [YPVideoPlayerManager shareInstance].duration = duration;
        [YPVideoPlayerManager shareInstance].currentTime = currentSeconds;
        [[YPVideoPlayerManager shareInstance] needUpdateUI];
        if (weakSelf.onProgressUpdate) {
            weakSelf.onProgressUpdate(currentSeconds);
        }
    }];
    // 应用唤起
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    // 应用到了后台
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self.player addObserver:self forKeyPath:@"timeControlStatus" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)applicationWillResignActive {
    [self.videoSource saveLastPlayTime];
}

- (void)applicationDidEnterBackground {
    [self.videoSource saveLastPlayTime];
}

- (void)setupAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [session setActive:YES error:&error];
}

- (void)playWithSource:(YPVideoSource *)videoSource {
    if (!videoSource) {
        return;
    }
    [YPVideoPlayerManager shareInstance].videoSource = videoSource;
    self.videoSource = videoSource;
    NSURL *url = videoSource.url;
    [self setupAudioSession];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"error" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFail:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidStall:) name:AVPlayerItemPlaybackStalledNotification object:item];
    // 使用上一次的配置
    self.player.volume = [YPVideoPlayerManager shareInstance].volume;
    self.player.rate = [YPVideoPlayerManager shareInstance].playbackRate;
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self pause];
    self.state = YPVideoPlayerStatePreparing;
}

- (void)play {
    [[YPVideoPlayerManager shareInstance] play];
    [self.videoSource saveLastPlayTime];
}

- (void)pause {
    [[YPVideoPlayerManager shareInstance] pause];
    [self.videoSource saveLastPlayTime];
}

- (void)stop {
    [[YPVideoPlayerManager shareInstance] stop];
    [self.videoSource saveLastPlayTime];
}

- (void)dealloc {
    [self.videoSource saveLastPlayTime];
    [YPVideoPlayerManager shareInstance].player = nil;
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"error"];
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (item.status == AVPlayerItemStatusUnknown) {
            self.state = YPVideoPlayerStatePreparing;
        } else if (item.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"视频已准备好播放");
            self.state = YPVideoPlayerStateReadyToPlay;
        } else if (item.status == AVPlayerItemStatusFailed) {
            NSLog(@"视频播放失败: %@", item.error.localizedDescription);
            self.state = YPVideoPlayerStateFailed;
        }
    } else if ([keyPath isEqualToString:@"timeControlStatus"]) {
        if (self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            self.state = YPVideoPlayerStatePlaying;
        } else if (self.player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
            self.state = YPVideoPlayerStatePaused;
        } else if (self.player.timeControlStatus == AVPlayerTimeControlStatusWaitingToPlayAtSpecifiedRate) {
            self.state = YPVideoPlayerStateStalled;
        }
    } else if ([keyPath isEqualToString:@"error"]) {
        NSLog(@"视频播放发生错误: %@", item.error.localizedDescription);
        self.state = YPVideoPlayerStateFailed;
    }
}

#pragma mark - notification

- (void)playerDidFinish:(NSNotification *)notification {
    self.state = YPVideoPlayerStateEnded;
    // 重置播放状态
    [self.videoSource clearLastPlayTime];
    [self playWithSource:self.videoSource];
}

- (void)playerDidFail:(NSNotification *)notification {
    self.state = YPVideoPlayerStateFailed;
}

- (void)playerDidStall:(NSNotification *)notification {
    self.state = YPVideoPlayerStateStalled;
}

#pragma mark - getters | setters

- (CMTime)currentTime {
    return self.player.currentTime;
}

- (void)setCurrentTime:(CMTime)currentTime {
    [self.player seekToTime:currentTime];
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    }
    return _playerLayer;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        [YPVideoPlayerManager shareInstance].player = _player;
    }
    return _player;
}

- (YPVideoPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[YPVideoPlayerControlView alloc] init];
    }
    return _controlView;
}

- (void)setOnRotateButtonTapped:(void (^)(void))onRotateButtonTapped {
    self.controlView.onRotateButtonTapped = onRotateButtonTapped;
}

- (void)setOnBackButtonTapped:(void (^)(void))onBackButtonTapped {
    self.controlView.onBackButtonTapped = onBackButtonTapped;
}

- (void)setState:(YPVideoPlayerState)state {
    if (_state == state) {
        return;
    }
    YPVideoPlayerState oldState = _state;
    _state = state;
    NSString * (^stateDescription)(YPVideoPlayerState) = ^(YPVideoPlayerState s) {
        switch (s) {
            case YPVideoPlayerStateUnknown: return @"Unknown";
            case YPVideoPlayerStatePreparing: return @"Preparing";
            case YPVideoPlayerStateReadyToPlay: return @"ReadyToPlay";
            case YPVideoPlayerStatePlaying: return @"Playing";
            case YPVideoPlayerStatePaused: return @"Paused";
            case YPVideoPlayerStateStalled: return @"Stalled";
            case YPVideoPlayerStateEnded: return @"Ended";
            case YPVideoPlayerStateFailed: return @"Failed";
            default: return @"Invalid";
        }
    };
    [[YPVideoPlayerManager shareInstance] needUpdateUI];
    NSLog(@"[YPVideoPlayer] 状态变化: %@ → %@", stateDescription(oldState), stateDescription(state));
}

@end
