//
//  YPFileListTableViewCell.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import <YPUIKit/YPUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YPFileListModel;

@interface YPFileListTableViewCell : UITableViewCell

@property (nonatomic, strong) YPFileListModel *cellModel;

@end

NS_ASSUME_NONNULL_END
