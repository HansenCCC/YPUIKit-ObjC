//
//  YPSingleLineInputViewController.h
//  YPLaboratory
//
//  Created by Hansen on 2023/6/20.
//

#import <YPUIKit/YPUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPSingleLineInputViewController : YPViewController

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) void (^didCompleteCallback)(NSString *text);

@end

NS_ASSUME_NONNULL_END
