//
//  YPPickerAlert.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/6/4.
//

#import "YPPopupController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPPickerAlert : YPPopupController

@property (nonatomic, assign) NSInteger currentIndex;

/// 初始化 单选弹框 picker
/// - Parameters:
///   - options: 单选内容
///   - completeBlock: 确认选中回调
+ (instancetype)popupWithOptions:(NSArray <NSString *>*)options completeBlock:(void(^)(NSInteger index))completeBlock;

@end

NS_ASSUME_NONNULL_END
