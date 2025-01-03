//
//  YPColorPickerViewController.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/1/3.
//

#import "YPColorPickerViewController.h"

@interface YPColorPickerViewController () <UIColorPickerViewControllerDelegate>

@property (nonatomic, copy) void(^completeBlock)(UIColor *selectedColor);

@end

@implementation YPColorPickerViewController

+ (instancetype)popupPickerWithCompletion:(void(^)(UIColor *selectedColor))completion {
    YPColorPickerViewController *vc = [[YPColorPickerViewController alloc] initPrivate];
    vc.completeBlock = completion;
    vc.delegate = vc;
    return vc;
}

- (instancetype)initPrivate {
    return [super init];
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"YPColorPickerViewController"
                                   reason:@"Use [YPColorPickerViewController popupPickerWithCompletion:] initialize"
                                 userInfo:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    NSLog(@"['%@ released']",self.class);
}

#pragma mark - UIColorPickerViewControllerDelegate

- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController  API_AVAILABLE(ios(14.0)){
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.completeBlock) {
            self.completeBlock([self.selectedColor copy]);
        }
    });
}

@end
