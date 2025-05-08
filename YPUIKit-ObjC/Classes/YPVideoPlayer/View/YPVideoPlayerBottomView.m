//
//  YPVideoPlayerBottomView.m
//  Pods
//
//  Created by Hansen on 2025/3/27.
//

#import "YPVideoPlayerBottomView.h"
#import "YPButton.h"
#import "UIColor+YPExtension.h"
#import "NSString+YPExtension.h"
#import "UIImage+YPExtension.h"
#import "YPVideoPlayerManager.h"

@interface YPVideoPlayerBottomView ()

@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, strong) UISlider *progressView;
@property (nonatomic, strong) YPButton *togglePlayButton;
@property (nonatomic, strong) YPButton *toggleRotateButton;

@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation YPVideoPlayerBottomView {
    BOOL _cachePlaying;
}

- (instancetype)init {
    if (self = [super init]) {
        _cachePlaying = NO;
        [self addSubview:self.progressLabel];
        [self addSubview:self.progressView];
        [self addSubview:self.togglePlayButton];
        [self addSubview:self.toggleRotateButton];
        [self addSubview:self.startTimeLabel];
        [self addSubview:self.endTimeLabel];
        // 更新试图
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateUI) name:kYPVideoPlayerManagerUpdateUIKey object:nil];
    }
    return self;
}

- (void)needUpdateUI {
    // 获取当前时间和总时长
    CGFloat currentTime = [YPVideoPlayerManager shareInstance].currentTime;
    CGFloat duration = [YPVideoPlayerManager shareInstance].duration;
    if (isnan(duration) || isinf(duration) || duration <= 0) {
        duration = 1.0;
    }
    if (isnan(currentTime) || isinf(currentTime) || currentTime < 0 || currentTime > duration) {
        currentTime = 0;
    }
    NSInteger currentMinutes = (NSInteger)(currentTime / 60);
    NSInteger currentSeconds = (NSInteger)(currentTime) % 60;
    NSInteger totalMinutes = (NSInteger)(duration / 60);
    NSInteger totalSeconds = (NSInteger)(duration) % 60;
    self.startTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)currentMinutes, (long)currentSeconds];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)totalMinutes, (long)totalSeconds];
    
    BOOL isPlaying = [YPVideoPlayerManager shareInstance].isPlaying;
    self.togglePlayButton.selected = isPlaying;
    
    self.progressView.minimumValue = 0;
    self.progressView.maximumValue = duration;
    self.progressView.value = currentTime;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGFloat space = 10.f;
    
    CGRect f1 = bounds;
    f1.size = CGSizeMake(25.f, 25.f);
    f1.origin.x = space;
    f1.origin.y = bounds.size.height - f1.size.height - space;
    self.togglePlayButton.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = CGSizeMake(25.f, 25.f);
    f2.origin.x = bounds.size.width - f2.size.width - space;
    f2.origin.y = bounds.size.height - f2.size.height - space;
    self.toggleRotateButton.frame = f2;
    
    CGRect f3 = bounds;
    f3.origin.x = CGRectGetMaxX(f1) + space;
    f3.size = CGSizeMake(35.f, 25.f);
    f3.origin.y = CGRectGetMidY(f1) - f3.size.height / 2.f;
    self.startTimeLabel.frame = f3;
    
    CGRect f4 = bounds;
    f4.size = CGSizeMake(35.f, 25.f);
    f4.origin.y = CGRectGetMidY(f1) - f4.size.height / 2.f;
    f4.origin.x = f2.origin.x - f4.size.width - space;
    self.endTimeLabel.frame = f4;
    
    CGRect f5 = bounds;
    f5.size.width = f4.origin.x - CGRectGetMaxX(f3) - space * 2;;
    f5.origin.x = CGRectGetMaxX(f3) + space;
    f5.size.height = 25.f;
    f5.origin.y = CGRectGetMidY(f1) - f5.size.height / 2.f;
    self.progressView.frame = f5;
}

- (void)togglePlayAction:(id)sender {
    if ([YPVideoPlayerManager shareInstance].isPlaying) {
        [[YPVideoPlayerManager shareInstance] pause];
    } else {
        [[YPVideoPlayerManager shareInstance] play];
    }
    [[YPVideoPlayerManager shareInstance] needUpdateUI];
}

- (void)toggleRotateAction:(id)sender {
    if (self.onRotateButtonTapped) {
        self.onRotateButtonTapped();
    }
}

- (void)progressSliderChanged:(UISlider *)slider {
    // 更新当前进度的显示
    CGFloat progress = slider.value;
    AVPlayer *player = [YPVideoPlayerManager shareInstance].player;
    if (player) {
        CMTime targetTime = CMTimeMakeWithSeconds(progress, NSEC_PER_SEC);
        [player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    }
}

// 拖动开始时的回调
- (void)progressSliderTouchDown:(UISlider *)slider {
    _cachePlaying = [YPVideoPlayerManager shareInstance].isPlaying;
    [[YPVideoPlayerManager shareInstance] pause];
}

// 拖动结束时的回调
- (void)progressSliderTouchEnd:(UISlider *)slider {
    if (_cachePlaying) {
        [[YPVideoPlayerManager shareInstance] play];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - getters | setters

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.backgroundColor = [UIColor yp_colorWithHexString:@"#FFFFFF"];
    }
    return _progressLabel;
}

- (YPButton *)togglePlayButton {
    if (!_togglePlayButton) {
        _togglePlayButton = [[YPButton alloc] init];
        UIImage *playImage = [UIImage imageNamed:@"start.png"];
        [_togglePlayButton setImage:playImage forState:UIControlStateNormal];
        UIImage *pauseImage = [UIImage imageNamed:@"end.png"];
        [_togglePlayButton setImage:pauseImage forState:UIControlStateSelected];
        _togglePlayButton.imageSize = CGSizeMake(25.f, 25.f);
        _togglePlayButton.tintColor = [UIColor yp_whiteColor];
        _togglePlayButton.adjustsImageWhenHighlighted = NO;
        [_togglePlayButton addTarget:self action:@selector(togglePlayAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _togglePlayButton;
}

- (YPButton *)toggleRotateButton {
    if (!_toggleRotateButton) {
        _toggleRotateButton = [[YPButton alloc] init];
        UIImage *landscape = [UIImage imageNamed:@"landscape.png"];
        [_toggleRotateButton setImage:landscape forState:UIControlStateNormal];
        _toggleRotateButton.imageSize = CGSizeMake(25.f, 25.f);
        _toggleRotateButton.tintColor = [UIColor yp_whiteColor];
        _toggleRotateButton.adjustsImageWhenHighlighted = NO;
        [_toggleRotateButton addTarget:self action:@selector(toggleRotateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleRotateButton;
}

- (UISlider *)progressView {
    if (!_progressView) {
        _progressView = [[UISlider alloc] init];
        _progressView.tintColor = [UIColor yp_colorWithHexString:@"#29BDBD"];
        UIImage *thumbImage = [UIImage systemImageNamed:@"circle.fill"];
        thumbImage = [thumbImage imageWithTintColor:[UIColor yp_colorWithHexString:@"#29BDBD"]];
        [_progressView setThumbImage:thumbImage forState:UIControlStateNormal];
        [_progressView addTarget:self action:@selector(progressSliderChanged:) forControlEvents:UIControlEventValueChanged];
        // 监听拖动开始
        [_progressView addTarget:self action:@selector(progressSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        // 监听拖动结束
        [_progressView addTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView addTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents:UIControlEventTouchUpOutside];
    }
    return _progressView;
}
 
- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [[UILabel alloc] init];
        _startTimeLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _startTimeLabel.textColor = [UIColor yp_whiteColor];
        _startTimeLabel.text = @"00:00";
        _startTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.font = [UIFont boldSystemFontOfSize:12.f];
        _endTimeLabel.textColor = [UIColor yp_whiteColor];
        _endTimeLabel.text = @"00:00";
        _endTimeLabel.textAlignment = NSTextAlignmentRight;
        _endTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _endTimeLabel;
}

@end
