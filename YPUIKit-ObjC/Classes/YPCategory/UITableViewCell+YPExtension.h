//
//  UITableViewCell+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (YPExtension)

/// 刷新当前试图
- (void)yp_reloadCurrentTableViewCell;

/// 刷新当前表格
- (void)yp_reloadCurrentTableView;

@end

NS_ASSUME_NONNULL_END
