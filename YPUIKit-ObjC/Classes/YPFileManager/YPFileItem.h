//
//  YPFileItem.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPFileItem : NSObject

@property (nonatomic, strong) NSString *name;          // 文件/文件夹名称
@property (nonatomic, strong) NSString *path;          // 完整路径
@property (nonatomic, assign) BOOL isDirectory;        // 是否是目录
@property (nonatomic, assign) unsigned long long size; // 文件大小（字节）
@property (nonatomic, strong) NSDate *creationDate;    // 创建时间
@property (nonatomic, strong) NSDate *modificationDate;// 修改时间
@property (nonatomic, assign) BOOL isLoadThumbnail;    // 是否加载过预览图
@property (nonatomic, strong) UIImage *thumbnail;      // 缩略图（仅适用于图片或视频）
@property (nonatomic, strong) NSDictionary *fileAttributes;// 文件属性

- (NSString *)stringForFileSize;

- (void)loadThumbnailWithCompletion:(void (^)(UIImage *thumbnail))completion;

@end

NS_ASSUME_NONNULL_END
