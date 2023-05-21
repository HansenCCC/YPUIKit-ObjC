//
//  NSString+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (YPExtension)

/// 是否是有效手机号
- (BOOL)yp_isValidPhone;

/// 是否是有效URL
- (BOOL)yp_isValidURL;

/// 拼接字符串
/// @param string 拼接字符
- (NSString *)yp_addString:(NSString *)string;

/// 通过字符字体获取现在试图的宽度
/// @param font font大小
/// @param maxSize 允许最大尺寸
- (CGSize)yp_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/// 提取两字符之间的值
/// @param startString 头字符
/// @param endString 尾字符
- (NSArray <NSString *>*)yp_substringWithStart:(NSString *)startString end:(NSString *)endString;

/// 返回url
- (NSURL *)yp_toURL;

/// 国际化
- (NSString *)yp_localizedString;

/// json字符转字典
- (NSDictionary *)yp_jsonStringToDictionary;

@end


@interface NSString (YPMD5)

/// 返回string类型md5
- (NSString *)yp_md5;

// 返回data类型md5
- (NSData *)yp_md5Bytes;

@end

NS_ASSUME_NONNULL_END
