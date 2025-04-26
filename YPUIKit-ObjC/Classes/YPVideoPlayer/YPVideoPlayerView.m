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
@property (nonatomic, strong) YPVideoItem *videoItem;

@end

@implementation YPVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
}

- (void)applicationWillResignActive {
    [self.videoItem saveLastPlayTime];
}

- (void)applicationDidEnterBackground {
    [self.videoItem saveLastPlayTime];
}

- (void)setupAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [session setActive:YES error:&error];
}

- (void)playWithURL:(YPVideoItem *)videoItem {
    if (!videoItem) {
        return;
    }
    self.videoItem = videoItem;
    NSURL *url = videoItem.url;
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
}

- (void)play {
    [[YPVideoPlayerManager shareInstance] play];
    [self.videoItem saveLastPlayTime];
}

- (void)pause {
    [[YPVideoPlayerManager shareInstance] pause];
    [self.videoItem saveLastPlayTime];
}

- (void)stop {
    [[YPVideoPlayerManager shareInstance] stop];
    [self.videoItem saveLastPlayTime];
}

- (void)dealloc {
    [self.videoItem saveLastPlayTime];
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
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"视频已准备好播放");
        } else if (item.status == AVPlayerItemStatusFailed) {
            NSLog(@"视频播放失败: %@", item.error.localizedDescription);
        }
    } else if ([keyPath isEqualToString:@"error"]) {
        NSLog(@"视频播放发生错误: %@", item.error.localizedDescription);
    }
}

#pragma mark - notification

- (void)playerDidFinish:(NSNotification *)notification {
    
}

- (void)playerDidFail:(NSNotification *)notification {
    
}

- (void)playerDidStall:(NSNotification *)notification {
    
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

@end
