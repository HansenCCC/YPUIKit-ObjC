//
//  YPSingleLineInputViewController.m
//  YPLaboratory
//
//  Created by Hansen on 2023/6/20.
//

#import "YPSingleLineInputViewController.h"

@interface YPSingleLineInputViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation YPSingleLineInputViewController

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
}

- (void)setNavBarButtonItem {
    YPButton *rightButton = [YPButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 44.f, 44.f);
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.tintColor = [UIColor yp_blackColor];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [rightButton addTarget:self action:@selector(didRightBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)didRightBarButtonItem {
    [self.textField endEditing:YES];
    if (self.didCompleteCallback) {
        self.didCompleteCallback(self.textField.text);
    }
    if (self.presentingViewController) {
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
    [self.textField becomeFirstResponder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
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
