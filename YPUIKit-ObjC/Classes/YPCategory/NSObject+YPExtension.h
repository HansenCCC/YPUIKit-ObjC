//
//  NSObject+YPExtension.h
//  WTPlatformSDK
//
//  Created by Hansen on 2023/1/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YPExtension)

@end

@interface NSObject (YPHook)

/// Hook 替换实例方法
/// - Parameters:
///   - method1: method1 description
///   - method2: method2 description
+ (void)yp_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2;

/// Hook 替换类方法
/// - Parameters:
///   - method1: method1 description
///   - method2: method2 description
+ (void)yp_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2;

@end


NS_ASSUME_NONNULL_END
