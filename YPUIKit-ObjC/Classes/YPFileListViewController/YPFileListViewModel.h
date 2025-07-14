//
//  YPFileListViewModel.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YPFileListTypeDefault,
    YPFileListTypeSelect,
} YPFileListType;

@protocol YPFileListViewModelDelegate <NSObject>

- (void)didEndLoadData:(BOOL)hasMore;

@end

@interface YPFileListViewModel : NSObject

@property (nonatomic, weak) id <YPFileListViewModelDelegate> delegate;
@property (nonatomic, readonly) NSMutableArray *dataList;

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, assign) YPFileListType type;

- (void)startLoadData;

@end

NS_ASSUME_NONNULL_END
