//
//  YPFileListProxy.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YPFileListViewModel;

@interface YPFileListProxy : NSObject <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithViewModel:(YPFileListViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
