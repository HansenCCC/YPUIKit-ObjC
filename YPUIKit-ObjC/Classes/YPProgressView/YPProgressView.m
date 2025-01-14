//
//  YPProgressView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/1/14.
//

#import "YPProgressView.h"
#import "UIColor+YPExtension.h"
#import "UILabel+YPExtension.h"

@interface  YPProgressView ()

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YPProgressView

- (instancetype)init {
    if (self = [super init]) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.77];
        [self addSubview:_backgroundView];
        
        _titleLabel = [UILabel yp_labelWithFont:[UIFont systemFontOfSize:16.f] textColor:[UIColor yp_whiteColor]];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundView addSubview:_titleLabel];
        
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [UIColor yp_whiteColor];
        _progressView.progressTintColor = [UIColor yp_blueColor];
        _progressView.progress = 0.5;
        [_backgroundView addSubview:_progressView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.frame;
    CGRect f1 = bounds;
    f1.size = [self.progressView sizeThatFits:CGSizeZero];
    f1.size.width = MIN(500.f, bounds.size.width - 100.f);
    f1.origin.x = 10.f;
    f1.origin.y = 10.f;
    
    CGRect f2 = CGRectZero;
    if (self.titleLabel.text.length > 0) {
        f2.size.width = f1.size.width;
        f2.origin.y = CGRectGetMaxY(f1) + 10.f;
        f2.origin.x = f1.origin.x;
        f2.size.height = [self.titleLabel sizeThatFits:CGSizeMake(f2.size.width, 0)].height;
    } else {
        f2.origin.y = CGRectGetMaxY(f1);
    }
    self.progressView.frame = f1;
    self.titleLabel.frame = f2;
    
    CGRect f3 = bounds;
    f3.size.width = f1.size.width + f1.origin.x * 2;
    f3.size.height = CGRectGetMaxY(f2) + 10.f;
    f3.origin.x = (bounds.size.width - f3.size.width) / 2.f;
    f3.origin.y = (bounds.size.height - f3.size.height) / 2.f;
    self.backgroundView.frame = f3;
    self.backgroundView.layer.cornerRadius = 8.f;
}

+ (YPProgressView *)showProgressWithView:(UIView *)view translucent:(BOOL)translucent userInteractionEnabled:(BOOL)userInteractionEnabled {
    YPProgressView *progressView = nil;
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[YPProgressView class]]) {
            progressView = (YPProgressView *)v;
        }
    }
    if (progressView == nil) {
        progressView = [[YPProgressView alloc] init];
        progressView.frame = [UIScreen mainScreen].bounds;
        progressView.backgroundColor = translucent ? [UIColor clearColor]:[UIColor whiteColor];
        progressView.userInteractionEnabled = !userInteractionEnabled;
        [view addSubview:progressView];
    }
    [view bringSubviewToFront:progressView];
    return progressView;
}

+ (void)hideWithView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[YPProgressView class]]) {
            v.hidden = YES;
            [v removeFromSuperview];
        }
    }
}

+ (void)showProgress:(CGFloat)progress {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self showProgressWithView:window translucent:YES userInteractionEnabled:NO];
}

+ (void)showProgress:(CGFloat)progress text:(NSString *)text {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    YPProgressView *progressView = [self showProgressWithView:window translucent:YES userInteractionEnabled:NO];
    progressView.progressView.progress = progress;
    progressView.titleLabel.text = text;
    [progressView layoutSubviews];
}

+ (void)hideProgress {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [YPProgressView hideWithView:window];
}

@end
