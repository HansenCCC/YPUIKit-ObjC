//
//  YPButton.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/14.
//

#import "YPButton.h"

@implementation YPButton

- (instancetype)init {
    if (self = [super init]) {
        self.contentStyle = YPButtonContentStyleHorizontal;
        self.interitemSpacing = 0;
        self.reverseContent = NO;
        self.imageSize = CGSizeZero;
    }
    return self;
}

// 计算图片的尺寸大小
- (CGSize)imageSizeWithBounds:(CGRect)bounds {
    UIImage *image = [self imageForState:self.state];
    CGSize imageSize = image.size;
    CGSize maxSize = bounds.size;
    CGSize limitImageSize = self.imageSize;
    if (CGSizeEqualToSize(limitImageSize, CGSizeZero)) {
        imageSize = [self limitSize:imageSize inSize:maxSize];
    } else {
        if (limitImageSize.width == 0) {
            //不限宽度
            imageSize.width = limitImageSize.height*imageSize.width / imageSize.height;
            imageSize.height = limitImageSize.height;
        } else if (limitImageSize.height == 0) {
            //不限高度
            imageSize.height = limitImageSize.width*imageSize.height / imageSize.width;
            imageSize.width = limitImageSize.width;
        } else {
            imageSize = limitImageSize;
        }
    }
    return imageSize;
}

// 限制size在maxSize内,如果maxSize有一边为0,代表那一边不限制
- (CGSize)limitSize:(CGSize)size inSize:(CGSize)maxSize {
    CGSize s = size;
    if (maxSize.width == 0 && maxSize.height > 0) {
        s.height = MIN(maxSize.height, size.height);
    } else if (maxSize.height == 0 && maxSize.width > 0) {
        s.width = MIN(maxSize.width, size.width);
    } else if (maxSize.width==0 && maxSize.height == 0) {
        s = size;
    } else {
        if (s.height > maxSize.height) {
            s.width *= (maxSize.height / size.height);
            s.height = maxSize.height;
        } else if (size.width > maxSize.width) {
            s.height *= (maxSize.width / size.width);
            s.width = maxSize.width;
        }
    }
    return s;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGFloat interitemSpacing = self.interitemSpacing;
    //image
    CGRect f1 = bounds;
    UIImage *image = [self imageForState:self.state];
    BOOL hiddenImage = (image == nil);
    //title
    CGRect f2 = bounds;
    NSString *title = [self titleForState:self.state];
    BOOL hiddenTitle = (title.length == 0);
    
    switch (self.contentStyle) {
        case YPButtonContentStyleHorizontal: {
            CGSize f1_size = image.size;
            if (!hiddenImage) {
                f1_size = [self imageSizeWithBounds:bounds];
            }
            CGSize f2_size = [self.titleLabel sizeThatFits:bounds.size];
            if (!hiddenTitle) {
                f2_size = [self limitSize:f2_size inSize:bounds.size];
            }
            f1.size = f1_size;
            f2.size = f2_size;
            if (!hiddenImage && !hiddenTitle) {
                f2.size.width = MIN(f2_size.width,(bounds.size.width - f1_size.width - interitemSpacing));
                if (self.reverseContent) {
                    f2.origin.y = (bounds.size.height - f2.size.height) / 2;
                    f2.origin.x = (bounds.size.width - f1.size.width - interitemSpacing - f2.size.width) / 2;
                    f1.origin.y = (bounds.size.height - f1.size.height) / 2;
                    f1.origin.x = CGRectGetMaxX(f2) + interitemSpacing;
                }else{
                    f1.origin.y = (bounds.size.height - f1.size.height) / 2;
                    f1.origin.x = (bounds.size.width - f1.size.width - interitemSpacing - f2.size.width) / 2;
                    f2.origin.y = (bounds.size.height - f2.size.height) / 2;
                    f2.origin.x = CGRectGetMaxX(f1) + interitemSpacing;
                }
            }else{
                if (!hiddenImage) {
                    f1.origin.x = (bounds.size.width - f1.size.width) / 2;
                    f1.origin.y = (bounds.size.height - f1.size.height) / 2;
                } else if (!hiddenTitle) {
                    f2.origin.x = (bounds.size.width - f2.size.width) / 2;
                    f2.origin.y = (bounds.size.height - f2.size.height) / 2;
                }
            }
        }
            break;
        case YPButtonContentStyleVertical: {
            CGSize f1_size = image.size;
            if (!hiddenImage) {
                f1_size = [self imageSizeWithBounds:bounds];
            }
            CGSize f2_size = [self.titleLabel sizeThatFits:bounds.size];
            if (!hiddenTitle) {
                f2_size = [self limitSize:f2_size inSize:bounds.size];
            }
            f1.size = f1_size;
            f2.size = f2_size;
            if (!hiddenImage && !hiddenTitle) {
                f2.size.height = MIN(f2_size.height,(bounds.size.height - f1_size.height - interitemSpacing));
                f1.origin.x = (bounds.size.width - f1.size.width) / 2;
                f1.origin.y = (bounds.size.height - f1.size.height - interitemSpacing - f2.size.height) / 2;
                f2.origin.x = (bounds.size.width - f2.size.width) / 2;
                f2.origin.y = CGRectGetMaxY(f1) + interitemSpacing;
            } else {
                if (!hiddenImage) {
                    f1.origin.x = (bounds.size.width - f1.size.width) / 2;
                    f1.origin.y = (bounds.size.height - f1.size.height) / 2;
                }else if (!hiddenTitle) {
                    f2.origin.x = (bounds.size.width - f2.size.width) / 2;
                    f2.origin.y = (bounds.size.height - f2.size.height) / 2;
                }
            }
        }
            break;
        default:
            break;
    }
    self.imageView.frame = f1;
    self.titleLabel.frame = f2;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize sizeFits = [super sizeThatFits:size];
    CGRect bounds = CGRectZero;
    bounds.size = size;
    if (bounds.size.width == 0) {
        bounds.size.width = 9999;
    }
    if (bounds.size.height == 0) {
        bounds.size.height = 9999;
    }
    CGFloat interitemSpacing = self.interitemSpacing;
    //image
    CGRect f1 = bounds;
    UIImage *image = [self imageForState:self.state];
    BOOL hiddenImage = (image == nil);
    //title
    CGRect f2 = bounds;
    NSString *title = [self titleForState:self.state];
    BOOL hiddenTitle = (title.length == 0);
    
    if (hiddenTitle) {
        NSString *title = [self titleForState:self.state];
        if (title.length != self.titleLabel.text.length) {
            self.titleLabel.text = title;
            hiddenTitle = NO;
        }
    }
    switch (self.contentStyle) {
        case YPButtonContentStyleHorizontal:
        {
            CGSize f1_size = image.size;
            if (!hiddenImage) {
                f1_size = [self imageSizeWithBounds:bounds];
            }
            CGSize f2_size = [self.titleLabel sizeThatFits:bounds.size];
            if (!hiddenTitle) {
                f2_size = [self limitSize:f2_size inSize:bounds.size];
            }
            f1.size = f1_size;
            f2.size = f2_size;
            if (!hiddenImage&&!hiddenTitle) {
                f2.size.width = MIN(f2_size.width, (bounds.size.width - f1_size.width - interitemSpacing));
                sizeFits.width = f1.size.width + f2.size.width + interitemSpacing;
                sizeFits.height = MAX(f1.size.height, f2.size.height);
            }else{
                if (!hiddenImage) {
                    sizeFits = f1_size;
                }else if (!hiddenTitle) {
                    sizeFits = f2_size;
                }
            }
        }
            break;
        case YPButtonContentStyleVertical://上图标,下文本
        {
            CGSize f1_size = image.size;
            if (!hiddenImage) {
                f1_size = [self imageSizeWithBounds:bounds];
            }
            CGSize f2_size = [self.titleLabel sizeThatFits:bounds.size];
            if (!hiddenTitle) {
                f2_size = [self limitSize:f2_size inSize:bounds.size];
            }
            f1.size = f1_size;
            f2.size = f2_size;
            if (!hiddenImage&&!hiddenTitle) {
                f2.size.height = MIN(f2_size.height, (bounds.size.height - f1_size.height - interitemSpacing));
                sizeFits.height = f1.size.height + f2.size.height + interitemSpacing;
                sizeFits.width = MAX(f1.size.width, f2.size.width);
            }else{
                if (!hiddenImage) {
                    sizeFits = f1_size;
                }else if (!hiddenTitle) {
                    sizeFits = f2_size;
                }
            }
        }
            break;
        default:
            break;
    }
    //加上内边距
    UIEdgeInsets contentInsets = self.contentEdgeInsets;
    sizeFits.width += contentInsets.left + contentInsets.right;
    sizeFits.height += contentInsets.top + contentInsets.bottom;
    return sizeFits;
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

#pragma mark - setter

- (void)setContentStyle:(YPButtonContentStyle)contentStyle {
    _contentStyle = contentStyle;
    [self layoutIfNeeded];
}

- (void)setInteritemSpacing:(NSInteger)interitemSpacing {
    _interitemSpacing = interitemSpacing;
    [self layoutIfNeeded];
}

- (void)setReverseContent:(BOOL)reverseContent {
    _reverseContent = reverseContent;
    [self layoutIfNeeded];
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    [self layoutIfNeeded];
}

@end
