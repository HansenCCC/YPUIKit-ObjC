//
//  YPMultiLineInputViewController.h
//  YPLaboratory
//
//  Created by Hansen on 2023/6/20.
//

#import "YPViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPMultiLineInputViewController : YPViewController

@property (nonatomic, assign) NSUInteger maxLength;// default 100字符
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) void (^didCompleteCallback)(NSString *text);

@end

NS_ASSUME_NONNULL_END
