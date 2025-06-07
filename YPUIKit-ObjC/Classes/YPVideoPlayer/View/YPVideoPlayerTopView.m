//
//  YPVideoPlayerTopView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/3/27.
//

#import "YPVideoPlayerTopView.h"
#import "YPButton.h"
#import "UIColor+YPExtension.h"
#import "YPVideoPlayerManager.h"
#import "YPShakeManager.h"
#import "YPKitDefines.h"
#import "UIView+YPExtension.h"

@interface YPVideoPlayerTopView ()

@property (nonatomic, strong) YPButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) YPButton *speedButton;

@end

@implementation YPVideoPlayerTopView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.backButton];
        [self addSubview:self.titleLabel];
//        [self addSubview:self.speedButton];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needUpdateUI) name:kYPVideoPlayerManagerUpdateUIKey object:nil];
    }
    return self;
}

- (void)needUpdateUI {
    self.titleLabel.text = [YPVideoPlayerManager shareInstance].videoSource.title;
}

- (void)backAction:(id)sender {
    [[YPShakeManager shareInstance] mediumShake];
    if (self.onBackButtonTapped) {
        self.onBackButtonTapped();
    }
}

- (void)speedAction:(id)sender {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGFloat space = 10.f;
    
    CGRect f1 = bounds;
    f1.size = CGSizeMake(45.f, 45.f);
    f1.origin.x = space;
    f1.origin.y = bounds.size.height - f1.size.height - 5;
    self.backButton.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = [self.titleLabel sizeThatFits:CGSizeZero];
    f2.size.width = MIN(bounds.size.width / 2, f2.size.width);
    f2.origin.x = CGRectGetMaxX(f1);
    f2.origin.y = CGRectGetMidY(f1) - f2.size.height / 2.f;
    self.titleLabel.frame = f2;
    
    CGRect f3 = bounds;
    f3.size = [self.speedButton sizeThatFits:CGSizeZero];
    f3.size.height += 10.f;
    f3.size.width += 10.f;
    f3.origin.y = CGRectGetMidY(f1) - f3.size.height / 2.f;
    f3.origin.x = bounds.size.width - f3.size.width - space;
    self.speedButton.frame = f3;
    
    [self yp_addGradientColors:@[
        [UIColor yp_colorWithHexString:@"#000000" withAlpha:1],
        [UIColor yp_colorWithHexString:@"#000000" withAlpha:0],]
                             locations:@[@(0), @(1.0f)]
                            startPoint:CGPointMake(0.5, 0)
                              endPoint:CGPointMake(0.5, 1)
    ];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setters | getters

- (YPButton *)backButton {
    if (!_backButton) {
        _backButton = [[YPButton alloc] init];
        UIImage *image = [UIImage systemImageNamed:@"chevron.left"];
        [_backButton setImage:image forState:UIControlStateNormal];
        _backButton.imageSize = CGSizeMake(22.f, 22.f);
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _backButton.tintColor = [UIColor yp_whiteColor];
        _backButton.backgroundColor = [UIColor yp_colorWithHexString:@"#000000" withAlpha:0.01];
        _backButton.adjustsImageWhenHighlighted = NO;
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.textColor = [UIColor yp_whiteColor];
        _titleLabel.userInteractionEnabled = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction:)];
        [_titleLabel addGestureRecognizer:tap];
    }
    return _titleLabel;
}

- (YPButton *)speedButton {
    if (!_speedButton) {
        _speedButton = [[YPButton alloc] init];
        _speedButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        [_speedButton setTitle:@"倍速" forState:UIControlStateNormal];
        [_speedButton setTitleColor:[UIColor yp_whiteColor] forState:UIControlStateNormal];
        [_speedButton addTarget:self action:@selector(speedAction:) forControlEvents:UIControlEventTouchUpInside];
        _speedButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _speedButton;
}

@end
