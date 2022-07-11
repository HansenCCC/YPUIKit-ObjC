//
//  YPKitDefines.m
//  YPUIKit
//
//  Created by Hansen on 2022/7/5.
//

#import "YPKitDefines.h"

@implementation YPKitDefines

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    static YPKitDefines *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] initPrivate];
    });
    return instance;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (BOOL)isIPhoneXorLater {
    return (self.safeAreaInsets.bottom > 0);
}

- (UIEdgeInsets)safeAreaInsets {
    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        safeAreaInsets = [UIApplication sharedApplication].delegate.window.safeAreaInsets;
    }
    return safeAreaInsets;
}

- (CGFloat)navigationViewHeight {
    CGFloat navHeight = 44.0;
    return navHeight;
}

- (CGFloat)statusBarSizeHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (BOOL)isIpad {
    return  [[UIDevice currentDevice].model isEqualToString:@"iPad"];
}


@end
