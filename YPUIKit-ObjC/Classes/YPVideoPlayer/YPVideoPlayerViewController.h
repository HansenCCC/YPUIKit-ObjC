//
//  YPVideoPlayerViewController.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import "YPViewController.h"
#import "YPVideoSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPVideoPlayerViewController : YPViewController

@property (nonatomic, strong) YPVideoSource *videoSource;

@end

NS_ASSUME_NONNULL_END
