//
//  YPSwiperView.m
//  Pods-YPUIKit-ObjC_Example
//
//  Created by Hansen on 2023/6/25.
//

#import "YPSwiperView.h"

#define YPSwiperViewNumberOfSections 100 //限制

@interface YPSwiperView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation YPSwiperView

- (instancetype)init {
    if (self = [super init]) {
        _index = 0;
        _loop = YES;
        _autoplay = NO;
        _delay = 3.0f;
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect f1 = self.bounds;
    self.collectionView.frame = f1;
    self.flowLayout.itemSize = f1.size;
    
    CGRect f2 = self.bounds;
    f2.size.height = [self.pageControl sizeThatFits:CGSizeZero].height;
    f2.origin.y = self.bounds.size.height - f2.size.height;
    self.pageControl.frame = f2;
}

- (void)reloadData {
    [self.collectionView reloadData];
    NSInteger row = [self.delegate numberOfItemsInSwiperView:self];
    self.pageControl.numberOfPages = row;
    [self reloadCurrentPageControl];
}

- (void)reloadCurrentPageControl {
    if (self.pageControl.hidden || self.pageControl.alpha == 0) {
        return;
    }
    NSInteger currentPage = self.index;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - getters | setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = 0.f;
        _flowLayout.minimumInteritemSpacing = 0.f;
    }
    return _flowLayout;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
    }
    return _pageControl;
}

- (NSInteger)index {
    CGPoint point = CGPointZero;
    point.x = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2;
    point.y = self.collectionView.bounds.size.height / 2;
    NSIndexPath *indePath = [self.collectionView indexPathForItemAtPoint:point];
    return indePath.row;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPSwiperCell *cell = [self.delegate swiperView:self cellForItemAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger row = [self.delegate numberOfItemsInSwiperView:self];
    return row;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int section = YPSwiperViewNumberOfSections;
    return self.loop ? section : 1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timeInterval]];
    [self reloadCurrentPageControl];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self reloadCurrentPageControl];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reloadCurrentPageControl];
}

@end
