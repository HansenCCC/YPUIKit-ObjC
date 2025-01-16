//
//  YPVideoPlayerManager.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/1/16.
//

#import "YPVideoPlayerManager.h"

@implementation YPVideoPlayerManager

+ (instancetype)shareInstance {
    static YPVideoPlayerManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[YPVideoPlayerManager alloc] init];
    });
    return m;
}

@end
