//
//  YPFileListViewModel.m
//  YPVideoPlayer
//
//  Created by Hansen on 2025/2/18.
//

#import "YPFileListViewModel.h"
#import "YPFileListModel.h"
#import "YPFileManager.h"

@interface YPFileListViewModel ()

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation YPFileListViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.dataList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startLoadData {
    BOOL hasMore = NO;
    [self.dataList removeAllObjects];
    NSString *filePath = self.filePath;
    YPFileSortOption sortOption = [YPFileManager shareInstance].sortOption;
    BOOL ascending = [YPFileManager shareInstance].ascending;
    NSArray *dataList = [[YPFileManager shareInstance] listFilesInDirectoryAtPath:filePath search:nil sortOption:sortOption ascending:ascending];
    for (YPFileItem *item in dataList) {
        YPFileListModel *m = [[YPFileListModel alloc] init];
        m.fileItem = item;
        [self.dataList addObject:m];
    }
    if ([self.delegate respondsToSelector:@selector(didEndLoadData:)]) {
        [self.delegate didEndLoadData:hasMore];
    }
}

@end
