//
//  YPColorPickerViewController.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/1/3.
//

#import <UIKit/UIKit.h>

API_AVAILABLE(ios(14.0))
@interface YPColorPickerViewController : UIColorPickerViewController

+ (instancetype)popupPickerWithCompletion:(void(^)(UIColor *selectedColor))completion;

@end
