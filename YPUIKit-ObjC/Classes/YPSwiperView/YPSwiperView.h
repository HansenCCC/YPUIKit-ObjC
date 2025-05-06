//
//  YPSwiperView.h
//  Pods-YPUIKit-ObjC_Example
//  轻量级轮播图
//  Created by Hansen on 2023/6/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YPSwiperView;

@protocol YPSwiperViewDelegate <NSObject>

@required
/// 轮播图 单元格样式 【必接】
- (UICollectionViewCell *)swiperCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
/// 轮播图个数 【必接】
- (NSInteger)swiperCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

@optional
/// 轮播图点击回调
- (void)swiperCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface YPSwiperView : UIView

@property (nonatomic, assign) NSInteger index;// 当前下标 default 0
@property (nonatomic, assign) BOOL loop;// 是否循环滚动 default YES
@property (nonatomic, assign) BOOL autoplay;// 是否自动滚动 default NO
@property (nonatomic, assign) NSTimeInterval delay;// 自动滚动开启时，延迟多久翻页 default 3.0
@property (nonatomic, strong) NSArray *cellClass;// 保存轮播图的cell class 用于去 collectionVIew 注册 default @[[YPSwiperCell class]];

@property (nonatomic, assign) id <YPSwiperViewDelegate> delegate;
@property (nonatomic, assign) BOOL showPageControl;// 是否展示 pageControl default YES

- (void)reloadData;

/// 滚动到下一个
- (void)scrollToNextIndexPath;

/// 滚动到上一个
- (void)scrollToLastIndexPath;

@end

NS_ASSUME_NONNULL_END
