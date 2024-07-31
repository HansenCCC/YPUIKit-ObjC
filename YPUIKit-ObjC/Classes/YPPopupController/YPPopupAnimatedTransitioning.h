//
//  YPPopupAnimatedTransitioning.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/9/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPPopupAnimatedTransitioning : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL isPresentedWithAnimation;

@end

NS_ASSUME_NONNULL_END
