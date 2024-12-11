//
//  YPLog.h
//  WTPlatformSDK
//  轻量级 log 本地化日志项目
//  Created by Hansen on 2023/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define yplog_msg(fmt, ...) \
    [YPLog logWithLogType:@"📝📝📝" fileName:__FILE__ methodName:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yplog_suc(fmt, ...) \
    [YPLog logWithLogType:@"✅✅✅" fileName:__FILE__ methodName:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yplog_err(fmt, ...) \
    [YPLog logWithLogType:@"❌❌❌" fileName:__FILE__ methodName:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(fmt), ##__VA_ARGS__]

#define yplog_warn(fmt, ...) \
    [YPLog logWithLogType:@"⚠️⚠️⚠️" fileName:__FILE__ methodName:__PRETTY_FUNCTION__ lineNumber:__LINE__ format:(fmt), ##__VA_ARGS__]

@interface YPLog : NSObject

/// 增加Log日志
/// - Parameters:
///   - logType: 日志类型  “message、waring、error、success” 四种类型
///   - fileName: 文件名字
///   - methodName: 调用的方法
///   - lineNumber: 代码行数
///   - format: 字符串
+ (void)logWithLogType:(NSString *)logType
              fileName:(const char *)fileName
            methodName:(const char *)methodName
            lineNumber:(int)lineNumber
                format:(NSString *)format, ...;


/// 获取日志的文件夹路径
+ (NSString *)logPath;

/// 今天的日志文件路径
+ (NSString *)todayLogPath;

@end

NS_ASSUME_NONNULL_END
