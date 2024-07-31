//
//  YPAlertView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/8/2.
//

#import "YPAlertView.h"
#import "UIColor+YPExtension.h"

static CGFloat const kYPAlertDefaultDuration = 1.5;

@interface YPAlertView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, assign) NSInteger showCount;

@end

@implementation YPAlertView

+ (instancetype)shareInstance {
    static YPAlertView *alert = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alert = [[YPAlertView alloc] initWithPrivate];
    });
    return alert;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Can't instance!" reason:@"Use class methods!" userInfo:nil];
}

- (instancetype)initWithPrivate {
    YPAlertView *alert = [super init];
    alert.userInteractionEnabled = NO;
    alert.showCount = 0;
    if (alert) {
        [self setupSubviews];
    }
    return alert;
}

- (void)setupSubviews {
    [self addSubview:self.backgroundView];
    [self addSubview:self.alertLabel];
}

- (void)showAlertText:(NSString *)text inWindow:(UIWindow *)window fadeTime:(float)time complete:(void (^)())complete {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *keyWindow;
        self.showCount ++;
        if (window) {
            keyWindow = window;
        } else {
            keyWindow = [UIApplication sharedApplication].keyWindow;
            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(window)]) {
                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                if (window) {
                    keyWindow = window;
                }
            }
        }
        
        if (self.showCount <= 1) {
            self.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            [UIView animateWithDuration:0.3 animations:^{
                self.transform = CGAffineTransformIdentity;
                self.alpha = 1;
            }];
        }
        
        [keyWindow insertSubview:self atIndex:keyWindow.subviews.count];
        self.transform = CGAffineTransformIdentity;
        self.frame = keyWindow.bounds;
        self.alertLabel.text = text;
        [self alertLayoutSubviews];
        
        [self performSelector:@selector(alertFade:) withObject:complete afterDelay:time];
    });
}

- (void)alertFade:(void (^)())complete {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showCount --;
        if (self.showCount > 0) {
            if (complete) {
                complete();
            }
            return;
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0;
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (complete) {
                complete();
            }
        }];
    });
}

- (void)alertLayoutSubviews {
    CGRect bounds = self.bounds;
    CGRect f1 = bounds;
    f1.size = [self.alertLabel sizeThatFits:CGSizeMake(bounds.size.width - 50.f, 0)];
    f1.size.width += 15;
    f1.size.height += 15;
    f1.origin.x = (bounds.size.width - f1.size.width)/2.f;
    f1.origin.y = (bounds.size.height - f1.size.height)/2.f;
    self.alertLabel.frame = f1;
    
    self.backgroundView.frame = f1;
}

#pragma mark - Public

+ (void)alertText:(NSString *)text {
    [self alertText:text inWindow:nil duration:kYPAlertDefaultDuration complete:nil];
}

+ (void)alertText:(NSString *)text complete:(void (^)())complete {
    [self alertText:text inWindow:nil duration:kYPAlertDefaultDuration complete:complete];
}

+ (void)alertText:(NSString *)text duration:(CGFloat)duration {
    [self alertText:text inWindow:nil duration:duration complete:nil];
}

+ (void)alertText:(NSString *)text duration:(CGFloat)duration complete:(void (^)())complete {
    [self alertText:text inWindow:nil duration:duration complete:complete];
}

+ (void)alertText:(NSString *)text inWindow:(UIWindow *)window duration:(CGFloat)duration complete:(void (^)())complete {
    [[YPAlertView shareInstance] showAlertText:text inWindow:window fadeTime:duration complete:complete];
}

#pragma mark - getters | setters

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor yp_blackColor];
        _backgroundView.alpha = 0.77;
        _backgroundView.layer.cornerRadius = 8;
    }
    return _backgroundView;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc] init];
        _alertLabel.textColor = [UIColor yp_whiteColor];
        _alertLabel.font = [UIFont systemFontOfSize:17];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.userInteractionEnabled = NO;
        _alertLabel.numberOfLines = 0;
    }
    return _alertLabel;
}

@end
