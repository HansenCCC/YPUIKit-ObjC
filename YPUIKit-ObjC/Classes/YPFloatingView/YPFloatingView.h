//
//  UIView+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPFloatingView : UIView

@property (nonatomic, copy) void (^didClickCallback)(void);

@end

NS_ASSUME_NONNULL_END
