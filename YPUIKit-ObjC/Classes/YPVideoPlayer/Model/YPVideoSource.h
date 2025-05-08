//
//  YPVideoSource.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YPVideoType) {
    YPVideoTypeUnknown,
    YPVideoTypeURL,
    YPVideoTypeLive,
    YPVideoTypeLocal,
};

@interface YPVideoSource : NSObject

@property (nonatomic, strong) NSURL *url;             // 视频地址
@property (nonatomic, strong) NSString *title;        // 视频标题
@property (nonatomic, assign) CGFloat lastPlayTime;   // 上次播放进度
@property (nonatomic, assign) YPVideoType type;       // 视频类型

/// 保存登录的时间
- (void)saveLastPlayTime;

@end

NS_ASSUME_NONNULL_END
