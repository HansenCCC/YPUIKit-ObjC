//
//  YPTextView.m
//  Pods
//
//  Created by Hansen on 2022/10/12.
//

#import "YPTextView.h"
#import "UIColor+YPExtension.h"

@interface YPTextView ()

@property (nonatomic, strong) UITextView *placeholderView;

@end

@implementation YPTextView

- (instancetype)init {
    if (self = [super init]) {
        self.maxLength = 0;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.placeholderView = [[UITextView alloc] init];
    self.placeholderView.textColor = [UIColor yp_gray2Color];
    self.placeholderView.userInteractionEnabled = NO;
    self.placeholderView.hidden = YES;
    [self addSubview:self.placeholderView];
    //监听输入框变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didTextChange:) name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    if (!self.placeholderView.hidden) {
        CGRect f1 = bounds;
        self.placeholderView.frame = f1;
        [self sendSubviewToBack:self.placeholderView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - action

- (void)didTextChange:(NSNotification *)sender {
    if (sender.object != self){
        return;
    }
    
    [self updatePlaceholderViewHidden];
    [self updateTextWithTextView:self];
    if (self.whenTextDidChange) {
        self.whenTextDidChange(self);
    }
}

- (void)updatePlaceholderViewHidden {
    self.placeholderView.hidden = self.text.length != 0 || self.placeholder.length == 0;
    [self layoutSubviews];
}

- (void)updateTextWithTextView:(YPTextView *)textView {
    NSString *destText = textView.text;
    NSUInteger maxLength = textView.maxLength;
    if (maxLength == 0) {
        // 等于0，不限制字符长度
        return;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (destText.length > maxLength) {
            NSRange range;
            NSUInteger inputLength = 0;
            for (int i = 0; i < destText.length && inputLength <= maxLength; i += range.length) {
                range = [textView.text rangeOfComposedCharacterSequenceAtIndex:i];
                inputLength += [destText substringWithRange:range].length;
                if (inputLength > maxLength) {
                    NSString *newText = [destText substringWithRange:NSMakeRange(0, range.location)];
                    textView.text = newText;
                }
            }
        }
    }
}

#pragma mark - setters | getters

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeFits = [super sizeThatFits:size];
    if (self.text.length == 0) {
        if (self.placeholder.length != 0) {
            sizeFits = [self.placeholderView sizeThatFits:size];
        }
    }
    return sizeFits;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self.placeholderView setFont:font];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderView.textAlignment = textAlignment;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self updatePlaceholderViewHidden];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderView.text = placeholder;
    [self updatePlaceholderViewHidden];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self.placeholderView setContentInset:contentInset];
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    [super setTextContainerInset:textContainerInset];
    [self.placeholderView setTextContainerInset:textContainerInset];
}

- (void)setContentSize:(CGSize)contentSize {
    CGSize oldSize = self.contentSize;
    [super setContentSize:contentSize];
    if (oldSize.height != contentSize.height) {
        if (self.whenContentHeightChange){
            self.whenContentHeightChange(self,contentSize.height);
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.placeholderView.backgroundColor = backgroundColor;
}

@end
