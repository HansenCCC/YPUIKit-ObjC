//
//  YPAppDelegate.m
//  YPUIKit-ObjC
//
//  Created by chenghengsheng on 07/11/2022.
//  Copyright (c) 2022 chenghengsheng. All rights reserved.
//

#import "YPAppDelegate.h"
#import "ViewController.h"

@implementation YPAppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    self.window.rootViewController = vc;
    return YES;
}

@end
