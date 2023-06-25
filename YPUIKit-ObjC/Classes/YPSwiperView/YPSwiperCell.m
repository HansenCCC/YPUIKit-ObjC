//
//  YPSwiperCell.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/6/25.
//

#import "YPSwiperCell.h"
#import "UIColor+YPExtension.h"

@implementation YPSwiperCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor yp_randomColor];
    }
    return self;
}

@end
