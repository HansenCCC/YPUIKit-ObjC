//
//  YPFileBrowserElementCell.m
//  KKFileBrowser_Example
//
//  Created by Hansen on 2021/8/7.
//  Copyright © 2021 Hansen. All rights reserved.
//

#import "YPFileBrowserElementCell.h"
#import "NSString+YPFileFormat.h"
#import "UIImage+YPResource.h"
#import "UIColor+YPExtension.h"
#import "UIImage+YPExtension.h"

@interface YPFileBrowserElementCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation YPFileBrowserElementCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.rightImageView];
    [self.contentView addSubview:self.rightLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGRect f1 = bounds;
    f1.origin.x = 15.f;
    f1.size = [self.titleLabel sizeThatFits:CGSizeZero];
    f1.size.width = MIN(bounds.size.width - 2 * f1.origin.x - 100.f, f1.size.width);
    f1.origin.y = (bounds.size.height - f1.size.height)/2.0f;
    self.titleLabel.frame = f1;
    //
    CGRect f2 = bounds;
    f2.size.height = 1.f;
    f2.origin.y = bounds.size.height - f2.size.height;
    self.lineView.frame = f2;
    //
    CGRect f3 = bounds;
    f3.size = CGSizeMake(15.f, 15.f);
    f3.origin.y = (bounds.size.height - f3.size.height)/2.0;
    f3.origin.x = bounds.size.width - f3.size.width - 8.f;
    self.rightImageView.frame = f3;
    //
    CGRect f4 = bounds;
    f4.size = [self.rightLabel sizeThatFits:CGSizeZero];
    f4.origin.x = f3.origin.x - f4.size.width;
    f4.origin.y = (bounds.size.height - f4.size.height)/2.f;
    self.rightLabel.frame = f4;
}

- (void)setIsDisplayRightImage:(BOOL)isDisplayRightImage {
    _isDisplayRightImage = isDisplayRightImage;
    self.rightImageView.hidden = !isDisplayRightImage;
}

#pragma mark - setters

- (void)setCellModel:(YPFileInfo *)cellModel {
    _cellModel = cellModel;
    self.isDisplayRightImage = YES;
    self.titleLabel.text = cellModel.fileName?:@"";
    self.rightLabel.text = cellModel.fileSize?:@"";
    UIImage *arrowImage = [UIImage yp_imageWithBase64String:@"iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAAAAXNSR0IArs4c6QAAArZJREFUeF7t3WtOwzAQBGD3ZnAy4GRwM2AlIlVVk9YbbM/MTiXEj6Zku1/Wr7jl0vyAysAFKhoH0wwCdhEYxCBgGQALxxViELAMgIXjCjEIWAbAwnGFGAQsA2DhuEIMspuB96tnvlpr8VPugVAhL621zzuZD5DXaiIIIN8HSS+HshokKiMq5OgRKB9VmjAGkA0rmi/5foUJJGDkUVaDxMjqrbPjlkZZDRIWR536npUsCgJIpkoCKjr667lLZ6FhHo4AEpkxyt/1gQIS4exNEB9dylKVggRilN92GA2kPAoiSGkUVJANJeYoj5ZWbvsY6j4FGWRL9DPrXTIoDCCR7AwK5UoxC0gZFCaQEihsINlZPU3zxQhyBgX+RhcrSBYF/p4KM4gkCjuIHIoCiBSKCsgZFKilFiUQCRQ1EHoURRDq5XtVEFoUZRBKFHUQOpQKIFQ3uiqBZJfvp85TqoHAo1QEgUapCpJBmXKTqzJIZlY/PF/DT/BoY+7C53v3ErtCBmJldtsbZBBIBiNCmdKaTDnJoMRm/mwWY9ontiqBwGNMK8PMpfzPr6HAqAJCg1EBhApDHSSDMWVoe9Qcq3bqlBiqFUKLoQhCjaEGQo+hBCKBoQKSwZh6W7Znkss+ysp8GBQWg71C5DCYQSQxWEFkMRhBpDHYQOQxWEB6NyNso0zo0dTeUBh92FsKA71CymEgg5TEQAUpi4EIUhoDDaQ8BhJIZsU24qcc2qLfU89WxrTdhD3L52ePRZiH+Mv4rxRXg2SqQ7IyNpPVIL3rU9IYCJ16T2cuj8EEUgIDASRiOKqS5Vs7z46ael+/ug/Z4r3Xl8jNMZ7BQQGJWLcv3Y/f/terz+j5mPEZQKqQ8e+W4AwGAUMyiEHAMgAWjivEIGAZAAvHFWIQsAyAheMKMQhYBsDCcYWAgfwAEO6YZei31R4AAAAASUVORK5CYII="];
    self.rightImageView.image = [arrowImage yp_imageWithTintColor:[UIColor yp_grayColor]];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDir;
    [manager fileExistsAtPath:cellModel.filePath isDirectory:&isDir];
    if (isDir) {
        self.rightImageView.hidden = NO;
    } else {
        /// 判断文件是否是数据库
        NSArray *dbSuffix = [NSString fileDatabase];
        NSString *pathExtension = cellModel.filePath.pathExtension;
        if ([dbSuffix containsObject:pathExtension]) {
            self.rightImageView.hidden = NO;
        } else {
            self.rightImageView.hidden = YES;
        }
    }
    [self layoutSubviews];
}

#pragma mark - getters

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _lineView;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:14.f];
        _rightLabel.textColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _rightLabel;
}

@end

@interface YPFileBrowserElementThumbnailCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation YPFileBrowserElementThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupSubviews];
    return self;
}

- (void)setupSubviews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.detailLabel];
    self.backgroundColor = [UIColor yp_gray6Color];
    self.layer.cornerRadius = 4.f;
    self.imageView.backgroundColor = [UIColor yp_randomColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    //
    CGRect f1 = bounds;
    f1.size.height = f1.size.width;
    self.imageView.frame = f1;
    //
    CGRect f2 = bounds;
    f2.size = CGSizeMake(bounds.size.width, 40.f);
    f2.origin.y = CGRectGetMaxX(f1);
    self.titleLabel.frame = f2;
    //
    CGRect f3 = bounds;
    f3.origin.y = CGRectGetMaxY(f2);
    f3.size.height = bounds.size.height - f3.origin.y;
    self.detailLabel.frame = f3;
}

#pragma mark - setters | getters

- (void)setCellModel:(YPFileInfo *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.fileName;
    self.detailLabel.text = cellModel.fileSize?:@"";
    UIImage *defaultImage = [UIImage yp_imageWithBundleImageNamed:@"yp_icon_fileDic.png"];
    if (cellModel.fileImageName.length > 0) {
        [self.imageView setImage:[UIImage yp_imageWithBundleImageNamed:cellModel.fileImageName]];
    }else{
        [self.imageView setImage:defaultImage];
    }
    [self layoutSubviews];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:12.f];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.textColor = [UIColor blueColor];
    }
    return _detailLabel;
}

@end
