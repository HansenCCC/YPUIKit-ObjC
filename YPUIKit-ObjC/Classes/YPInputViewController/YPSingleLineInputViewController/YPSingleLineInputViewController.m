//
//  YPSingleLineInputViewController.m
//  YPLaboratory
//
//  Created by Hansen on 2023/6/20.
//

#import "YPSingleLineInputViewController.h"

@interface YPSingleLineInputViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;

@end

@implementation YPSingleLineInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yp_gray6Color];
    [self.view addSubview:self.textField];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didRightBarButtonItem:)];
}

- (void)didRightBarButtonItem:(id)sender {
    [self.textField endEditing:YES];
    if (self.didCompleteCallback) {
        self.didCompleteCallback(self.textField.text);
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    CGRect f1 = bounds;
    f1.origin.y = YP_HEIGHT_NAV_BAR;
    f1.size.height = 44.f;
    self.textField.frame = f1;
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

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didRightBarButtonItem:nil];
    return YES;
}

@end
