//
//  YPPickerAlert.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/6/4.
//

#import "YPPickerAlert.h"
#import "YPKitDefines.h"

@interface YPPickerAlert () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSArray <NSString *>*options;
@property (nonatomic, copy) void (^completeBlock)(NSInteger index);
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation YPPickerAlert

+ (instancetype)popupWithOptions:(NSArray <NSString *>*)options completeBlock:(void(^)(NSInteger index))completeBlock {
    YPPickerAlert *alert = [self popupControllerWithStyle:YPPopupControllerStyleBottom];
    alert.options = options;
    alert.currentIndex = 0;
    alert.completeBlock = completeBlock;
    alert.isEnableTouchMove = YES;
    return alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.contentView addSubview:self.toolbar];
    [self.contentView addSubview:self.pickerView];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)popupLayoutSubviews {
    [super popupLayoutSubviews];
    CGRect bounds = self.contentView.bounds;
    
    CGRect f1 = bounds;
    f1.size = [self.toolbar sizeThatFits:CGSizeZero];
    f1.size.width = bounds.size.width;
    f1.size.height = 44.f;
    self.toolbar.frame = f1;
    
    CGRect f2 = bounds;
    f2.size = [self.pickerView sizeThatFits:CGSizeZero];
    f2.size.width = bounds.size.width;
    f2.origin.y = CGRectGetMaxY(f1);
    self.pickerView.frame = f2;
    
    CGRect f3 = self.contentView.frame;
    f3.size.height = CGRectGetMaxY(f2) + YP_HEIGHT_IPHONEX_BOTTOM_MARGIN;
    f3.origin.y = self.view.bounds.size.height - f3.size.height;
    self.contentView.frame = f3;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.options.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.options[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

#pragma mark - action

- (void)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped:(id)sender {
    if (self.completeBlock) {
        self.completeBlock(self.currentIndex);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter | setters

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                      target:self
                                                                                      action:@selector(cancelButtonTapped:)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self
                                                                                    action:@selector(doneButtonTapped:)];
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
        _toolbar.items = @[cancelButton, flexibleSpace, doneButton];

    }
    return _toolbar;
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (currentIndex < self.options.count) {
        _currentIndex = currentIndex;
        [self.pickerView selectRow:currentIndex inComponent:0 animated:NO];
    } else {
        _currentIndex = 0;
    }
}

@end
