//
//  NSDictionary+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (YPExtension)

/// 字典转Json字符串
- (NSString *)yp_dictionaryToJsonString;

/// 字典转Json字符串（无空格和回车）
- (NSString *)yp_dictionaryToJsonStringNoSpace;

@end

NS_ASSUME_NONNULL_END
