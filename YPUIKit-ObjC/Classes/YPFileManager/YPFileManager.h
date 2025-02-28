//
//  YPFileManager.h
//  YPVideoPlayer
//
//  Created by Hansen on 2025/2/17.
//

#import <Foundation/Foundation.h>
#import "YPFileItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YPFileSortByName,
    YPFileSortByType,
    YPFileSortByModificationDate,
    YPFileSortByCreationDate,
    YPFileSortBySize
} YPFileSortOption;

typedef enum : NSUInteger {
    YPFileLayoutTable,      // 表格布局（Table）
    YPFileLayoutCollection  // 网格布局（Collection）
} YPFileLayoutOption;

extern NSString *const kNotificationFileManagerDidUpdate;

@interface YPFileManager : NSObject

// 当前应用文件路径：用于存放应用相关文件的根目录路径
@property (nonatomic, readonly) NSString *appFilesPath;

// 文档目录路径：用于存放用户生成的文档或数据文件
@property (nonatomic, readonly) NSString *documentsPath;

// Library目录路径：用于存放应用的配置文件或持久化数据（不可见于用户）
@property (nonatomic, readonly) NSString *libraryPath;

// 缓存目录路径：用于存放缓存文件，系统可能会自动清理
@property (nonatomic, readonly) NSString *cachesPath;

// 应用程序目录路径：用于存放应用本身相关的内容
@property (nonatomic, readonly) NSString *applicationPath;

// 临时文件目录路径：用于存放临时数据，系统可能会在设备空间紧张时清理
@property (nonatomic, readonly) NSString *tmpPath;

@property (nonatomic, assign) YPFileLayoutOption layoutOption;
@property (nonatomic, assign) YPFileSortOption sortOption;
@property (nonatomic, assign) BOOL ascending;
@property (nonatomic, strong) NSString *copiedItemPath;

+ (instancetype)shareInstance;

/// 获取指定路径的文件信息
/// - Parameter filePath: 文件路径
- (YPFileItem *)fileItemAtPath:(NSString *)filePath;

/// 获取文件列表
/// - Parameter directoryPath: 文件夹路径
- (NSArray<YPFileItem *> *)listFilesInDirectoryAtPath:(NSString *)directoryPath;

/// 获取文件列表
/// - Parameters:
///   - directoryPath: 文件夹路径
///   - searchKeyword: 搜索关键词，为空则是所有
///   - sortOption: 排序方式
///   - ascending: 是否是升序
- (NSArray<YPFileItem *> *)listFilesInDirectoryAtPath:(NSString *)directoryPath search:(nullable NSString *)searchKeyword sortOption:(YPFileSortOption)sortOption ascending:(BOOL)ascending;


/// 创建文件或文件夹到指定路径
/// - Parameters:
///   - path: 文件夹或者文件路径
///   - isDirectory: 是否是文件夹
- (BOOL)createItemAtPath:(NSString *)path isDirectory:(BOOL)isDirectory;

/// 复制文件或文件夹到指定路径 例如：/a/b/c.txt /a/c/b.txt |  /a/b /a/c
/// - Parameters:
///   - sourcePath: 文件或者文件夹路径
///   - destinationPath: 目标路径
- (BOOL)copyItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath;

/// 移动文件或文件夹到指定路径 例如：/a/b/c.txt /a/c/b.txt |  /a/b /a/c
/// - Parameters:
///   - sourcePath: 文件或者文件夹路径
///   - destinationPath: 目标路径
- (BOOL)moveItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath;

/// 重命名文件或文件夹 例如：/a/b/c.txt/a/b/d.txt |  /a/b /a/c
/// - Parameters:
///   - sourcePath: 文件或者文件夹路径
///   - destinationPath: 目标路径
- (BOOL)renameItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath;

/// 确保目录存在，不存在则创建
/// - Parameter path: 文件夹路径
- (BOOL)ensureDirectoryExistsAtPath:(NSString *)path;

/// 删除文件或文件夹
/// - Parameter path: 目标路径
- (BOOL)deleteItemAtPath:(NSString *)path;

/// 判断是否是目录
/// - Parameter path: yes or no
- (BOOL)isDirectoryAtPath:(NSString *)path;

/// 判断是否是文件
/// - Parameter path: yes or no
- (BOOL)isFileAtPath:(NSString *)path;

/// 判断文件或目录是否存在
/// - Parameter path: yes or no
- (BOOL)existsAtPath:(NSString *)path;

/// 获取文件缩略图
/// - Parameter filePath: 文件路径
- (UIImage *)generateThumbnailForFileAtPath:(NSString *)filePath;

/// 获取一个唯一的文件路径，避免与已存在的文件或文件夹重名
/// 如果目标路径已存在，则会根据文件名加上数字后缀（如 "file 1.txt"）来生成新的路径
/// - Parameter path: 要检查并生成唯一路径的文件路径
/// @return 如果目标路径不存在，返回原路径；如果目标路径已存在，返回一个唯一的路径
- (NSString *)uniqueFilePathForPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
