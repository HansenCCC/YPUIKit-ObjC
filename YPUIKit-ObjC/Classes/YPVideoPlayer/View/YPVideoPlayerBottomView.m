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
#import "YPShakeManager.h"
#import "UIImage+YPExtension.h"
#import "YPKitDefines.h"
#import "UIView+YPExtension.h"

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
    f1.size = CGSizeMake(45.f, 45.f);
    f1.origin.x = space;
    f1.origin.y = 5.f;
    self.togglePlayButton.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = CGSizeMake(45.f, 45.f);
    f2.origin.x = bounds.size.width - f2.size.width - space;
    f2.origin.y = CGRectGetMidY(f1) - f2.size.height / 2.f;
    self.toggleRotateButton.frame = f2;
    
    CGRect f3 = bounds;
    f3.origin.x = CGRectGetMaxX(f1);
    f3.size = CGSizeMake(35.f, 25.f);
    f3.origin.y = CGRectGetMidY(f1) - f3.size.height / 2.f;
    self.startTimeLabel.frame = f3;
    
    CGRect f4 = bounds;
    f4.size = CGSizeMake(35.f, 25.f);
    f4.origin.y = CGRectGetMidY(f1) - f4.size.height / 2.f;
    f4.origin.x = f2.origin.x - f4.size.width;
    self.endTimeLabel.frame = f4;
    
    CGRect f5 = bounds;
    f5.size.width = f4.origin.x - CGRectGetMaxX(f3) - space * 2;;
    f5.origin.x = CGRectGetMaxX(f3) + space;
    f5.size.height = 25.f;
    f5.origin.y = CGRectGetMidY(f1) - f5.size.height / 2.f;
    self.progressView.frame = f5;
    
    [self yp_addGradientColors:@[
        [UIColor yp_colorWithHexString:@"#000000" withAlpha:0],
        [UIColor yp_colorWithHexString:@"#000000" withAlpha:1],]
                     locations:@[@(0), @(1.0f)]
                    startPoint:CGPointMake(0.5, 0)
                      endPoint:CGPointMake(0.5, 1)
    ];
}

- (void)togglePlayAction:(id)sender {
    [[YPShakeManager shareInstance] mediumShake];
    if ([YPVideoPlayerManager shareInstance].isPlaying) {
        [[YPVideoPlayerManager shareInstance] pause];
    } else {
        [[YPVideoPlayerManager shareInstance] play];
    }
    [[YPVideoPlayerManager shareInstance] needUpdateUI];
}

- (void)toggleRotateAction:(id)sender {
    [[YPShakeManager shareInstance] mediumShake];
    if (self.onRotateButtonTapped) {
        self.onRotateButtonTapped();
    }
}

- (void)progressSliderChanged:(UISlider *)slider {
    [[YPShakeManager shareInstance] lightShake];
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
    [[YPShakeManager shareInstance] mediumShake];
    _cachePlaying = [YPVideoPlayerManager shareInstance].isPlaying;
    [[YPVideoPlayerManager shareInstance] pause];
}

// 拖动结束时的回调
- (void)progressSliderTouchEnd:(UISlider *)slider {
    [[YPShakeManager shareInstance] mediumShake];
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
        UIImage *playImage = [UIImage yp_imageWithBase64String:[self startBase64Image]];
        [_togglePlayButton setImage:playImage forState:UIControlStateNormal];
        UIImage *pauseImage = [UIImage yp_imageWithBase64String:[self stopBase64Image]];
        [_togglePlayButton setImage:pauseImage forState:UIControlStateSelected];
        _togglePlayButton.imageSize = CGSizeMake(25.f, 25.f);
        _togglePlayButton.tintColor = [UIColor yp_whiteColor];
        _togglePlayButton.backgroundColor = [UIColor yp_clearColor];
        _togglePlayButton.adjustsImageWhenHighlighted = NO;
        [_togglePlayButton addTarget:self action:@selector(togglePlayAction:) forControlEvents:UIControlEventTouchUpInside];
        _togglePlayButton.backgroundColor = [UIColor yp_colorWithHexString:@"#000000" withAlpha:0.01];
    }
    return _togglePlayButton;
}

- (YPButton *)toggleRotateButton {
    if (!_toggleRotateButton) {
        _toggleRotateButton = [[YPButton alloc] init];
        UIImage *landscape = [UIImage yp_imageWithBase64String:[self landscapeBase64Image]];
        [_toggleRotateButton setImage:landscape forState:UIControlStateNormal];
        _toggleRotateButton.imageSize = CGSizeMake(25.f, 25.f);
        _toggleRotateButton.backgroundColor = [UIColor yp_clearColor];
        _toggleRotateButton.tintColor = [UIColor yp_whiteColor];
        _toggleRotateButton.adjustsImageWhenHighlighted = NO;
        [_toggleRotateButton addTarget:self action:@selector(toggleRotateAction:) forControlEvents:UIControlEventTouchUpInside];
        _toggleRotateButton.backgroundColor = [UIColor yp_colorWithHexString:@"#000000" withAlpha:0.01];
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

#pragma mark - base64images

- (NSString *)stopBase64Image {
    return @"iVBORw0KGgoAAAANSUhEUgAAAE4AAABOCAYAAACOqiAdAAAAAXNSR0IArs4c6QAAAIRlWElmTU0AKgAAAAgABQESAAMAAAABAAEAAAEaAAUAAAABAAAASgEbAAUAAAABAAAAUgEoAAMAAAABAAIAAIdpAAQAAAABAAAAWgAAAAAAAADYAAAAAQAAANgAAAABAAOgAQADAAAAAQABAACgAgAEAAAAAQAAAE6gAwAEAAAAAQAAAE4AAAAA9XxhoAAAAAlwSFlzAAAhOAAAITgBRZYxYAAAApxpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDYuMC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIj4KICAgICAgICAgPHRpZmY6WFJlc29sdXRpb24+MjE2PC90aWZmOlhSZXNvbHV0aW9uPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj4yMTY8L3RpZmY6WVJlc29sdXRpb24+CiAgICAgICAgIDx0aWZmOk9yaWVudGF0aW9uPjE8L3RpZmY6T3JpZW50YXRpb24+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDxleGlmOlBpeGVsWURpbWVuc2lvbj43ODwvZXhpZjpQaXhlbFlEaW1lbnNpb24+CiAgICAgICAgIDxleGlmOlBpeGVsWERpbWVuc2lvbj43ODwvZXhpZjpQaXhlbFhEaW1lbnNpb24+CiAgICAgIDwvcmRmOkRlc2NyaXB0aW9uPgogICA8L3JkZjpSREY+CjwveDp4bXBtZXRhPgrAVD7GAAABfElEQVR4Ae3cQRHCMBRF0Q4KkIAEJCABZ8VBkYIDUFAkIAF+WLApIZ2bgWaY+5dtX0gOb52ucxRQQAEFFFBAAQUUUKAssI7p+/5wi7kXJn0zDMNxE1NemX3R2n6ypxjH8Vrwmrw+x2QXrHzR2n7eHmcfM1GZ+WAX83bRiodL7GdF9ruNIbmU+QbcEvtBcBTtn3LCwX9TOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZOOGgAIzZuF/CnWLg73WXGJrN5VrbT26fz+fp8pWZV428PkuXqnxctOJla/vJHiVd95Ou/Zl7RVC6Tihd45NdsPJFa/upPI5xBRRQQAEFFFBAAQXaEngAorcR+QSUDrgAAAAASUVORK5CYII=";
}

- (NSString *)startBase64Image {
    return @"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";
}

- (NSString *)landscapeBase64Image {
    return @"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";
}

@end
