//
//  NSObject+YPExtension.m
//  WTPlatformSDK
//
//  Created by Hansen on 2023/1/3.
//

#import "NSObject+YPExtension.h"
#import <objc/runtime.h>

@implementation NSObject (YPExtension)

@end


@implementation NSObject (YPHook)

+ (void)yp_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)yp_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end
