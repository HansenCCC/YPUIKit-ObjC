//
//  YPVideoPlayerViewController.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import "YPVideoPlayerViewController.h"
#import "YPVideoPlayerView.h"

@interface YPVideoPlayerViewController ()

@property (nonatomic, strong) YPVideoPlayerView *playerView;
@property (nonatomic, assign) BOOL isLandscape;

@end

@implementation YPVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.playerView];
    [self.playerView playWithSource:self.videoSource];
    // 监听屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIDeviceOrientationLandscapeRight) {
        if (self.isLandscape) {
            return;
        }
        [self enterFullScreen];
    } else if (orientation == UIDeviceOrientationPortrait) {
        if (!self.isLandscape) {
            return;
        }
        [self exitFullScreen];
    }
}

// 是否允许自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

// 当前允许的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.isLandscape ? UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

// 横屏
- (void)enterFullScreen {
    self.isLandscape = YES;
    // 强制视图控制器重新计算旋转方向
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 16.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)self.view.window.windowScene;
        if (windowScene) {
            UIWindowSceneGeometryPreferencesIOS *geometryPreferences =
                [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:UIInterfaceOrientationMaskLandscapeRight];
            [windowScene requestGeometryUpdateWithPreferences:geometryPreferences errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"Error forcing orientation: %@", error);
            }];
            [UIViewController attemptRotationToDeviceOrientation];
        }
    } else {
        NSNumber *value = @(UIInterfaceOrientationLandscapeRight);
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

// 竖屏
- (void)exitFullScreen {
    self.isLandscape = NO;
    // 强制视图控制器重新计算旋转方向
    [self setNeedsStatusBarAppearanceUpdate];
    if (@available(iOS 16.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)self.view.window.windowScene;
        if (windowScene) {
            UIWindowSceneGeometryPreferencesIOS *geometryPreferences =
                [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:UIInterfaceOrientationMaskPortrait];
            [windowScene requestGeometryUpdateWithPreferences:geometryPreferences errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"Error forcing orientation: %@", error);
            }];
            [UIViewController attemptRotationToDeviceOrientation];
        }
    } else {
        NSNumber *value = @(UIInterfaceOrientationPortrait);
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    UIEdgeInsets safeInsets = self.view.safeAreaInsets;
    if (self.isLandscape) {
        safeInsets.bottom = 0;
    }
    CGRect f1 = UIEdgeInsetsInsetRect(bounds, safeInsets);
    self.playerView.frame = f1;
}

#pragma mark - setter | getters

- (YPVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[YPVideoPlayerView alloc] init];
        __weak typeof(self) weakSelf = self;
        _playerView.onBackButtonTapped = ^{
            if (weakSelf.isLandscape) {
                [weakSelf exitFullScreen];
                return;
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _playerView.onRotateButtonTapped = ^{
            if (weakSelf.isLandscape) {
                [weakSelf exitFullScreen];
            } else {
                [weakSelf enterFullScreen];
            }
        };
    }
    return _playerView;
}

@end
