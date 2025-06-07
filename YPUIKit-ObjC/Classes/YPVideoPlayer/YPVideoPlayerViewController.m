//
//  YPVideoPlayerViewController.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import "YPVideoPlayerViewController.h"
#import "YPVideoPlayerView.h"
#import "UIColor+YPExtension.h"

@interface YPVideoPlayerViewController ()

@property (nonatomic, strong) YPVideoPlayerView *playerView;
@property (nonatomic, assign) UIDeviceOrientation currentPrientation;
@property (nonatomic, readonly) BOOL isLandscape;// 是否是横屏

@end

@implementation YPVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yp_colorWithHexString:@"#000000"];
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
    self.currentPrientation = orientation;
    [self rotateScreen];
}


// 是否允许自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}

// 旋转屏幕
- (void)rotateScreen {
    [self setNeedsStatusBarAppearanceUpdate];
    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientation interfaceOrientation = UIInterfaceOrientationPortrait;
    if (self.currentPrientation == UIDeviceOrientationPortrait) {
        mask = UIInterfaceOrientationMaskPortrait;
        interfaceOrientation = UIInterfaceOrientationPortrait;
    } else if (self.currentPrientation == UIDeviceOrientationLandscapeLeft) {
        mask = UIInterfaceOrientationMaskLandscapeRight;
        interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    } else if (self.currentPrientation == UIDeviceOrientationLandscapeRight) {
        mask = UIInterfaceOrientationMaskLandscapeLeft;
        interfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    } else if (self.currentPrientation == UIDeviceOrientationPortraitUpsideDown) {
        mask = UIInterfaceOrientationMaskPortraitUpsideDown;
        interfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
    }
    if (@available(iOS 16.0, *)) {
        UIWindowScene *windowScene = (UIWindowScene *)self.view.window.windowScene;
        if (windowScene) {
            UIWindowSceneGeometryPreferencesIOS *preferences = [[UIWindowSceneGeometryPreferencesIOS alloc] initWithInterfaceOrientations:mask];
            [windowScene requestGeometryUpdateWithPreferences:preferences errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"Rotation error: %@", error);
            }];
            [UIViewController attemptRotationToDeviceOrientation];
        }
    } else {
        NSNumber *value = @(interfaceOrientation);
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
}

// 当前允许的旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.currentPrientation == UIDeviceOrientationPortrait) {
        return UIInterfaceOrientationMaskPortrait;
    } else if (self.currentPrientation == UIDeviceOrientationLandscapeLeft) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else if (self.currentPrientation == UIDeviceOrientationLandscapeRight) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else if (self.currentPrientation == UIDeviceOrientationPortraitUpsideDown) {
        return UIInterfaceOrientationMaskPortraitUpsideDown;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    self.playerView.frame = bounds;
}

#pragma mark - setter | getters

- (YPVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[YPVideoPlayerView alloc] init];
        __weak typeof(self) weakSelf = self;
        _playerView.onBackButtonTapped = ^{
            // 全屏状态先旋转竖屏
            if (weakSelf.isLandscape) {
                weakSelf.currentPrientation = UIDeviceOrientationPortrait;
                [weakSelf rotateScreen];
                return;
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _playerView.onRotateButtonTapped = ^{
            if (weakSelf.isLandscape) {
                weakSelf.currentPrientation = UIDeviceOrientationPortrait;
            } else {
                weakSelf.currentPrientation = UIDeviceOrientationLandscapeRight;
            }
            [weakSelf rotateScreen];
        };
    }
    return _playerView;
}

- (BOOL)isLandscape {
    if (self.currentPrientation == UIDeviceOrientationLandscapeLeft || self.currentPrientation == UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

@end
