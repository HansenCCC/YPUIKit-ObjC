//
//  YPPopupAnimatedTransitioning.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/9/2.
//

#import "YPPopupAnimatedTransitioning.h"

@interface __YPPopupUIViewControllerAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresented;

@end

@implementation __YPPopupUIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * container = [transitionContext containerView];
    if (self.isPresented) {
        [container addSubview:toVC.view];
        [container bringSubviewToFront:fromVC.view];
    } else {
        [container addSubview:fromVC.view];
        [container bringSubviewToFront:toVC.view];
    }
    [transitionContext completeTransition:YES];
}

@end

@implementation YPPopupAnimatedTransitioning

#pragma mark - UIViewControllerTransitionDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    __YPPopupUIViewControllerAnimatedTransitioning *animation = [[__YPPopupUIViewControllerAnimatedTransitioning alloc] init];
    animation.isPresented = YES;
    return animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    __YPPopupUIViewControllerAnimatedTransitioning *animation = [[__YPPopupUIViewControllerAnimatedTransitioning alloc] init];
    animation.isPresented = NO;
    return animation;
}

@end
