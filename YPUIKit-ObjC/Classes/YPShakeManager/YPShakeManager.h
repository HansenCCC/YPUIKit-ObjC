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
- (void)tapShare;

/// 长按震动
- (void)longPressShare;

@end

NS_ASSUME_NONNULL_END
