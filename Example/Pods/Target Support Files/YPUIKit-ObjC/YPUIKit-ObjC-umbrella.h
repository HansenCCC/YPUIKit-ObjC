#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "YPAlertView.h"
#import "YPAVCaptureSessionView.h"
#import "YPBadgeView.h"
#import "YPButton.h"
#import "NSData+YPExtension.h"
#import "NSDate+YPExtension.h"
#import "NSDictionary+YPExtension.h"
#import "NSObject+YPExtension.h"
#import "NSString+YPExtension.h"
#import "NSTimer+YPExtension.h"
#import "UIButton+YPExtension.h"
#import "UIColor+YPExtension.h"
#import "UIImage+YPExtension.h"
#import "UILabel+YPExtension.h"
#import "UINavigationBar+YPExtension.h"
#import "UIScrollView+YPExtension.h"
#import "UITableViewCell+YPExtension.h"
#import "UITextField+YPExtension.h"
#import "UITextView+YPExtension.h"
#import "UIView+YPExtension.h"
#import "UIViewController+YPExtension.h"
#import "YPCategoryHeader.h"
#import "NSString+YPFileFormat.h"
#import "UIImage+YPResource.h"
#import "YPFileBrowserElementCell.h"
#import "YPFileInfo.h"
#import "YPBaseQLPreviewController.h"
#import "YPFileBrowserController.h"
#import "YPFormElement.h"
#import "YPImagePickerController.h"
#import "YPInputHeader.h"
#import "YPMultiLineInputViewController.h"
#import "YPSingleLineInputViewController.h"
#import "YPKeychain.h"
#import "YPKitDefines.h"
#import "YPLoadingView.h"
#import "YPLog.h"
#import "YPColorPickerAlert.h"
#import "YPDatePickerAlert.h"
#import "YPPickerAlert.h"
#import "YPPopupHeader.h"
#import "YPPopupAnimatedTransitioning.h"
#import "YPPopupController.h"
#import "YPPurchaseManager.h"
#import "YPRunLabel.h"
#import "YPShakeManager.h"
#import "YPSwiperView.h"
#import "YPTextView.h"
#import "YPUIKit.h"
#import "YPViewController.h"

FOUNDATION_EXPORT double YPUIKitVersionNumber;
FOUNDATION_EXPORT const unsigned char YPUIKitVersionString[];

