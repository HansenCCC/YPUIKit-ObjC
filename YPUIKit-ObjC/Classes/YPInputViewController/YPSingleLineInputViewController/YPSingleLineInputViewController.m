//
//  YPSingleLineInputViewController.m
//  YPLaboratory
//
//  Created by Hansen on 2023/6/20.
//

#import "YPSingleLineInputViewController.h"
#import "UIColor+YPExtension.h"
#import "YPButton.h"
#import "UITextField+YPExtension.h"
#import "NSString+YPExtension.h"

@interface YPSingleLineInputViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation YPSingleLineInputViewController

- (instancetype)init {
    if (self = [super init]) {
        self.maxLength = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarButtonItem];
    [self setupSubviews];
}

- (void)setupSubviews {
    self.view.backgroundColor = [UIColor yp_gray6Color];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.textField];
    [self.textField becomeFirstResponder];
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

- (void)didRightBarButtonItem {
    [self.textField endEditing:YES];
    if (self.didCompleteCallback) {
        self.didCompleteCallback(self.textField.text);
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
    f2.size.height = 44.f;
    self.textField.frame = f2;
}

#pragma mark - setters | getters

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)setMaxLength:(NSUInteger)maxLength {
    _maxLength = maxLength;
    self.textField.yp_maxLength = maxLength;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20.f, 0)];
        _textField.leftView = leftView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.backgroundColor = [UIColor yp_whiteColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:17.f];
        _textField.delegate = self;
    }
    return _textField;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = YES;
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didRightBarButtonItem];
    return YES;
}

@end
