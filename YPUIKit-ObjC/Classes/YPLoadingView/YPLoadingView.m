//
//  YPLoadingView.m
//  FanRabbit
//
//  Created by 程恒盛 on 2019/5/27.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "YPLoadingView.h"
#import "UIColor+YPExtension.h"
#import "UILabel+YPExtension.h"

@interface YPLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation YPLoadingView

- (instancetype)init {
    if (self = [super init]) {
        
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.77];
        [self addSubview:_backgroundView];
        
        _titleLabel = [UILabel yp_labelWithFont:[UIFont systemFontOfSize:16.f] textColor:[UIColor yp_whiteColor]];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundView addSubview:_titleLabel];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.backgroundColor = [UIColor clearColor];
        _indicator.color = [UIColor grayColor];
        [_indicator startAnimating];
        [_backgroundView addSubview:_indicator];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.frame;
    
    CGRect f1 = bounds;
    f1.size = [self.indicator sizeThatFits:CGSizeZero];
    
    CGFloat maxWidth = 200.f;
    CGFloat maxHeight = 0.f;
    CGFloat minWidth = 85.f;
    if (self.titleLabel.text.length > 0) {
        CGRect f2 = bounds;
        f2.size = [self.titleLabel sizeThatFits:CGSizeMake(maxWidth - 20.f, 0)];
        maxWidth = MAX(f2.size.width + 20.f, minWidth);
        f2.size.width = maxWidth - 20.f;
        
        self.titleLabel.hidden = NO;
        
        f1.origin.x = (maxWidth - f1.size.width) / 2.f;
        f1.origin.y = 15.f;
        self.indicator.frame = f1;
        
        f2.origin.y = CGRectGetMaxY(f1) + 8.f;
        f2.origin.x = (maxWidth - f2.size.width) / 2.f;
        self.titleLabel.frame = f2;
        
        maxHeight += CGRectGetMaxY(f2) + 15.f;
    } else {
        maxWidth = minWidth;
        maxHeight = minWidth;
        self.titleLabel.hidden = YES;
        f1.origin.x = (maxWidth - f1.size.width) / 2.f;
        f1.origin.y = (maxHeight - f1.size.height) / 2.f;
        self.indicator.frame = f1;
    }
    CGRect f3 = self.backgroundView.bounds;
    f3.size.width = maxWidth;
    f3.size.height = maxHeight;
    f3.origin.x = (bounds.size.width - f3.size.width) / 2.f;
    f3.origin.y = (bounds.size.height - f3.size.height) / 2.f;
    self.backgroundView.frame = f3;
    self.backgroundView.layer.cornerRadius = 8.f;
    
}

+ (YPLoadingView *)showWithView:(UIView *)view translucent:(BOOL)translucent userInteractionEnabled:(BOOL)userInteractionEnabled {
    [YPLoadingView hideWithView:view];
    YPLoadingView *loadingView = [YPLoadingView new];
    loadingView.frame = [UIScreen mainScreen].bounds;
#if ISPAD
    //to do
#else
//    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
//    if ([vc.navigationController visibleViewController] && vc.navigationController.navigationBarHidden) {
//        CGRect frame = loadingView.frame;
//        frame.origin.y = 0;
//        loadingView.frame = frame;
//    }
#endif
    loadingView.backgroundColor = translucent ? [UIColor clearColor]:[UIColor whiteColor];
    loadingView.userInteractionEnabled = !userInteractionEnabled;
    [view addSubview:loadingView];
    [view bringSubviewToFront:loadingView];
    return loadingView;
}

+ (void)hideWithView:(UIView *)view {
    for (UIView *v in view.subviews) {
        if ([v isKindOfClass:[YPLoadingView class]]) {
            for (UIView *indicator in v.subviews) {
                if ([indicator isKindOfClass:[UIActivityIndicatorView class]]) {
                    UIActivityIndicatorView *indic = (UIActivityIndicatorView *)indicator;
                    [indic stopAnimating];
                }
            }
            v.hidden = YES;
            [v removeFromSuperview];
        }
    }
}

+ (void)showLoading {
    [self hideLoading];
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [YPLoadingView showWithView:window translucent:YES userInteractionEnabled:NO];
}

+ (void)showLoading:(NSString *)loadingText {
    [self hideLoading];
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    YPLoadingView *loadingView = [YPLoadingView showWithView:window translucent:YES userInteractionEnabled:NO];
    loadingView.titleLabel.text = loadingText;
    [loadingView layoutSubviews];
}

+ (void)hideLoading {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [YPLoadingView hideWithView:window];
}

@end
