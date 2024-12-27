//
//  UITableViewCell+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "UITableViewCell+YPExtension.h"
#import "UIView+YPExtension.h"

@implementation UITableViewCell (YPExtension)

/// 刷新当前试图
- (void)yp_reloadCurrentTableViewCell {
    UITableView *tableView = (UITableView *)[self yp_findSuperviewsOfClass:[UITableView class]].firstObject;
    if ([tableView isKindOfClass:[UITableView class]]) {
        NSIndexPath *indexPath = [tableView indexPathForCell:self];
        if (indexPath) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

/// 刷新当前表格
- (void)yp_reloadCurrentTableView {
    UITableView *tableView = (UITableView *)[self yp_findSuperviewsOfClass:[UITableView class]].firstObject;
    if ([tableView isKindOfClass:[UITableView class]]) {
        [tableView reloadData];
    }
}

@end
