//
//  YPKeychain.h
//  Pods
//  作者：ShineMo iOS Developer
//  Created by Hansen on 2023/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPKeychain : NSObject

+ (BOOL)saveObject:(id)obj forKey:(NSString *)key;

+ (BOOL)saveObject:(id)obj forKey:(NSString *)key user:(NSString *)userId;

+ (id)loadObjectForKey:(NSString *)key;

+ (id)loadObjectForKey:(NSString *)key user:(NSString *)userId;

+ (BOOL)deleteObjectForKey:(NSString *)key;

+ (BOOL)deleteObjectForKey:(NSString *)key user:(NSString *)userId;

#pragma mark - device only

+ (BOOL)saveDeviceOnlyObject:(id)obj forKey:(NSString *)key;

+ (BOOL)saveDeviceOnlyObject:(id)obj forKey:(NSString *)key user:(NSString *)userId;

+ (id)loadDeviceOnlyObjectForKey:(NSString *)key;

+ (id)loadDeviceOnlyObjectForKey:(NSString *)key user:(NSString *)userId;

+ (BOOL)deleteDeviceOnlyObjectForKey:(NSString *)key;

+ (BOOL)deleteDeviceOnlyObjectForKey:(NSString *)key user:(NSString *)userId;


@end

NS_ASSUME_NONNULL_END
