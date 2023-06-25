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

- (UICollectionViewCell *)swiperCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YPSwiperCell" forIndexPath:indexPath];
    return cell;
}

- (NSInteger)swiperCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

#pragma mark - setters | getters

- (YPSwiperView *)swiperView {
    if (!_swiperView) {
        _swiperView = [[YPSwiperView alloc] init];
        _swiperView.delegate = self;
        _swiperView.autoplay = YES;
        _swiperView.delay = 3;
        _swiperView.cellClass = @[
            [YPSwiperCell class]
        ];
    }
    return _swiperView;
}

@end
