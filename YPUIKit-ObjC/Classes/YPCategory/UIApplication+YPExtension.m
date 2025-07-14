//
//  UIApplication+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/7/14.
//

#import "UIApplication+YPExtension.h"

@implementation UIApplication (YPExtension)

+ (UIWindow *)yp_activeWindow {
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *scenes = UIApplication.sharedApplication.connectedScenes;
        for (UIScene *scene in scenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive &&
                [scene isKindOfClass:UIWindowScene.class]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) return window;
                }
                return windowScene.windows.firstObject;
            }
        }
        return nil;   // 理论上不会走到这里
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return UIApplication.sharedApplication.keyWindow;
#pragma clang diagnostic pop
    }
}

@end
