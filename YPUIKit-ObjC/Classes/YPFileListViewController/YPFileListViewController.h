//
//  YPFileListViewController.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import <YPUIKit/YPUIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YPFileListTypeDefault,
    YPFileListTypeSelect,
} YPFileListType;

@interface YPFileListViewController : YPViewController

@property (nonatomic, readonly) NSString *path;
@property (nonatomic, assign) BOOL isRoot;
@property (nonatomic, assign) YPFileListType type;

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
