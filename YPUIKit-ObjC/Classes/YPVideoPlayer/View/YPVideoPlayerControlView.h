//
//  YPVideoPlayerViewBottom.h
//  Pods
//
//  Created by Hansen on 2025/3/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPVideoPlayerControlView : UIView

@property (nonatomic, copy) void (^onRotateButtonTapped)(void);
@property (nonatomic, copy) void (^onBackButtonTapped)(void);

@end

NS_ASSUME_NONNULL_END
