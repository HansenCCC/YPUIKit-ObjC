//
//  YPMultiLineInputViewController.m
//  YPLaboratory
//
//  Created by Hansen on 2023/6/20.
//

#import "YPMultiLineInputViewController.h"
#import "YPTextView.h"
#import "UIColor+YPExtension.h"
#import "YPButton.h"
#import "NSString+YPExtension.h"

@interface YPMultiLineInputViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YPTextView *textView;
@property (nonatomic, strong) UIView *countView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation YPMultiLineInputViewController

- (instancetype)init {
    if (self = [super init]) {
        self.maxLength = 100;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarButtonItem];
    [self setupSubviews];
    [self needUpdateCountLabel];
    [self.textView becomeFirstResponder];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor yp_gray6Color];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.textView];
    [self.scrollView addSubview:self.countView];
    [self.countView addSubview:self.countLabel];
}

- (void)setNavBarButtonItem {
    YPButton *rightButton = [YPButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44.f, 44.f);
    [rightButton setTitle:@"保存".yp_localizedString forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor yp_blackColor];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [rightButton addTarget:self action:@selector(didRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)needUpdateCountLabel {
    self.countLabel.text = [NSString stringWithFormat:@"%@",@(self.maxLength - self.textView.text.length)];
}

- (void)didRightBarButtonItem {
    [self.textView endEditing:YES];
    if (self.didCompleteCallback) {
        self.didCompleteCallback(self.textView.text);
    }
    if (self.navigationController && [self.navigationController.viewControllers containsObject:self]) {
        // present 但是有导航栏子视图
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        // present 过来的
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // push 过来的
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    CGRect f1 = bounds;
    self.scrollView.frame = f1;
    
    CGRect f2 = bounds;
    f2.size.height = 80.f;
    self.textView.frame = f2;
    
    CGRect f3 = bounds;
    f3.size.height = 24.f;
    f3.origin.y = CGRectGetMaxY(f2);
    self.countView.frame = f3;
    
    CGRect f4 = bounds;
    f4.size = f3.size;
    f4.size.width -= 10.f;
    self.countLabel.frame = f4;
}

#pragma mark - setters | getters

- (void)setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    [self needUpdateCountLabel];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textView.placeholder = placeholder;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    _maxLength = maxLength;
    self.textView.maxLength = maxLength;
    [self needUpdateCountLabel];
}

- (YPTextView *)textView {
    if (!_textView) {
        _textView = [[YPTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:17.f];
        __weak typeof(self) weakSelf = self;
        _textView.whenTextDidChange = ^(YPTextView * _Nonnull textView) {
            [weakSelf needUpdateCountLabel];
        };
    }
    return _textView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (UIView *)countView {
    if (!_countView) {
        _countView = [[UIView alloc] init];
        _countView.backgroundColor = [UIColor yp_whiteColor];
    }
    return _countView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:16.f];
        _countLabel.textColor = [UIColor yp_grayColor];
        _countLabel.textAlignment = NSTextAlignmentRight;
    }
    return _countLabel;
}

@end
