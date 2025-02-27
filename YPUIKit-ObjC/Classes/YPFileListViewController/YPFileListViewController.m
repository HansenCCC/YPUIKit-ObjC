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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightClickAction:)];
    if (self.isRoot) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leftClickAction:)];
    }
}

- (void)rightClickAction:(id)sender {
    
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

- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        UITextField *textField = (UITextField *)[cell yp_findSubviewsOfClass:[UITextField class]].firstObject;
        if (textField.isFirstResponder) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
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
    }
    return _viewModel;
}

@end
