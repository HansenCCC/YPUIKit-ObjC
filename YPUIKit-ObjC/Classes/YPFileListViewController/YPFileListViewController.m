//
//  YPFileListViewController.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import "YPFileListViewController.h"
#import "YPFileListViewModel.h"
#import "YPFileListProxy.h"
#import "YPFileListTableViewCell.h"

@interface YPFileListViewController () <YPFileListViewModelDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) YPFileListViewModel *viewModel;
@property (nonatomic, strong) YPFileListProxy *proxy;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation YPFileListViewController

- (instancetype)initWithPath:(NSString *)path {
    self = [self init];
    if (!self) {
        return nil;
    }
    self.filePath = path;
    self.type = YPFileListTypeDefault;
    self.title = [self.filePath pathComponents].lastObject;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startLoadData) name:kNotificationFileManagerDidUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self setupSubviews];
    [self startLoadData];
    [self setNavigationItem];
}

- (void)setNavigationItem {
    __weak typeof(self) weakSelf = self;
    YPFileItem *item = [[YPFileManager shareInstance] fileItemAtPath:self.filePath];
    // 判断当前文件夹是否拥有读写权限
    if (item.isWritable && item.isReadable) {
        if (@available(iOS 14.0, *)) {
            UIAction *createFolderAction = [UIAction actionWithTitle:@"创建文件夹".yp_localizedString image:[UIImage systemImageNamed:@"folder.badge.plus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [weakSelf createFinder];
            }];
            UIAction *createFileAction = [UIAction actionWithTitle:@"创建文件".yp_localizedString image:[UIImage systemImageNamed:@"doc.badge.plus"] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [weakSelf createFile];
            }];
            UIMenu *menu = [UIMenu menuWithTitle:@"选择操作".yp_localizedString children:@[createFolderAction, createFileAction]];
            UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis.circle"] style:UIBarButtonItemStyleDone target:nil action:nil];
            menuButton.menu = menu;
            self.navigationItem.rightBarButtonItem = menuButton;
        } else {
            UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightClickAction:)];
            self.navigationItem.rightBarButtonItem = menuButton;
        }
    }
    if (self.isRoot && self.viewModel.type == YPFileListTypeDefault) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leftClickAction:)];
    }
    if (self.viewModel.type == YPFileListTypeSelect) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightClickAction:)];
        self.navigationItem.rightBarButtonItem = menuButton;
    }
}

- (void)rightClickAction:(id)sender {
    [[YPShakeManager shareInstance] mediumShake];
    if (self.viewModel.type == YPFileListTypeDefault) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择操作".yp_localizedString message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        __weak typeof(self) weakSelf;
        [alert addAction:[UIAlertAction actionWithTitle:@"创建文件夹".yp_localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf createFinder];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"创建文件".yp_localizedString style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf createFile];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消".yp_localizedString style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (self.viewModel.type == YPFileListTypeSelect) {
        NSString *sourceItemPath = [YPFileManager shareInstance].copiedItemPath; // 源文件或目录
        NSString *destinationPath = self.filePath; // 目标文件或目录路径
        if (sourceItemPath.length == 0 || destinationPath.length == 0) {
            return;
        }
        NSString *absoluteSourcePath = [sourceItemPath stringByStandardizingPath];
        NSString *absoluteDestinationPath = [destinationPath stringByStandardizingPath];
        if ([absoluteDestinationPath hasPrefix:absoluteSourcePath] && ![absoluteSourcePath isEqualToString:absoluteDestinationPath]) {
            [YPAlertView alertText:@"不能将文件或目录移动到其自身的子目录中".yp_localizedString];
            return;
        }
        [[YPFileManager shareInstance] moveItemAtPath:sourceItemPath toPath:destinationPath];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFileManagerDidUpdate object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)createFile {
    [[YPShakeManager shareInstance] mediumShake];
    NSString *fileName = @"未命名文件".yp_localizedString;
    NSString *path = self.filePath;
    NSString *newFilePath = [path stringByAppendingPathComponent:fileName];
    newFilePath = [[YPFileManager shareInstance] uniqueFilePathForPath:newFilePath];
    [[YPFileManager shareInstance] createItemAtPath:newFilePath isDirectory:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFileManagerDidUpdate object:nil];
}

- (void)createFinder {
    [[YPShakeManager shareInstance] mediumShake];
    NSString *fileName = @"未命名文件夹".yp_localizedString;
    NSString *path = self.filePath;
    NSString *newFilePath = [path stringByAppendingPathComponent:fileName];
    newFilePath = [[YPFileManager shareInstance] uniqueFilePathForPath:newFilePath];
    [[YPFileManager shareInstance] createItemAtPath:newFilePath isDirectory:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFileManagerDidUpdate object:nil];
}

- (void)leftClickAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)startLoadData {
    [self viewWillLayoutSubviews];
    [self.viewModel startLoadData];
}

- (void)setupSubviews {
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect boudns = self.view.bounds;
    CGRect f1 = boudns;
    self.tableView.frame = f1;
}

#pragma mark - NSNotification

// 监听键盘防止遮挡输入框
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        UITextField *textField = (UITextField *)[cell yp_findSubviewsOfClass:[UITextField class]].firstObject;
        if (textField.isFirstResponder) {
            CGRect cellRectInWindow = [self.view convertRect:cell.frame toView:nil];
            if (CGRectGetMaxY(cellRectInWindow) > self.view.frame.size.height - keyboardHeight) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
                    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
                }];
            }
        }
    }
}

// 隐藏键盘恢复原样
- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}

#pragma mark - YPFileListViewModelDelegate

- (void)didEndLoadData:(BOOL)hasMore {
    [self.tableView reloadData];
}

#pragma mark - getters | setters

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self.proxy;
        tableView.dataSource = self.proxy;
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

        NSArray *classs = @[
            [UITableViewCell class],
            [YPFileListTableViewCell class],
        ];
        [classs enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tableView registerClass:obj forCellReuseIdentifier:NSStringFromClass(obj)];
        }];
        
        NSArray *headersClasss = @[];
        [headersClasss enumerateObjectsUsingBlock:^(Class  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tableView registerClass:obj forHeaderFooterViewReuseIdentifier:NSStringFromClass(obj)];
        }];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (YPFileListProxy *)proxy {
    if (!_proxy) {
        _proxy = [[YPFileListProxy alloc] initWithViewModel:self.viewModel];
    }
    return _proxy;
}

- (YPFileListViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[YPFileListViewModel alloc] init];
        _viewModel.delegate = self;
        _viewModel.filePath = self.filePath;
        _viewModel.type = self.type;
    }
    return _viewModel;
}

- (NSString *)path {
    return self.filePath;
}

@end
