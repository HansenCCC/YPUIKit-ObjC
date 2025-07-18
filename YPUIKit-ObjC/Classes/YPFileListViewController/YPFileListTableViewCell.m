//
//  YPFileListTableViewCell.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2025/2/19.
//

#import "YPFileListTableViewCell.h"
#import "YPFileListModel.h"
#import "YPFileManager.h"
#import "YPAlertView.h"
#import "UIColor+YPExtension.h"
#import "NSString+YPExtension.h"
#import "NSDate+YPExtension.h"
#import "UITextField+YPExtension.h"

@interface YPFileListTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *thumbnailImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation YPFileListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.thumbnailImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.textField];
}

- (void)setCellModel:(YPFileListModel *)cellModel {
    _cellModel = cellModel;
    self.textField.text = cellModel.fileItem.name?:@"";
    self.textField.placeholder = cellModel.fileItem.name?:@"";
    self.titleLabel.text = cellModel.fileItem.name?:@"";
    self.thumbnailImageView.image = cellModel.fileItem.thumbnail;
    if (!self.cellModel.fileItem.isLoadThumbnail) {
        __weak typeof(self) weakSelf = self;
        [self.cellModel.fileItem loadThumbnailWithCompletion:^(UIImage * _Nonnull thumbnail) {
            weakSelf.cellModel = weakSelf.cellModel;
        }];
    }
    NSString *dateString = [cellModel.fileItem.creationDate yp_StringWithDateFormat:@"yyyy/MM/dd"];
    NSString *sizeString = cellModel.fileItem.stringForFileSize;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ - %@", dateString, sizeString];
    
    self.titleLabel.hidden = self.cellModel.isEditing;
    self.detailLabel.hidden = self.cellModel.isEditing;
    self.textField.hidden = !self.cellModel.isEditing;
    
    if (self.cellModel.isEditing) {
        // 如果是编辑状态，主动弹出编辑框
        NSString *fileName = self.textField.text;
        NSRange dotRange = [fileName rangeOfString:@"."];
        if (dotRange.location != NSNotFound) {
            [self.textField yp_setSelectedRange:NSMakeRange(dotRange.location, 0)];
        } else {
            [self.textField yp_setSelectedRange:NSMakeRange(fileName.length, 0)];
        }
        [self.textField becomeFirstResponder];
    }
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.contentView.bounds;
    CGRect f1 = bounds;
    f1.origin.x = 15.f;
    f1.origin.y = 10.f;
    f1.size.width = bounds.size.height - f1.origin.y * 2;
    f1.size.height = f1.size.width;
    self.thumbnailImageView.frame = f1;
    
    CGRect f2 = bounds;
    f2.origin.x = CGRectGetMaxX(f1) + 10.f;
    f2.origin.y = 15.f;
    f2.size = [self.titleLabel sizeThatFits:CGSizeZero];
    CGFloat maxWith = bounds.size.width - f2.origin.x - 15.f;
    if (f2.size.width >= maxWith) {
        f2.size.width = maxWith;
    }
    self.titleLabel.frame = f2;
    
    CGRect f3 = bounds;
    f3.origin.x = f2.origin.x;
    f3.origin.y = CGRectGetMaxY(f2) + 5.f;
    f3.size = [self.detailLabel sizeThatFits:CGSizeZero];
    self.detailLabel.frame = f3;
    
    CGRect f4 = bounds;
    f4.origin.x = f2.origin.x;
    f4.size.height = 0.333f;
    f4.size.width = bounds.size.width - f4.origin.x - 15.f;
    f4.origin.y = bounds.size.height - f4.size.height;
    self.lineView.frame = f4;
    
    CGRect f5 = bounds;
    f5.origin.x = f2.origin.x;
    f5.size.height = bounds.size.height;
    f5.origin.y = 0;
    f5.size.width = bounds.size.width - f5.origin.x - 15.f;
    self.textField.frame = f5;
}

#pragma mark - getters | setters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.f];
        _titleLabel.textColor = [UIColor yp_blackColor];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:12.f];
        _detailLabel.textColor = [UIColor yp_grayColor];
    }
    return _detailLabel;
}

- (UIImageView *)thumbnailImageView {
    if (!_thumbnailImageView) {
        _thumbnailImageView = [[UIImageView alloc] init];
        _thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _thumbnailImageView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor yp_colorWithHexString:@"#3c3c4349"];
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.font = [UIFont systemFontOfSize:16.f];
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.enablesReturnKeyAutomatically = YES;
    }
    return _textField;
}

#pragma mrak - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // 文件名不能为空
    NSString *fileName = textField.text;
    if (fileName.length == 0) {
        return NO;
    }
    // 判断是否存在同名文件
    YPFileItem *fileItem = self.cellModel.fileItem;
    NSString *parentPath = [fileItem.path stringByDeletingLastPathComponent];
    NSString *newFilePath = [parentPath stringByAppendingPathComponent:fileName];
    // 尚未修改名字
    if ([newFilePath isEqualToString:fileItem.path]) {
        [textField resignFirstResponder];
        return YES;
    }
    // 当前目录已经存在
    if ([[YPFileManager shareInstance] existsAtPath:newFilePath]) {
        [YPAlertView alertText:[NSString stringWithFormat:@"'%@' 名称已被占用。".yp_localizedString, fileName]];
        return NO;
    }
    [textField resignFirstResponder];
    self.cellModel.isEditing = NO;
    // 开始修改文件名字
    NSString *oldPath = fileItem.path;
    NSString *newPath = newFilePath;
    BOOL success = [[YPFileManager shareInstance] renameItemAtPath:oldPath toPath:newPath];
    if (!success) {
        [YPAlertView alertText:@"重命名文件失败".yp_localizedString];
        return YES;
    }
    self.cellModel.fileItem.name = textField.text;
    self.cellModel = self.cellModel;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFileManagerDidUpdate object:nil];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.cellModel.isEditing = NO;
    self.titleLabel.hidden = self.cellModel.isEditing;
    self.detailLabel.hidden = self.cellModel.isEditing;
    self.textField.hidden = !self.cellModel.isEditing;
}

@end
