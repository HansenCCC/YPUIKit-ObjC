//
//  YPVideoPlayerTopView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/3/27.
//

#import "YPVideoPlayerTopView.h"
#import "YPButton.h"
#import "UIColor+YPExtension.h"

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
        [self addSubview:self.speedButton];
    }
    return self;
}

- (void)backAction:(id)sender {
    
}

- (void)speedAction:(id)sender {
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGFloat space = 10.f;
    
    CGRect f1 = bounds;
    f1.size = CGSizeMake(25.f, 25.f);
    f1.origin.x = space;
    f1.origin.y = space;
    self.backButton.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = [self.titleLabel sizeThatFits:CGSizeZero];
    f2.size.width = MIN(bounds.size.width / 2, f2.size.width);
    f2.origin.x = CGRectGetMaxX(f1) + space;
    f2.origin.y = CGRectGetMidY(f1) - f2.size.height / 2.f;
    self.titleLabel.frame = f2;
    
    CGRect f3 = bounds;
    f3.size = [self.speedButton sizeThatFits:CGSizeZero];
    f3.size.height += 10.f;
    f3.size.width += 10.f;
    f3.origin.y = CGRectGetMidY(f1) - f3.size.height / 2.f;
    f3.origin.x = bounds.size.width - f3.size.width - space;
    self.speedButton.frame = f3;
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
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.textColor = [UIColor yp_whiteColor];
        _titleLabel.text  = @"金瓶梅";
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
