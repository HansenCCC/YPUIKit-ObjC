//
//  YPPopupController.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/9/1.
//

#import "YPPopupController.h"
#import "UIColor+YPExtension.h"
#import "YPKitDefines.h"
#import "YPPopupAnimatedTransitioning.h"

@interface YPPopupController ()

@property (nonatomic, assign) YPPopupControllerStyle style;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) YPPopupAnimatedTransitioning *animatedTransitioning;

@end

@implementation YPPopupController

+ (instancetype)popupControllerWithStyle:(YPPopupControllerStyle)style {
    YPPopupController *popup = [[self alloc] initPrivate];
    popup.style = style;
    popup.isEnableTouchMove = YES;
    popup.transitioningDelegate = popup.animatedTransitioning;
    return popup;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"YPPopupController"
                                   reason:@"Use [YPPopupController popupControllerWithStyle:] initialize"
                                 userInfo:nil];
}

- (instancetype)initPrivate {
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubviews];
    [self popupLayoutSubviews];
    [self launchAppearViewAnimation:nil];
}

- (void)setupSubviews {
    self.backgroundView.backgroundColor = [[UIColor yp_blackColor] yp_alpha:0.4];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
}

- (void)popupLayoutSubviews {
    CGRect bounds = self.view.bounds;
    CGRect f1 = bounds;
    self.backgroundView.frame = f1;
    if (self.style == YPPopupControllerStyleMiddle) {
        f1.origin.x = 40.f;
        f1.size.width = bounds.size.width - f1.origin.x * 2;
        f1.size.height = f1.size.width;
        f1.origin.y = (bounds.size.height - f1.size.height) / 2.f;
    } else if (self.style == YPPopupControllerStyleBottom) {
        f1.origin.x = 0;
        f1.size.height = f1.size.height / 2.f;
        f1.origin.y = bounds.size.height - f1.size.height;
    }
    self.contentView.frame = f1;
}

- (void)launchAppearViewAnimation:(void(^)(void))completion {
    self.contentView.alpha = 0.f;
    self.backgroundView.alpha = 0.f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.1, 0.1);
        switch (self.style) {
            case YPPopupControllerStyleMiddle: {
                transform = CGAffineTransformMakeScale(0.1, 0.1);
            }
                break;
            case YPPopupControllerStyleBottom: {
                CGFloat height = CGRectGetHeight(self.contentView.frame);
                transform = CGAffineTransformMakeTranslation(0, height);
            }
                break;
            default:
                break;
        }
        
        self.contentView.transform = transform;
        
        CGFloat duration = 0.f;
        if (self.animatedTransitioning.isPresentedWithAnimation) {
            duration = 0.3;
        }
        
        [UIView animateWithDuration:duration animations:^{
            self.contentView.alpha = 1.0f;
            self.backgroundView.alpha = 1.f;
            self.contentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
    });
}

- (void)launchDisappearViewAnimation:(void(^)(void))completion {
    self.contentView.alpha = 1.f;
    self.backgroundView.alpha = 1.f;
    switch (self.style) {
        case YPPopupControllerStyleMiddle: {
            CGAffineTransform transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.contentView.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundView.alpha = 0.f;
                self.contentView.alpha = 0.0f;
                self.contentView.transform = transform;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
        case YPPopupControllerStyleBottom: {
            CGFloat height = CGRectGetHeight(self.contentView.frame);
            CGRect frame = self.contentView.frame;
            frame.origin.y += height;
            [UIView animateWithDuration:0.3 animations:^{
                self.backgroundView.alpha = 0.f;
                self.contentView.alpha = 0.0f;
                self.contentView.frame = frame;
            } completion:^(BOOL finished) {
                if (completion) {
                    completion();
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    if (flag) {
        [self launchDisappearViewAnimation:^{
            [super dismissViewControllerAnimated:NO completion:completion];
        }];
    } else {
        [super dismissViewControllerAnimated:NO completion:completion];
    }
}

#pragma mark - action

- (void)touchMoveAction {
    if (self.isEnableTouchMove) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - getters | setters

- (YPPopupAnimatedTransitioning *)animatedTransitioning {
    if (!_animatedTransitioning) {
        _animatedTransitioning = [[YPPopupAnimatedTransitioning alloc] init];
    }
    return _animatedTransitioning;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor yp_whiteColor];
    }
    return _contentView;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [[UIColor yp_blackColor] yp_alpha:0.4];
        _backgroundView.userInteractionEnabled = YES;
        [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchMoveAction)]];
    }
    return _backgroundView;
}

#pragma mark - model present

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}

/*
 
 // 充满全屏，如果弹出VC的wantsFullScreenLayout设置为YES的，则会填充到状态栏下边，否则不会填充到状态栏之下
 UIModalPresentationFullScreen

 // 高度和当前屏幕高度相同，宽度和竖屏模式下屏幕宽度相同，剩余未覆盖区域将会变暗并阻止用户点击。
 // 这种弹出模式下，竖屏时跟UIModalPresentationFullScreen的效果一样，横屏时候两边则会留下变暗的区域
 UIModalPresentationPageSheet

 // 高度和宽度均会小于屏幕尺寸，presented VC居中显示，四周留下变暗区域
 UIModalPresentationFormSheet

 // 弹出方式和presenting VC的父VC的方式相同
 UIModalPresentationCurrentContext

 // 自定义视图展示风格，由一个自定义演示控制器和一个或多个自定义动画对象组成。
 // 符合UIViewControllerTransitioningDelegate协议，使用视图控制器的transitioningDelegate设定您的自定义转换
 UIModalPresentationCustom

 // 如果视图没有被填满，底层视图可以透过
 UIModalPresentationOverFullScreen

 // 视图全部被透过
 UIModalPresentationOverCurrentContext

 // iPad中常用的设置弹出模式
 UIModalPresentationPopover
 
 */
@end
