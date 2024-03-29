//
//  YPDatePickerAlert.h
//  Pods-YPUIKit-ObjC_Example
//
//  Created by Hansen on 2023/6/4.
//

#import "YPPopupController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPDatePickerAlert : YPPopupController

@property (nonatomic, assign) UIDatePickerMode datePickerMode;// default UIDatePickerModeDateAndTime

/// 初始化 时间弹框 picker
/// - Parameters:
///   - date: 当前选中时间（默认当前时间）
///   - completeBlock: 确认选中回调
+ (instancetype)popupWithDate:(NSDate *)date completeBlock:(void(^)(NSDate *date))completeBlock;

@end

NS_ASSUME_NONNULL_END
