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

@end

@implementation YPVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.playerView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    CGRect f1 = bounds;
    self.playerView.frame = f1;
}

#pragma mark - setter | getters

- (YPVideoPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[YPVideoPlayerView alloc] init];
    }
    return _playerView;
}

@end
