//
//  YPFileListModel.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YPFileItem;

@interface YPFileListModel : NSObject

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, strong) YPFileItem *fileItem;

@end

NS_ASSUME_NONNULL_END
