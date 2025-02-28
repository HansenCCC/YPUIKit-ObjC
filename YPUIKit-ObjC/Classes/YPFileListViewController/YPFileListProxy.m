//
//  YPFileListProxy.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import "YPFileListProxy.h"
#import "YPFileListViewModel.h"
#import "YPFileListModel.h"
#import "YPFileManager.h"
#import "YPFileListViewController.h"
#import "YPCategoryHeader.h"
#import "YPShakeManager.h"
#import "YPFileListTableViewCell.h"
#import <QuickLook/QuickLook.h>

@interface YPFileListProxy () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (nonatomic, weak) YPFileListViewModel *viewModel;

@end

@implementation YPFileListProxy

- (instancetype)initWithViewModel:(YPFileListViewModel *)viewModel {
    if (self = [self init]) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YPFileListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YPFileListTableViewCell"];
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    cell.cellModel = cellModel;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 70.f;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    if (cellModel.fileItem.isDirectory) {
        [[YPShakeManager shareInstance] mediumShake];
        
        NSArray *viewControllers = [UIViewController yp_topViewController].navigationController.viewControllers;
        YPFileListViewController *rootVC = nil;
        for (UIViewController *vc in viewControllers) {
            if ([vc isKindOfClass:[YPFileListViewController class]]) {
                rootVC = (YPFileListViewController *)vc;
            }
        }
        if (!rootVC) {
            return;
        }
        YPFileListViewController *vc = [[YPFileListViewController alloc] initWithPath:cellModel.fileItem.path];
        vc.isRoot = NO;
        vc.type = rootVC.type;
        [[UIViewController yp_topViewController].navigationController pushViewController:vc animated:YES];
    } else {
        if (self.viewModel.type == YPFileListTypeSelect) {
            return;
        }
        [self quickViewItemAtIndexPath:indexPath];
    }
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
    trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.type == YPFileListTypeSelect) {
        return nil;
    }
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    if (cellModel.isEditing || cellModel.fileItem.isWritable == NO) {
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                                                               title:@"删除".yp_localizedString
                                                                             handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        [weakSelf deleteItemAtIndexPath:indexPath tableView:tableView];
        if (completionHandler) {
            completionHandler(YES);
        }
    }];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
    config.performsFirstActionWithFullSwipe = YES;
    return config;
}

- (UIContextMenuConfiguration *)tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point  API_AVAILABLE(ios(13.0)){
    return [UIContextMenuConfiguration configurationWithIdentifier:nil
                                                        previewProvider:nil
                                                     actionProvider:^UIMenu *(NSArray<UIMenuElement *> *suggestedActions) {
        UIAction *renameAction = [UIAction actionWithTitle:@"重新命名".yp_localizedString image:[UIImage systemImageNamed:@"pencil"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 重新命名操作
            [self renameItemAtIndexPath:indexPath tableView:tableView];
        }];
//        UIAction *compressAction = [UIAction actionWithTitle:@"压缩".yp_localizedString image:[UIImage systemImageNamed:@"archivebox"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//            // 压缩操作
//            [self compressItemAtIndexPath:indexPath];
//        }];
//        UIAction *unzipAction = [UIAction actionWithTitle:@"解压".yp_localizedString image:[UIImage systemImageNamed:@"arrow.down.circle.fill"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
//            // 解压操作
//            [self unzipItemAtIndexPath:indexPath];
//        }];
        UIAction *copyAction = [UIAction actionWithTitle:@"复制".yp_localizedString image:[UIImage systemImageNamed:@"doc.on.doc"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 复制操作
            [self copyItemAtIndexPath:indexPath tableView:tableView];
        }];
        UIAction *cutAction = [UIAction actionWithTitle:@"移动".yp_localizedString image:[UIImage systemImageNamed:@"rectangle.portrait.and.arrow.right"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 剪切操作
            [self cutItemAtIndexPath:indexPath tableView:tableView];
        }];
        UIAction *quickViewAction = [UIAction actionWithTitle:@"快速查看".yp_localizedString image:[UIImage systemImageNamed:@"eye"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 快速查看操作
            [self quickViewItemAtIndexPath:indexPath];
        }];
        UIAction *openInOtherAppAction = [UIAction actionWithTitle:@"其它App打开".yp_localizedString image:[UIImage systemImageNamed:@"square.and.arrow.up"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            // 其它App打开操作
            [self openInOtherAppAtIndexPath:indexPath];
        }];
        UIAction *deleteAction = [UIAction actionWithTitle:@"删除".yp_localizedString image:[UIImage systemImageNamed:@"trash.fill"] identifier:nil  handler:^(__kindof UIAction * _Nonnull action) {
            // 删除操作
            [self deleteItemAtIndexPath:indexPath tableView:tableView];
        }];
        if (self.viewModel.type == YPFileListTypeSelect) {
            return nil;
        }
        YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
        if (cellModel.fileItem.isWritable) {
            return [UIMenu menuWithTitle:@"文件操作".yp_localizedString image:[UIImage systemImageNamed:@"pencil.and.outline"] identifier:nil options:UIMenuOptionsDestructive children:@[
                renameAction,
                copyAction,
                cutAction,
//                compressAction,
//                unzipAction,
                quickViewAction,
                openInOtherAppAction,
                deleteAction
            ]];
        } else {
            return [UIMenu menuWithTitle:@"文件操作".yp_localizedString image:[UIImage systemImageNamed:@"pencil.and.outline"] identifier:nil options:UIMenuOptionsDestructive children:@[
                openInOtherAppAction,
            ]];
        }
    }];
}

- (void)renameItemAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // 这里处理重新命名的逻辑
    [[YPShakeManager shareInstance] mediumShake];
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    cellModel.isEditing = YES;
    YPFileListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.cellModel = cellModel;
}

- (void)compressItemAtIndexPath:(NSIndexPath *)indexPath {
    // 这里处理压缩文件的逻辑
    NSLog(@"压缩文件: %@", indexPath);
}

- (void)unzipItemAtIndexPath:(NSIndexPath *)indexPath {
    // 这里处理解压文件的逻辑
    NSLog(@"解压文件: %@", indexPath);
}

- (void)copyItemAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // 这里处理复制文件的逻辑
    [[YPShakeManager shareInstance] mediumShake];
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    NSString *filePath = cellModel.fileItem.path;
    NSString *newFilePath = [[YPFileManager shareInstance] uniqueFilePathForPath:filePath];
    BOOL success = [[YPFileManager shareInstance] copyItemAtPath:filePath toPath:newFilePath];
    if (success) {
        [[YPShakeManager shareInstance] longPressShake];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFileManagerDidUpdate object:nil];
    }
}

- (void)cutItemAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // 这里处理复制文件的逻辑
    [[YPShakeManager shareInstance] mediumShake];
    NSArray *viewControllers = [UIViewController yp_topViewController].navigationController.viewControllers;
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (UIViewController *vc in viewControllers) {
        if ([vc isKindOfClass:[YPFileListViewController class]]) {
            YPFileListViewController *pathVC = (YPFileListViewController *)vc;
            YPFileListViewController *vc = [[YPFileListViewController alloc] initWithPath:[pathVC.path copy]];
            vc.isRoot = YES;
            vc.type = YPFileListTypeSelect;
            [vcs addObject:vc];
        }
    }
    if (vcs.count == 0) {
        return;
    }
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    [YPFileManager shareInstance].copiedItemPath = cellModel.fileItem.path;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vcs.lastObject];
    nav.viewControllers = vcs;
    [[UIViewController yp_topViewController] presentViewController:nav animated:YES completion:nil];
}

- (void)quickViewItemAtIndexPath:(NSIndexPath *)indexPath {
    // 这里处理快速查看文件的逻辑
    [[YPShakeManager shareInstance] mediumShake];
    QLPreviewController *vc = [[QLPreviewController alloc] init];
    vc.dataSource = self;
    vc.delegate = self;
    vc.currentPreviewItemIndex = indexPath.row;
    [[UIViewController yp_topViewController] presentViewController:vc animated:YES completion:nil];
}

- (void)openInOtherAppAtIndexPath:(NSIndexPath *)indexPath {
    // 这里处理其它App打开文件的逻辑
    [[YPShakeManager shareInstance] mediumShake];
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    NSString *filePath = cellModel.fileItem.path;
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[fileURL] applicationActivities:nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        CGRect bounds = [[UIViewController yp_topViewController] view].bounds;
        CGRect sourceRect = CGRectMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds), 0, 0);
        activityViewController.popoverPresentationController.sourceView = [[UIViewController yp_topViewController] view]; // 设置来源视图
        activityViewController.popoverPresentationController.sourceRect = sourceRect;// 设置来源矩形区域
        activityViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny; // 设置箭头方向
    }
    [[UIViewController yp_topViewController] presentViewController:activityViewController animated:YES completion:nil];
}

- (void)deleteItemAtIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    // 这里处理删除文件的逻辑
    YPFileListModel *cellModel = self.viewModel.dataList[indexPath.row];
    BOOL success = [[YPFileManager shareInstance] deleteItemAtPath:cellModel.fileItem.path];
    if (success) {
        [[YPShakeManager shareInstance] longPressShake];
        [self.viewModel.dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - QLPreviewControllerDataSource, QLPreviewControllerDelegate

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.viewModel.dataList.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    YPFileListModel *cellModel = self.viewModel.dataList[index];
    return [NSURL fileURLWithPath:cellModel.fileItem.path];
}

@end
