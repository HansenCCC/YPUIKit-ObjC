//
//  NSString+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import "NSString+YPExtension.h"

@implementation NSString (YPExtension)

/// 是否是有效手机号
- (BOOL)yp_isValidPhone {
    NSString *mobile = [self copy];
    if (mobile.length != 11){
        return NO;
    }
    // 手机号码 (13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9])
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    // 中国移动：China Mobile (134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188)
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    // 中国联通：China Unicom (130,131,132,145,155,156,170,171,175,176,185,186)
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    // 中国电信：China Telecom (133,149,153,170,173,177,180,181,189)
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES)
        || ([regextestcm evaluateWithObject:mobile] == YES)
        || ([regextestct evaluateWithObject:mobile] == YES)
        || ([regextestcu evaluateWithObject:mobile] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

/// 是否是有效URL
- (BOOL)yp_isValidURL {
    NSString *URLString = [self copy];
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:URLString];
}

/// 拼接字符串
/// @param string 拼接字符
- (NSString *)yp_addString:(NSString *)string {
    return [NSString stringWithFormat:@"%@%@",[self copy],string];
}

/// 通过字符字体获取现在试图的宽度
/// @param font font大小
/// @param maxSize 允许最大尺寸
- (CGSize)yp_sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/// 提取两字符之间的值
/// @param startString 头字符
/// @param endString 尾字符
- (NSArray <NSString *>*)yp_substringWithStart:(NSString *)startString end:(NSString *)endString {
    NSMutableString *copySelf = [self mutableCopy];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSRange startRange = [copySelf rangeOfString:startString];
    NSRange endRange = [copySelf rangeOfString:endString];
    while (startRange.location != NSNotFound&&endRange.location != NSNotFound) {
        //提取两字符之间的值
        NSRange range = NSMakeRange(startRange.location , endRange.location + endRange.length  - startRange.location);
        NSString *result = [copySelf substringWithRange:range];
        [results addObject:result];
        [copySelf deleteCharactersInRange:range];
        startRange = [copySelf rangeOfString:startString];
        endRange = [copySelf rangeOfString:endString];
    };
    return results;
}

/// 返回url
- (NSURL *)yp_toURL {
    return [NSURL URLWithString:[self copy]];
}

/// 国际化
- (NSString *)yp_localizedString {
    NSString *localizedString = NSLocalizedString([self copy], nil);
    return localizedString;
}

/// json字符转字典
- (NSDictionary *)yp_jsonStringToDictionary {
    NSData *data = [[self copy] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return jsonDic;
}

@end

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (YPMD5)

/// 返回小写字母md5
- (NSString *)yp_md5 {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    memset(result, 0, CC_MD5_DIGEST_LENGTH);
    NSData *sdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    CC_MD5([sdata bytes], (CC_LONG)[sdata length], result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
    ];
}

- (NSData *)yp_md5Bytes {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    memset(result, 0, CC_MD5_DIGEST_LENGTH);
    NSData *sdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    CC_MD5([sdata bytes], (CC_LONG)[sdata length], result);
    NSData *data = [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    return data;
}

@end
