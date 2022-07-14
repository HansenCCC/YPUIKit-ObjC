//
//  YPButton.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YPButtonContentStyleHorizontal = 0, //左图标，右文本
    YPButtonContentStyleVertical, //上图标，下文本
} YPButtonContentStyle;

@interface YPButton : UIButton

@property (nonatomic, assign) YPButtonContentStyle contentStyle;
@property (nonatomic, assign) NSInteger interitemSpacing;//图标与文字之间的间距，默认是0px
@property (nonatomic, assign) BOOL reverseContent;//是否逆转图标与文字的顺序，默认是NO:图标在左/上,文本在右/下
@property (nonatomic, assign) CGSize imageSize;//图片尺寸值，image.size，默认为(0,0)，代表自动根据图片大小计算

@end

NS_ASSUME_NONNULL_END
