//
//  YPVideoPlayerSoundView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/3/30.
//

#import "YPVideoPlayerSoundView.h"
#import "UIColor+YPExtension.h"

@interface YPVideoPlayerSoundView ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation YPVideoPlayerSoundView

- (instancetype)init {
    if (self = [super init]) {
        self.alpha = 0.f;
        [self addSubview:self.progressView];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGRect f1 = bounds;
    f1.origin.y = 20.f;
    f1.size = [self.progressView sizeThatFits:CGSizeZero];
    f1.size.width = bounds.size.width / 3 * 2;
    f1.origin.x = (bounds.size.width - f1.size.width) / 2.f;
    self.progressView.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = CGSizeMake(80.f, 80.f);
    f2.origin.x = (bounds.size.width - f2.size.width) / 2.f;
    f2.origin.y = (bounds.size.height - f2.size.height) / 2.f;
    self.imageView.frame = f2;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    self.progressView.progress = value;
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

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progress = 0.5;
        _progressView.tintColor = [UIColor yp_whiteColor];
    }
    return _progressView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage systemImageNamed:@"speaker.wave.2.fill"];
        _imageView.tintColor = [UIColor yp_whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
