//
//  YPBadgeView.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2024/11/6.
//

#import "YPBadgeView.h"
#import "UIColor+YPExtension.h"
#import "UIView+YPExtension.h"

@interface YPBadgeView ()

@end

@implementation YPBadgeView

- (instancetype)init {
    if (self = [super init]) {
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:12.f];
        self.backgroundColor = [UIColor yp_redColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    if (text.length == 0) {
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
}

- (void)setBadgeString:(NSString *)badgeString {
    self.text = badgeString;
}

- (NSString *)badgeString {
    return self.text;
}

- (void)setBadgeInteger:(NSInteger)badgeInteger {
    if (badgeInteger == 0) {
        self.text = nil;
    } else {
        self.text = @(badgeInteger).stringValue;
    }
}

- (NSInteger)badgeInteger {
    return self.text.integerValue;
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    size.height += 5.f;
    size.width += 10.f;
    if (size.width < size.height) {
        size.width = size.height;
    }
    return size;
}

- (void)setIsBadge:(BOOL)isBadge {
    _isBadge = isBadge;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect superviewBounds = self.superview.bounds;
    if (CGRectIsEmpty(superviewBounds)) {
        return;
    }
    CGSize size = [self sizeThatFits:CGSizeZero];
    CGRect f1 = superviewBounds;
    f1.size = size;
    if (!self.isBadge) {
        f1.size = CGSizeMake(5.f, 5.f);
    }
    if (self.superview.clipsToBounds) {
        f1.origin.x = superviewBounds.size.width - f1.size.width;
        f1.origin.y = 0;
    } else {
        f1.origin.x = superviewBounds.size.width - f1.size.width / 2.0;
        f1.origin.y = -f1.size.height / 2.0;
    }
    self.frame = f1;
    CGRect bounds = self.bounds;
    self.layer.cornerRadius = bounds.size.height / 2.0f;
}

+ (void)showBadgeToView:(UIView *)view badgeInteger:(NSInteger )badgeInteger {
    YPBadgeView *badgeView = nil;
    badgeView = (YPBadgeView *)[view yp_findSubviewsOfClass:[YPBadgeView class]].firstObject;
    if (!badgeView) {
        badgeView = [[YPBadgeView alloc] init];
        [view addSubview:badgeView];
    }
    badgeView.isBadge = YES;
    badgeView.badgeInteger = badgeInteger;
    [badgeView setNeedsLayout];
    [badgeView layoutIfNeeded];
}

+ (void)showBadgeToView:(UIView *)view {
    YPBadgeView *badgeView = nil;
    badgeView = (YPBadgeView *)[view yp_findSubviewsOfClass:[YPBadgeView class]].firstObject;
    if (!badgeView) {
        badgeView = [[YPBadgeView alloc] init];
        [view addSubview:badgeView];
    }
    badgeView.isBadge = NO;
    [badgeView setNeedsLayout];
    [badgeView layoutIfNeeded];
}

+ (void)hiddenBadgeToView:(UIView *)view {
    YPBadgeView *badgeView = nil;
    badgeView = (YPBadgeView *)[view yp_findSubviewsOfClass:[YPBadgeView class]].firstObject;
    if (badgeView) {
        [badgeView removeFromSuperview];
    }
}

@end
