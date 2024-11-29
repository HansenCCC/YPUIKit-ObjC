//
//  YPShakeManager.h
//  Pods
//
//  Created by Hansen on 2023/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPShakeManager : NSObject

@property (nonatomic, assign) BOOL isEnableShare;// default NO

+ (instancetype)shareInstance;

/// 轻触震动
- (void)tapShake;

/// 长按震动
- (void)longPressShake;

/// 根据 id 响应震动
- (void)shakeWithId:(NSInteger)soundID;

@end

NS_ASSUME_NONNULL_END
