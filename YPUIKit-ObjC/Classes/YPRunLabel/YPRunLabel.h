//
//  YPRunLabel.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2024/10/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPRunLabel : UIView

@property (nonatomic, assign) CGFloat scrollSpeed; /// 移动速度 default 1.0f
@property (nonatomic, readonly) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
