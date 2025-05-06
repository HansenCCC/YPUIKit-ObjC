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

@implementation YPSwiperView {
    NSTimer *_timer;
}

- (instancetype)init {
    if (self = [super init]) {
        _index = 0;
        _loop = YES;
        _autoplay = NO;
        _delay = 3.0f;
        _showPageControl = YES;
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self removeTimer];
        [self addTimer];
    }
    return self;
}

- (void)addTimer {
    __weak typeof(self) weakSelf = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.delay repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.autoplay) {
            // 开始滚动
            NSInteger sections = weakSelf.currentIndexPath.section;
            NSInteger row = weakSelf.currentIndexPath.row;
            BOOL animated = YES;
            if (row >= [weakSelf.collectionView numberOfItemsInSection:sections] - 1) {
                if (sections >= weakSelf.collectionView.numberOfSections - 1) {
                    // 如果滚动到最边缘
                    animated = NO;
                }
            }
            [weakSelf scrollToIndexPath:[weakSelf nextIndexPath] animated:animated];
        }
    }];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)resetTimer {
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.delay]];
}

- (void)stopTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)dealloc{
    [self removeTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect f1 = self.bounds;
    self.collectionView.frame = f1;
    CGSize itemSize = CGSizeZero;
    itemSize = f1.size;
    self.flowLayout.itemSize = itemSize;
    
    CGRect f2 = self.bounds;
    f2.size.height = [self.pageControl sizeThatFits:CGSizeZero].height;
    f2.origin.y = self.bounds.size.height - f2.size.height;
    self.pageControl.frame = f2;
}

- (void)reloadData {
    [self.collectionView reloadData];
    NSInteger row = [self.delegate swiperCollectionView:self.collectionView numberOfItemsInSection:0];
    self.pageControl.numberOfPages = row;
    [self reloadCurrentPageControl];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 滚动到起始位置
        if (row > 0) {
            int section = (self.loop ? YPSwiperViewNumberOfSections : 1 ) / 2;
            NSIndexPath *indePath = [NSIndexPath indexPathForItem:0 inSection:section];
            //设置中间值（当collectionview并未设置frame时，此方法会crash）
            [self.collectionView scrollToItemAtIndexPath:indePath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self resetTimer];
        }
    });
}

- (void)reloadCurrentPageControl {
    if (self.pageControl.hidden || self.pageControl.alpha == 0) {
        return;
    }
    NSInteger currentPage = self.index;
    self.pageControl.currentPage = currentPage;
}

- (void)scrollToIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    UICollectionViewLayoutAttributes *attr = [self.flowLayout layoutAttributesForItemAtIndexPath:indexPath];
    if (!attr) {
        [self.collectionView layoutIfNeeded];
        attr = [self.flowLayout layoutAttributesForItemAtIndexPath:indexPath];
        if (!attr) {
            return;
        }
    }
    CGPoint point = CGPointMake(attr.frame.origin.x, 0);
    CGPoint nextPoint = [self.flowLayout targetContentOffsetForProposedContentOffset:point withScrollingVelocity:CGPointZero];
    [self.collectionView setContentOffset:nextPoint animated:animated];
    //推迟，调用此方法重新开始计时
    [self resetTimer];
}

- (void)didChangePageControl:(UIPageControl *)pageControl {
    NSInteger oldCurrentPage = self.index;
    NSInteger currentPage = pageControl.currentPage;
    if (currentPage > oldCurrentPage) {
        // 下一个
        [self scrollToNextIndexPath];
    } else if (currentPage < oldCurrentPage) {
        // 上一个
        [self scrollToLastIndexPath];
    }
}

- (void)scrollToNextIndexPath {
    [self scrollToIndexPath:[self nextIndexPath] animated:YES];
}

- (void)scrollToLastIndexPath {
    [self scrollToIndexPath:[self lastIndexPath] animated:YES];
}

#pragma mark - getters | setters

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
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
        [_pageControl addTarget:self action:@selector(didChangePageControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}

- (NSInteger)index {
    return [self currentIndexPath].row;
}

- (NSIndexPath *)currentIndexPath {
    CGPoint point = CGPointZero;
    point.x = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2;
    point.y = self.collectionView.bounds.size.height / 2;
    NSIndexPath *indePath = [self.collectionView indexPathForItemAtPoint:point];
    return indePath;
}

- (NSIndexPath *)nextIndexPath {
    NSIndexPath *indexPath = nil;
    NSInteger sections = self.currentIndexPath.section;
    NSInteger row = self.currentIndexPath.row;
    if (row >= [self.collectionView numberOfItemsInSection:sections] - 1) {
        if (sections >= self.collectionView.numberOfSections - 1) {
            sections = (self.loop ? YPSwiperViewNumberOfSections : 1) / 2;
        } else {
            sections ++;
        }
        row = 0;
    } else {
        row ++;
    }
    indexPath = [NSIndexPath indexPathForRow:row inSection:sections];
    return indexPath;
}

- (NSIndexPath *)lastIndexPath {
    NSIndexPath *indexPath = nil;
    NSInteger sections = self.currentIndexPath.section;
    NSInteger row = self.currentIndexPath.row;
    if (row <= 0) {
        if (sections <= 0) {
            sections = (self.loop ? YPSwiperViewNumberOfSections : 1) / 2;
        } else {
            sections --;
        }
        row = [self.collectionView numberOfItemsInSection:sections] - 1;
    } else {
        row --;
    }
    indexPath = [NSIndexPath indexPathForRow:row inSection:sections];
    return indexPath;
}

- (void)setCellClass:(NSArray *)cellClass {
    _cellClass = cellClass;
    for (Class cell in cellClass) {
        if ([cell isSubclassOfClass:[UICollectionViewCell class]]) {
            [self.collectionView registerClass:cell forCellWithReuseIdentifier:NSStringFromClass(cell)];
        }
    }
}

- (void)setDelay:(NSTimeInterval)delay {
    _delay = delay;
    [self removeTimer];
    [self addTimer];
    [self reloadData];
}

- (void)setLoop:(BOOL)loop {
    _loop = loop;
    [self removeTimer];
    [self addTimer];
    [self reloadData];
}

- (void)setAutoplay:(BOOL)autoplay {
    _autoplay = autoplay;
    [self removeTimer];
    [self addTimer];
    [self reloadData];
}

- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !showPageControl;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.delegate swiperCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger row = [self.delegate swiperCollectionView:collectionView numberOfItemsInSection:section];
    return row;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    int section = YPSwiperViewNumberOfSections;
    return self.loop ? section : 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(swiperCollectionView:didSelectItemAtIndexPath:)]) {
        [self.delegate swiperCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resetTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self reloadCurrentPageControl];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self reloadCurrentPageControl];
}
@end
