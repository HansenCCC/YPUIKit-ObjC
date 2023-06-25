//
//  YPSwiper.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/6/25.
//

#import "YPSwiper.h"
#import "YPSwiperView.h"

@interface YPSwiper () <YPSwiperViewDelegate>

@property (nonatomic, strong) YPSwiperView *swiperView;

@end

@implementation YPSwiper

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:self.swiperView];
}

- (void)setImages:(NSArray *)images {
    _images = images;
    [self.swiperView reloadData];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect f1 = bounds;
    self.swiperView.frame = f1;
}

#pragma mark - YPSwiperViewDelegate

- (YPSwiperCell *)swiperView:(YPSwiperView *)swiperView cellForItemAtIndex:(NSInteger)index {
    YPSwiperCell *cell = [swiperView.collectionView dequeueReusableCellWithReuseIdentifier:@"YPSwiperCell" forIndexPath:[NSIndexPath indexPathWithIndex:index]];
    return cell;
}

- (NSInteger)numberOfItemsInSwiperView:(YPSwiperView *)swiperView {
    return self.images.count;
}

#pragma mark - setters | getters

- (YPSwiperView *)swiperView {
    if (!_swiperView) {
        _swiperView = [[YPSwiperView alloc] init];
        _swiperView.delegate = self;
        [_swiperView.collectionView  registerClass:[YPSwiperCell class] forCellWithReuseIdentifier:@"YPSwiperCell"];
    }
    return _swiperView;
}

@end
