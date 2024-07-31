//
//  NSDate+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 8/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YPExtension)

/// 当前时间NSDateComponents （year、month、day...）
- (NSDateComponents *)yp_DateComponents;

/// 当前日前往前一天的时间
- (NSDate *)yp_Yesterday;

/// 当前日前往后一天的时间
- (NSDate *)yp_Tomorrow;

/// 当前时刻与指定的时刻是否在同一天
/// @param date 指定的时刻
- (BOOL)yp_IsSameDayWithDate:(NSDate *)date;

/// 返回(dateFormat)日期字符串
/// @param dateFormat 日期的显示格式，如YYYY-MM-dd HH:mm:ss
- (NSString *)yp_StringWithDateFormat:(NSString *)dateFormat;

/// 根据字符串中实例出日期
/// @param dateString 字符串，如1999-9-10
/// @param dateFormat 日期字符串的格式
+ (NSDate *)yp_DateWithString:(NSString *)dateString dateFormat:(NSString *)dateFormat;

@end

NS_ASSUME_NONNULL_END
