//
//  YPColorPickerAlert.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/6/4.
//

#import "YPColorPickerAlert.h"
#import "UIColor+YPExtension.h"
#import "YPKitDefines.h"

@interface __YPColorPickerAlertCell : UIView

@property (nonatomic, strong) UIView *colorView;
@property (nonatomic, strong) UILabel *colorTitleLabel;
@property (nonatomic, strong) NSString *hexString;

@end

@implementation __YPColorPickerAlertCell

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.colorTitleLabel];
        [self addSubview:self.colorView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect f1 = bounds;
    f1.size.height = 15;
    f1.size.width = 35;
    f1.origin.y = (bounds.size.height - f1.size.height) / 2;
    f1.origin.x = 20;
    self.colorView.frame = f1;
    
    CGRect f2 = bounds;
    f2.origin.x = CGRectGetMaxX(f1) + 5.f;
    f2.size = [self.colorTitleLabel sizeThatFits:CGSizeZero];
    f2.origin.y = (bounds.size.height - f2.size.height) / 2.f;
    self.colorTitleLabel.frame = f2;
}

#pragma mark - getters | setters

- (UIView *)colorView {
    if (!_colorView) {
        _colorView = [[UIView alloc] init];
        _colorView.layer.borderColor = [UIColor blackColor].CGColor;
        _colorView.layer.borderWidth = 1;
    }
    return _colorView;
}

- (UILabel *)colorTitleLabel {
    if (!_colorTitleLabel) {
        _colorTitleLabel = [[UILabel alloc] init];
        _colorTitleLabel.font = [UIFont systemFontOfSize:22.f];
        _colorTitleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _colorTitleLabel;
}

- (void)setHexString:(NSString *)hexString {
    _hexString = hexString;
    self.colorTitleLabel.text = [NSString stringWithFormat:@"%@",hexString];
    self.colorView.backgroundColor = [UIColor yp_colorWithHexString:hexString];
}

@end


@interface YPColorPickerAlert () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, copy) NSArray <NSString *>*options;
@property (nonatomic, copy) void (^completeBlock)(NSInteger index);
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIToolbar *toolbar;

@end

@implementation YPColorPickerAlert

+ (instancetype)popupWithOptions:(NSArray <NSString *>*)options completeBlock:(void(^)(NSInteger index))completeBlock {
    YPColorPickerAlert *alert = [self popupControllerWithStyle:YPPopupControllerStyleBottom];
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    __YPColorPickerAlertCell *cell = (__YPColorPickerAlertCell *)view;
    if (!cell || [cell isKindOfClass:[__YPColorPickerAlertCell class]]) {
        cell = [[__YPColorPickerAlertCell alloc] init];
    }
    cell.hexString = self.options[row];
    return cell;
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
