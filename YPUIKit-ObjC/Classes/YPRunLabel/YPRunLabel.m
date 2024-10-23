//
//  YPRunLabel.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2024/10/23.
//

#import "YPRunLabel.h"

@interface YPRunLabel () <UIScrollViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isRunLeft;

@end

@implementation YPRunLabel

- (instancetype)init {
    if (self = [super init]) {
        self.isRunLeft = NO;
        self.scrollSpeed = 1.f;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    [self.scrollView addSubview:self.titleLabel];
    
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf startRunLabel];
    }];

    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate date]];
}

- (void)startRunLabel {
    CGFloat threshold = 1.0f;
    CGPoint contentPoint = self.scrollView.contentOffset;
    CGSize labelSize = self.titleLabel.frame.size;
    CGFloat space = 20.f;
    CGFloat width = self.frame.size.width;
    
    if (labelSize.width >= width) {
        // 文本内容大于自身
        if (contentPoint.x - labelSize.width + width - space > 0) {
            self.isRunLeft = NO;
        }
        
        if ((contentPoint.x + space) > 0 && self.isRunLeft == NO) {
            self.isRunLeft = NO;
        } else {
            self.isRunLeft = YES;
        }
    } else {
        // 文本内容小于自身
        if (contentPoint.x - space > 0) {
            self.isRunLeft = NO;
        }
        if ((contentPoint.x + space - labelSize.width + width) > 0 && self.isRunLeft == NO) {
            self.isRunLeft = NO;
        } else {
            self.isRunLeft = YES;
        }
    }
    
    threshold *= self.isRunLeft ? 1 : -1;
    CGFloat hah = (threshold * self.scrollSpeed);
    self.scrollView.contentOffset = CGPointMake(contentPoint.x + hah, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    
    CGRect f1 = bounds;
    f1.size = [self.titleLabel sizeThatFits:CGSizeZero];
    f1.size.height = bounds.size.height;
    self.titleLabel.frame = f1;
    
    CGRect f2 = bounds;
    self.scrollView.frame = f2;
    self.scrollView.contentSize = f1.size;
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [self.titleLabel sizeThatFits:size];
    size.height = [self.titleLabel sizeThatFits:CGSizeZero].height;
    return size;
}

- (void)dealloc {
    NSLog(@"释放了");
    [self.timer invalidate];
    self.timer = nil;
}

@end
