//
//  YPVideoPlayerProgressView.m
//  Pods
//
//  Created by Hansen on 2025/3/31.
//

#import "YPVideoPlayerProgressView.h"
#import "UIColor+YPExtension.h"
#import "YPVideoPlayerManager.h"

@interface YPVideoPlayerProgressView ()

@property (nonatomic, strong) UILabel *progressLabel;

@end

@implementation YPVideoPlayerProgressView

- (instancetype)init {
    if (self = [super init]) {
        self.alpha = 0.f;
        [self addSubview:self.progressLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGRect f1 = bounds;
    self.progressLabel.frame = f1;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    CGFloat currentTime = value;
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
    NSString *fullText = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", (long)currentMinutes, (long)currentSeconds, (long)totalMinutes, (long)totalSeconds];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSRange slashRange = [fullText rangeOfString:@"/"];
    if (slashRange.location != NSNotFound) {
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor yp_colorWithHexString:@"#FFFFFF" withAlpha:0.8]
                                 range:NSMakeRange(slashRange.location, fullText.length - slashRange.location)];
    }
    self.progressLabel.attributedText = attributedString;
    self.alpha = 1.0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(hideView:) withObject:nil afterDelay:1.0];
}

- (void)hideView:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    }];
}

- (void)hideNow {
    self.alpha = 0.0;
}

#pragma mark - getters | setters

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] init];
        _progressLabel.font = [UIFont boldSystemFontOfSize:20.f];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.textColor = [UIColor yp_whiteColor];
    }
    return _progressLabel;
}

@end
