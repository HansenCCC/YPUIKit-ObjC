//
//  YPPopupController.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/9/1.
//

#import "YPViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YPPopupControllerStyle){
    YPPopupControllerStyleMiddle = 0,
    YPPopupControllerStyleBottom
};

@interface YPPopupController : YPViewController

@property (nonatomic, assign) BOOL isEnableTouchMove;//是否允许点击时退出

@property (nonatomic, readonly) YPPopupControllerStyle style;
@property (nonatomic, readonly) UIView *contentView;

+ (instancetype)popupControllerWithStyle:(YPPopupControllerStyle)style;

@end

NS_ASSUME_NONNULL_END
