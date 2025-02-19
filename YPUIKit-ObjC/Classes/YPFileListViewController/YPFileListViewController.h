//
//  YPFileListViewController.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import <YPUIKit/YPUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPFileListViewController : YPViewController

@property (nonatomic, assign) BOOL isRoot;

- (instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
