//
//  YPDatePickerAlert.m
//  Pods-YPUIKit-ObjC_Example
//
//  Created by Hansen on 2023/6/4.
//

#import "YPDatePickerAlert.h"
#import "YPKitDefines.h"

@interface YPDatePickerAlert ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, copy) void (^completeBlock)(NSDate *date);

@end

@implementation YPDatePickerAlert

+ (instancetype)popupWithDate:(NSDate *)date completeBlock:(void(^)(NSDate *date))completeBlock {
    YPDatePickerAlert *alert = [self popupControllerWithStyle:YPPopupControllerStyleBottom];
    alert.date = date;
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
    [self popupLayoutSubviews];
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

#pragma mark - action

- (void)cancelButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneButtonTapped:(id)sender {
    if (self.completeBlock) {
        self.completeBlock(self.date);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dateChanged:(UIPickerView *)pickerView {
    _date = [self.pickerView date];
}

#pragma mark - getter | setters

- (UIDatePicker *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIDatePicker alloc] init];
        [_pickerView addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        if (@available(iOS 13.4, *)) {
            _pickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
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

- (void)setDate:(NSDate *)date {
    _date = date;
    self.pickerView.date = date;
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.pickerView.datePickerMode = datePickerMode;
}

@end
