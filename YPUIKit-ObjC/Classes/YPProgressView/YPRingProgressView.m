//
//  YPRingProgressView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/1/15.
//

#import "YPRingProgressView.h"
#import "UIColor+YPExtension.h"
#import "UILabel+YPExtension.h"

@interface YPRingProgressView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *trackLayer;
@property (nonatomic, assign) CGFloat progress;

@end

@implementation YPRingProgressView

- (instancetype)init {
    if (self = [super init]) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.77];
        [self addSubview:_backgroundView];

        _titleLabel = [UILabel yp_labelWithFont:[UIFont systemFontOfSize:16.f] textColor:[UIColor yp_whiteColor]];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundView addSubview:_titleLabel];
        
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.strokeColor = [UIColor yp_whiteColor].CGColor;
        _trackLayer.fillColor = [UIColor clearColor].CGColor;
        _trackLayer.lineWidth = 5.0;
        _trackLayer.lineCap = kCALineCapRound;
        [_backgroundView.layer addSublayer:_trackLayer];
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor yp_blueColor].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = 5.0;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeStart = 0.0;
        _progressLayer.strokeEnd = 0.0;
        [_backgroundView.layer addSublayer:_progressLayer];

        _progress = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.frame;
    CGRect f1 = bounds;
    f1.size = CGSizeMake(100.f, 100.f);
    f1.origin.x = 10.f;
    f1.origin.y = 10.f;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(f1.size.width / 2, f1.size.height / 2) 
                                                              radius:f1.size.width / 2.f
                                                          startAngle:-M_PI / 2
                                                            endAngle:M_PI / 2 * 3
                                                           clockwise:YES];
    
    self.trackLayer.path = circlePath.CGPath;
    self.progressLayer.path = circlePath.CGPath;
    self.progressLayer.frame = f1;
    self.trackLayer.frame = f1;
    
    f1 = CGRectInset(f1, 10.f, 10.f);
    
    self.titleLabel.frame = f1;
    
    CGRect f2 = f1;
    f2.size.width = f1.size.width + f1.origin.x * 2;
    f2.size.height = f2.size.width;
    f2.origin.x = (bounds.size.width - f2.size.width) / 2.f;
    f2.origin.y = (bounds.size.height - f2.size.height) / 2.f;
    self.backgroundView.frame = f2;
    self.backgroundView.layer.cornerRadius = 8.f;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    _progressLayer.strokeEnd = _progress;
}

+ (YPRingProgressView *)showProgressWithView:(UIView *)view translucent:(BOOL)translucent userInteractionEnabled:(BOOL)userInteractionEnabled {
    YPRingProgressView *progressView = nil;
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[YPRingProgressView class]]) {
            progressView = (YPRingProgressView *)v;
        }
    }
    if (progressView == nil) {
        progressView = [[YPRingProgressView alloc] init];
        progressView.frame = [UIScreen mainScreen].bounds;
        progressView.backgroundColor = translucent ? [UIColor clearColor] : [UIColor whiteColor];
        progressView.userInteractionEnabled = !userInteractionEnabled;
        [view addSubview:progressView];
    }
    [view bringSubviewToFront:progressView];
    return progressView;
}

+ (void)hideWithView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[YPRingProgressView class]]) {
            v.hidden = YES;
            [v removeFromSuperview];
        }
    }
}

+ (void)showProgress:(CGFloat)progress {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    YPRingProgressView *progressView = [self showProgressWithView:window translucent:YES userInteractionEnabled:NO];
    progressView.progress = progress;
    [progressView setNeedsLayout];
}

+ (void)showProgress:(CGFloat)progress text:(NSString *)text {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    YPRingProgressView *progressView = [self showProgressWithView:window translucent:YES userInteractionEnabled:NO];
    progressView.progress = progress;
    progressView.titleLabel.text = text;
    [progressView setNeedsLayout];
}

+ (void)hideProgress {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self hideWithView:window];
}

@end
