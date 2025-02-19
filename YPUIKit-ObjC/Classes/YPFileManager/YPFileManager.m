//
//  YPFileManager.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/2/17.
//

#import "YPFileManager.h"
#import "YPFileItem.h"
#import <AVFoundation/AVFoundation.h>
#import <PDFKit/PDFKit.h>
#import <QuickLook/QuickLook.h>
#import "YPCategoryHeader.h"

NSString *const kNotificationFileManagerDidUpdate = @"kNotificationFileManagerDidUpdate";
NSString *const kYPFileManagerLayoutOptionKey = @"kYPFileManagerLayoutOptionKey";
NSString *const kYPFileManagerSortOptionKey = @"kYPFileManagerSortOptionKey";
NSString *const kYPFileManagerAscendingKey = @"kYPFileManagerAscendingKey";

@interface YPFileManager ()

@property (nonatomic, assign) YPFileLayoutOption cache_layoutOption;
@property (nonatomic, assign) YPFileSortOption cache_sortOption;
@property (nonatomic, assign) BOOL cache_ascending;

@end

@implementation YPFileManager

+ (instancetype)shareInstance {
    static YPFileManager *m = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[YPFileManager alloc] init];
        // 检查NSUserDefaults中是否有值，如果没有，设置默认值
        if (![[NSUserDefaults standardUserDefaults] integerForKey:kYPFileManagerLayoutOptionKey]) {
            m.layoutOption = NO;
            m.cache_layoutOption = m.layoutOption;
        }
        if (![[NSUserDefaults standardUserDefaults] integerForKey:kYPFileManagerSortOptionKey]) {
            m.sortOption = YPFileSortByName;
            m.cache_sortOption = m.sortOption;
        }
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kYPFileManagerAscendingKey]) {
            m.ascending = NO;
            m.cache_ascending = m.ascending;
        }
    });
    return m;
}

+ (void)load {
    NSString *path = [[YPFileManager shareInstance] appFilesPath];
    [[YPFileManager shareInstance] ensureDirectoryExistsAtPath:path];
}

#pragma mark - action

/// 获取指定路径的文件信息
- (YPFileItem *)fileItemAtPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *attributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    if (!attributes) return nil;
    YPFileItem *fileItem = [[YPFileItem alloc] init];
    fileItem.name = filePath.lastPathComponent;
    fileItem.path = filePath;
    fileItem.isDirectory = [attributes[NSFileType] isEqualToString:NSFileTypeDirectory];
    fileItem.size = [attributes[NSFileSize] unsignedLongLongValue];
    fileItem.creationDate = attributes[NSFileCreationDate];
    fileItem.modificationDate = attributes[NSFileModificationDate];
    fileItem.fileAttributes = [attributes copy];
    fileItem.isLoadThumbnail = NO;
    return fileItem;
}

/// 获取文件列表
- (NSArray<YPFileItem *> *)listFilesInDirectoryAtPath:(NSString *)directoryPath {
    return [self listFilesInDirectoryAtPath:directoryPath search:nil sortOption:self.sortOption ascending:self.ascending];
}

/// 获取文件列表
- (NSArray<YPFileItem *> *)listFilesInDirectoryAtPath:(NSString *)directoryPath search:(NSString *)searchKeyword sortOption:(YPFileSortOption)sortOption ascending:(BOOL)ascending {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableArray <YPFileItem *> *fileItems = [[NSMutableArray alloc] init];
    NSError *error = nil;
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
    if (error) {
        NSLog(@"无法获取目录内容: %@, 错误: %@", directoryPath, error.localizedDescription);
        return fileItems;
    }
    for (NSString *fileName in contents) {
        NSString *fullPath = [directoryPath stringByAppendingPathComponent:fileName];
        YPFileItem *fileItem = [self fileItemAtPath:fullPath];
        if (!fileItem) continue;
        if (searchKeyword.length > 0 && [fileItem.name rangeOfString:searchKeyword options:NSCaseInsensitiveSearch].location == NSNotFound) {
            continue;
        }
        [fileItems addObject:fileItem];
    }
    // 排序
    [fileItems sortUsingComparator:^NSComparisonResult(YPFileItem *obj1, YPFileItem *obj2) {
        NSComparisonResult result = NSOrderedSame;
        switch (sortOption) {
            case YPFileSortByName:
                result = [obj1.name compare:obj2.name options:NSCaseInsensitiveSearch];
                break;
            case YPFileSortByType: {
                NSString *ext1 = obj1.name.pathExtension.lowercaseString ?: @"";
                NSString *ext2 = obj2.name.pathExtension.lowercaseString ?: @"";
                result = [ext1 compare:ext2];
                break;
            }
            case YPFileSortByModificationDate:
                result = [obj1.modificationDate compare:obj2.modificationDate];
                break;
            case YPFileSortByCreationDate:
                result = [obj1.creationDate compare:obj2.creationDate];
                break;
            case YPFileSortBySize:
                if (obj1.size < obj2.size) {
                    result = NSOrderedAscending;
                } else if (obj1.size > obj2.size) {
                    result = NSOrderedDescending;
                } else {
                    result = NSOrderedSame;
                }
                break;
        }
        // 控制正序或逆序
        return ascending ? result : -result;
    }];
    return fileItems;
}

/// 复制文件或文件夹到指定路径
- (BOOL)copyItemAtPath:(NSString *)sourcePath toPath:(NSString *)destinationPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![self existsAtPath:sourcePath]) {
        NSLog(@"复制失败，源路径不存在: %@", sourcePath);
        return NO;
    }
    if ([self existsAtPath:destinationPath]) {
        NSLog(@"复制失败，目标已存在: %@", sourcePath);
        return NO;
    }
    // 确保目标目录存在
    NSString *destinationDirectory = [destinationPath stringByDeletingLastPathComponent];
    [self ensureDirectoryExistsAtPath:destinationDirectory];
    NSError *error = nil;
    BOOL success = [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    if (!success) {
        NSLog(@"复制失败: %@ -> %@，错误: %@", sourcePath, destinationPath, error.localizedDescription);
    }
    return success;
}

/// 确保目录存在，不存在则创建
- (BOOL)ensureDirectoryExistsAtPath:(NSString *)path {
    if ([self isDirectoryAtPath:path]) {
        return YES; // 目录已存在，直接返回
    }
    NSError *error = nil;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (!success) {
        NSLog(@"创建目录失败: %@, 错误信息: %@", path, error.localizedDescription);
    }
    return success;
}

/// 删除文件或文件夹
- (BOOL)deleteItemAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 确保文件或文件夹存在
    if ([self existsAtPath:path]) {
        NSLog(@"删除失败，路径不存在: %@", path);
        return NO;
    }
    NSError *error = nil;
    BOOL success = [fileManager removeItemAtPath:path error:&error];
    if (!success) {
        NSLog(@"删除失败: %@，错误: %@", path, error.localizedDescription);
    }
    return success;
}

// 判断是否是目录
- (BOOL)isDirectoryAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory;
}

// 判断是否是文件
- (BOOL)isFileAtPath:(NSString *)path {
    BOOL isDirectory = NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory;
}

// 判断文件或目录是否存在
- (BOOL)existsAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark - private

///  获取文件缩略图
- (UIImage *)generateThumbnailForFileAtPath:(NSString *)filePath {
    NSString *extension = [filePath pathExtension].lowercaseString;
    if ([@[@"png", @"jpg", @"jpeg", @"gif", @"bmp", @"tiff", @"heif"] containsObject:extension]) {
        return [self generateThumbnailForImageAtPath:filePath]; // 图片
    } else if ([@[@"mp4", @"mov", @"avi", @"mkv", @"wmv"] containsObject:extension]) {
        return [self generateThumbnailForVideoAtPath:filePath]; // 视频
    } else if ([extension isEqualToString:@"pdf"]) {
        return [self generateThumbnailForPDFAtPath:filePath]; // PDF
    } else if ([@[@"doc", @"docx", @"xls", @"xlsx", @"ppt", @"pptx"] containsObject:extension]) {
        return [self generateThumbnailForPDFAtPath:filePath]; // Office 文档
    } else if ([@[@"txt", @"html"] containsObject:extension]) {
        return [self generateTextPreviewAtPath:filePath]; // 文本文件或 HTML 文件
    }
    return nil;
}

/// pdf 缩略图
- (UIImage *)generateThumbnailForPDFAtPath:(NSString *)pdfPath {
    NSURL *url = [NSURL fileURLWithPath:pdfPath];
    PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:url];
    if (pdfDocument) {
        PDFPage *firstPage = [pdfDocument pageAtIndex:0]; // 获取第一页
        CGSize pageSize = [firstPage boundsForBox:kPDFDisplayBoxMediaBox].size;
        UIGraphicsBeginImageContext(pageSize);
        [firstPage drawWithBox:kPDFDisplayBoxMediaBox toContext:UIGraphicsGetCurrentContext()];
        UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return thumbnail;
    }
    return nil;
}

/// 文本和html 缩略图
- (UIImage *)generateTextPreviewAtPath:(NSString *)filePath {
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *previewText = content.length > 100 ? [content substringToIndex:100] : content;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text = previewText;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.font = [UIFont systemFontOfSize:12];
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0);
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}

///  生成图片缩略图
- (UIImage *)generateThumbnailForImageAtPath:(NSString *)imagePath {
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) return nil;
    // 目标缩略图大小
    CGSize targetSize = CGSizeMake(100, 100);
    // 计算等比缩放尺寸
    CGFloat aspectRatio = image.size.width / image.size.height;
    CGSize scaledSize;
    if (image.size.width > image.size.height) {
        // 宽图，以宽为100，计算等比高
        scaledSize = CGSizeMake(targetSize.width, targetSize.width / aspectRatio);
    } else {
        // 高图，以高为100，计算等比宽
        scaledSize = CGSizeMake(targetSize.height * aspectRatio, targetSize.height);
    }
    // 创建缩略图
    UIGraphicsBeginImageContextWithOptions(scaledSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnail;
}


/// 生成视频缩略图失败
- (UIImage *)generateThumbnailForVideoAtPath:(NSString *)videoPath {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;

    CMTime time = CMTimeMake(1, 1);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (error) {
        NSLog(@"生成视频缩略图失败: %@", error.localizedDescription);
        return nil;
    }
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbnail;
}

/// 处理文件或目录重名问题（macOS 风格：文件名 + 空格 + 数字）
- (NSString *)uniqueFilePathForPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        return path; // 目标路径不存在，直接使用
    }
    NSString *directory = [path stringByDeletingLastPathComponent];
    NSString *fileName = [path lastPathComponent];
    NSString *extension = [fileName pathExtension];
    NSString *baseName = [fileName stringByDeletingPathExtension];
    int counter = 1;
    NSString *newPath = path;
    while ([fileManager fileExistsAtPath:newPath]) {
        NSString *newFileName = extension.length > 0
            ? [NSString stringWithFormat:@"%@ %d.%@", baseName, counter, extension]
            : [NSString stringWithFormat:@"%@ %d", baseName, counter];
        newPath = [directory stringByAppendingPathComponent:newFileName];
        counter++;
    }
    return newPath;
}

#pragma mark - setters | getters

- (YPFileLayoutOption)layoutOption {
    return self.cache_layoutOption;
}

- (void)setLayoutOption:(YPFileLayoutOption)layoutOption {
    [[NSUserDefaults standardUserDefaults] setInteger:layoutOption forKey:kYPFileManagerLayoutOptionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.cache_layoutOption = layoutOption;
}

- (YPFileSortOption)sortOption {
    return self.cache_sortOption;
}

- (void)setSortOption:(YPFileSortOption)sortOption {
    [[NSUserDefaults standardUserDefaults] setInteger:sortOption forKey:kYPFileManagerSortOptionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.cache_sortOption = sortOption;
}

- (BOOL)ascending {
    return self.cache_ascending;
}

- (void)setAscending:(BOOL)ascending {
    [[NSUserDefaults standardUserDefaults] setBool:ascending forKey:kYPFileManagerAscendingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.cache_ascending = ascending;
}

// 返回 appFiles 文件夹名称
- (NSString *)appFiles {
    return @"YPFiles";
}

// 返回 appFiles 文件夹的路径
- (NSString *)appFilesPath {
    NSString *name = [self appFiles];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name];
    return path;
}

// 返回 documentsPath
- (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// 返回 libraryPath
- (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

// 返回 cachesPath
- (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

// 返回 applicationPath (app的安装目录)
- (NSString *)applicationPath {
    return [[NSBundle mainBundle] bundlePath];
}

// 返回 tmpPath (临时文件夹路径)
- (NSString *)tmpPath {
    return NSTemporaryDirectory();
}

@end
