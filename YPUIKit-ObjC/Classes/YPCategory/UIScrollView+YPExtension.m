//
//  UIScrollView+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UIScrollView+YPExtension.h"

@implementation UIScrollView (YPExtension)

- (UIEdgeInsets)contentOffsetOfRange {
    CGRect bounds = self.bounds;
    CGSize contentSize = self.contentSize;
    UIEdgeInsets contentInset = self.contentInset;
    CGFloat minY = -contentInset.top;
    CGFloat maxY = -(bounds.size.height - contentInset.bottom - contentSize.height);
    CGFloat minX = -contentInset.left;
    CGFloat maxX = -(bounds.size.width - contentInset.right - contentSize.width);
    UIEdgeInsets range = UIEdgeInsetsMake(minY, minX, maxY, maxX);
    return range;
}

/// 滚动到底部
/// @param animated 动画
- (void)yp_scrollToBottomWithAnimated:(BOOL)animated {
    CGFloat offsetYMax = [self contentOffsetOfRange].bottom;
    CGFloat offsetYMin = [self contentOffsetOfRange].top;
    if(offsetYMax < offsetYMin) {
        offsetYMax = offsetYMin;
    }
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetYMax;
    if(animated) {
        [self setContentOffset:contentOffset animated:animated];
    } else {
        self.contentOffset = contentOffset;
    }
}

/// 滚动到头部
/// @param animated 动画
- (void)yp_scrollToTopWithAnimated:(BOOL)animated {
    CGFloat offsetYMin = [self contentOffsetOfRange].top;
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = offsetYMin;
    if (animated) {
        [self setContentOffset:contentOffset animated:animated];
    } else {
        self.contentOffset = contentOffset;
    }
}

/// 滚动到指定试图
/// @param toView 试图
/// @param animated 动画
-(void)yp_scrollToView:(UIView *)toView animated:(BOOL)animated {
    //让cell定位到选中位置
    CGFloat contance = CGRectGetMaxX(toView.frame);
    if ((contance - self.contentOffset.x - self.bounds.size.width) > 0) {
        CGFloat contanceX = contance - self.contentOffset.x - self.bounds.size.width + self.contentOffset.x;
        [self setContentOffset:CGPointMake(contanceX, 0) animated:animated];
    }else if((toView.frame.origin.x - self.contentOffset.x) < 0){
        CGFloat contanceX = self.contentOffset.x + toView.frame.origin.x - self.contentOffset.x;
        [self setContentOffset:CGPointMake(contanceX, 0) animated:animated];
    }
}

@end
