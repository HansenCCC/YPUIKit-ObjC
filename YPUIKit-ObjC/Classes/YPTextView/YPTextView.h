//
//  YPTextView.h
//  Pods
//
//  Created by Hansen on 2022/10/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YPTextView;

typedef void(^YPTextViewHeightChange)(YPTextView *textView, CGFloat newHeight);
typedef void(^YPTextViewTextDidChange)(YPTextView *textView);

@interface YPTextView : UITextView

@property (nonatomic, copy) YPTextViewHeightChange whenContentHeightChange;
@property (nonatomic, copy) YPTextViewTextDidChange whenTextDidChange;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

@end

NS_ASSUME_NONNULL_END
