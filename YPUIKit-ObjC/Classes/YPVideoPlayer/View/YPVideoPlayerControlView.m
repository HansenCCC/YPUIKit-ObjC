//
//  YPVideoPlayerViewBottom.m
//  Pods
//
//  Created by Hansen on 2025/3/21.
//

#import "YPVideoPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+YPExtension.h"
#import "YPVideoPlayerManager.h"
#import "YPVideoPlayerBottomView.h"
#import "YPVideoPlayerTopView.h"
#import "UIColor+YPExtension.h"
#import "YPVideoPlayerBrightnessView.h"
#import "YPVideoPlayerSoundView.h"
#import "YPVideoPlayerProgressView.h"
#import "YPShakeManager.h"

@interface YPVideoPlayerControlView ()

@property (nonatomic, strong) UITapGestureRecognizer *clickTapRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) BOOL isProgressControl;       // 是否在控制进度
@property (nonatomic, assign) BOOL isBrightnessControl;     // 是否在控制亮度
@property (nonatomic, assign) BOOL isVolumeControl;         // 是否在控制音量
@property (nonatomic, assign) CGPoint panStartPoint;        // 手势开始时的位置
@property (nonatomic, assign) CGPoint offsetStartPoint;     // 实际开始计算偏移量位置【用于声音和亮度】
@property (nonatomic, assign) BOOL hasMovedThreshold;       // 是否已滑动超过一定距离

@property (nonatomic, strong) YPVideoPlayerTopView *topView;
@property (nonatomic, strong) YPVideoPlayerBottomView *bottomView;

@property (nonatomic, strong) YPVideoPlayerBrightnessView *brightnessView;
@property (nonatomic, strong) YPVideoPlayerSoundView *soundView;
@property (nonatomic, strong) YPVideoPlayerProgressView *progressView;
@property (nonatomic, assign) BOOL isShowControl;// 是否是展示控制

@end

@implementation YPVideoPlayerControlView {
    UISlider *_volumeSlider;
    CGFloat _startBrightness;
    CGFloat _startVolume;
    CGFloat _startProgress;
    BOOL _cachePlaying;
}

- (instancetype)init {
    if (self = [super init]) {
        self.isShowControl = NO;
        [self setupSubviews];
        [self setupGesture];
        [self updateSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 监听系统声音
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-500, -500, 0.f, 0.f)];
    _volumeSlider = (UISlider *)[volumeView yp_findSubviewsOfClass:[UISlider class]].firstObject;
    if (_volumeSlider) {
        [_volumeSlider addTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    [self addSubview:_volumeSlider];
    
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    
    [self addSubview:self.brightnessView];
    [self addSubview:self.soundView];
    [self addSubview:self.progressView];
}

- (void)updateSubviews {
    self.topView.hidden = !self.isShowControl;
    self.bottomView.hidden = !self.isShowControl;
}

- (void)setupGesture {
    self.clickTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickTap:)];
    self.clickTapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.clickTapRecognizer];
    
    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:self.doubleTapRecognizer];
    [self.clickTapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (void)volumeSliderValueChanged:(UISlider *)slider {
    [[YPShakeManager shareInstance] lightShake];
    [YPVideoPlayerManager shareInstance].volume = slider.value;
    self.soundView.value = _volumeSlider.value;
    [self.brightnessView hideNow];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect f1 = bounds;
    f1.size.height = 60.f;
    self.topView.frame = f1;
    
    CGRect f2 = bounds;
    f2.size.height = 60.f;
    f2.origin.y = bounds.size.height - f2.size.height;
    self.bottomView.frame = f2;
    
    _volumeSlider.alpha = 0.01;
    _volumeSlider.frame = CGRectMake(-100.f, -100.f, 0.f, 0.f);
    
    CGRect f3 = bounds;
    self.brightnessView.frame = f3;
    
    CGRect f4 = bounds;
    self.soundView.frame = f4;
    
    CGRect f5 = bounds;
    self.progressView.frame = f5;
}

- (void)dealloc {
    if (_volumeSlider) {
        [_volumeSlider removeTarget:self action:@selector(volumeSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark - Gesture

- (void)handleClickTap:(UITapGestureRecognizer *)gesture {
    [[YPShakeManager shareInstance] mediumShake];
    self.isShowControl = !self.isShowControl;
    [self updateSubviews];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    [[YPShakeManager shareInstance] mediumShake];
    if ([YPVideoPlayerManager shareInstance].isPlaying) {
        [[YPVideoPlayerManager shareInstance] pause];
    } else {
        [[YPVideoPlayerManager shareInstance] play];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    [[YPShakeManager shareInstance] lightShake];
    CGPoint translation = [recognizer translationInView:self];
    CGPoint location = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = location;
        self.hasMovedThreshold = NO;
    }
    if (!self.hasMovedThreshold) {
        CGFloat threshold = 30.f;
        CGFloat deltaX = fabs(location.x - self.panStartPoint.x);
        CGFloat deltaY = fabs(location.y - self.panStartPoint.y);
        if (deltaY > threshold) {
            [self determineControlTypeWithLocation:location];
            self.hasMovedThreshold = YES;
            _startBrightness = [UIScreen mainScreen].brightness;
            _startVolume = _volumeSlider.value;
            self.offsetStartPoint = translation;
        } else if (deltaX > threshold) {
            self.isProgressControl = YES;
            self.hasMovedThreshold = YES;
            _cachePlaying = [YPVideoPlayerManager shareInstance].isPlaying;
            if (_cachePlaying) {
                [[YPVideoPlayerManager shareInstance] pause];
            }
            _startProgress = [YPVideoPlayerManager shareInstance].currentTime;
            self.offsetStartPoint = translation;
        }
    }
    // 根据手势状态和滑动方向处理进度、亮度、音量
    if (self.isProgressControl) {
        // 只处理进度
        [self progressWithTranslation:translation];
    } else if (self.isBrightnessControl) {
        // 只处理亮度
        [self brightnessWithTranslation:translation];
    } else if (self.isVolumeControl) {
        // 只处理音量
        [self volumeWithTranslation:translation];
    }
    
    // 手势结束时
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.isProgressControl = NO;
        self.isBrightnessControl = NO;
        self.isVolumeControl = NO;
        self.offsetStartPoint = CGPointZero;
        self.panStartPoint = CGPointZero;
        if (_cachePlaying) {
            [[YPVideoPlayerManager shareInstance] play];
        }
    }
}

// 根据滑动位置确定操作类型
- (void)determineControlTypeWithLocation:(CGPoint)location {
    CGFloat screenWidth = self.bounds.size.width;
    if (location.x < screenWidth / 2) {
        // 如果在左半边，控制亮度
        self.isBrightnessControl = YES;
    } else {
        // 如果在右半边，控制音量
        self.isVolumeControl = YES;
    }
}

// 进度增减
- (void)progressWithTranslation:(CGPoint)translation {
    CGFloat deltaX = -(self.offsetStartPoint.x - translation.x);
    CGFloat duration = [YPVideoPlayerManager shareInstance].duration;
    CGFloat progressChange = deltaX / 500.0 * duration;
    CGFloat newProgress = _startProgress + progressChange;
    newProgress = MIN(MAX(newProgress, 0.0), duration);
    CGFloat progress = newProgress;
    AVPlayer *player = [YPVideoPlayerManager shareInstance].player;
    if (player) {
        CMTime targetTime = CMTimeMakeWithSeconds(progress, NSEC_PER_SEC);
        [player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
    self.progressView.value = progress;
    [self.soundView hideNow];
    [self.brightnessView hideNow];
}

// 亮度增减
- (void)brightnessWithTranslation:(CGPoint)translation {
    CGFloat deltaY = self.offsetStartPoint.y - translation.y;
    CGFloat brightnessChange = deltaY / 500.0;
    CGFloat newBrightness = _startBrightness + brightnessChange;
    newBrightness = MIN(MAX(newBrightness, 0.0), 1.0);
    [UIScreen mainScreen].brightness = newBrightness;
    self.brightnessView.value = [UIScreen mainScreen].brightness;
    [self.soundView hideNow];
    [self.progressView hideNow];
}

// 音量增减
- (void)volumeWithTranslation:(CGPoint)translation {
    if (_volumeSlider) {
        CGFloat deltaY = self.offsetStartPoint.y - translation.y;
        CGFloat volumeChange = deltaY / 500.0;
        CGFloat newVolume = _startVolume + volumeChange;
        newVolume = MIN(MAX(newVolume, 0.0), 1.0);
        _volumeSlider.value = newVolume;
        self.soundView.value = _volumeSlider.value;
        [self.brightnessView hideNow];
        [self.progressView hideNow];
    }
}

#pragma mark - getters | setters

- (YPVideoPlayerTopView *)topView {
    if (!_topView) {
        _topView = [[YPVideoPlayerTopView alloc] init];
    }
    return _topView;
}

- (YPVideoPlayerBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[YPVideoPlayerBottomView alloc] init];
    }
    return _bottomView;
}

- (YPVideoPlayerBrightnessView *)brightnessView {
    if (!_brightnessView) {
        _brightnessView = [[YPVideoPlayerBrightnessView alloc] init];
    }
    return _brightnessView;
}

- (YPVideoPlayerSoundView *)soundView {
    if (!_soundView) {
        _soundView = [[YPVideoPlayerSoundView alloc] init];
    }
    return _soundView;
}

- (YPVideoPlayerProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[YPVideoPlayerProgressView alloc] init];
    }
    return _progressView;
}

- (void)setOnRotateButtonTapped:(void (^)(void))onRotateButtonTapped {
    self.bottomView.onRotateButtonTapped = onRotateButtonTapped;
}

- (void)setOnBackButtonTapped:(void (^)(void))onBackButtonTapped {
    self.topView.onBackButtonTapped = onBackButtonTapped;
}

@end
