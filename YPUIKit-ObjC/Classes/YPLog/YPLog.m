//
//  YPLog.m
//  WTPlatformSDK
//
//  Created by Hansen on 2023/3/17.
//

#import "YPLog.h"
#import "NSTimer+YPExtension.h"
#import "NSDate+YPExtension.h"

@interface YPLog ()

@property (nonatomic, strong) NSTimer *logTimer;
@property (nonatomic, strong) NSMutableArray *logDataList;

@end

@implementation YPLog

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YPLog *sdk = nil;
    dispatch_once(&onceToken, ^{
        sdk = [[YPLog alloc] init];
        [sdk setupLogTimer];
        [sdk addObserverNotification];
    });
    return sdk;
}

- (void)setupLogTimer {
    self.logDataList = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    NSTimeInterval timeInterval = 5.f;
#ifdef DEBUG
    // 测试环境下，2s 缓存一下日志
    timeInterval = 2.f;
#endif
    // 每过 5s 写入日志进去
    self.logTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf writeAllLogs];
    }];
    [self.logTimer setFireDate:[NSDate date]];
}

- (void)addObserverNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)appWillTerminate {
    yplog_msg(@"---------------------end-------------------------");
    [self writeAllLogs];
}

+ (NSString *)logPath {
    NSString *logsDirectory = [NSString stringWithFormat:@"%@/logs/",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
    return logsDirectory;
}

+ (NSString *)todayLogPath {
    NSDate *newDate = [NSDate date];
    NSString *dateString = [newDate yp_StringWithDateFormat:@"yyyy-MM-dd"];
    NSString *logsDirectory = [self logPath];
    NSString *logsFilePath = [logsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.log", dateString]];
    return logsFilePath;
}

- (void)writeAllLogs {
    if (!self.logDataList.count) {
        return;
    }
    NSArray *msgs = [self.logDataList copy];
    [self.logDataList removeAllObjects];
    
    NSString *logsDirectory = [YPLog logPath];
    NSString *logsFilePath = [YPLog todayLogPath];
    // 创建logs目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:logsDirectory]) {
        [fileManager createDirectoryAtPath:logsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 创建日志文件
    if (![fileManager fileExistsAtPath:logsFilePath]) {
        [fileManager createFileAtPath:logsFilePath contents:nil attributes:nil];
    }
    // 打开文件并写入日志信息
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:logsFilePath];
    [fileHandle seekToEndOfFile];
    for (NSString *log in msgs) {
        [fileHandle writeData:[[log stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [fileHandle closeFile];
}

/// logType: 日志类型  “message、waring、error、success” 四种类型
+ (void)logWithLogType:(NSString *)logType
              fileName:(const char *)fileName
            methodName:(const char *)methodName
            lineNumber:(int)lineNumber
                format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    NSString *fileNameString = [[NSString stringWithUTF8String:fileName] lastPathComponent];
    NSString *methodNameString = [NSString stringWithUTF8String:methodName];
    NSDate *newDate = [NSDate date];
    NSString *dateString = [newDate yp_StringWithDateFormat:@"HH:mm:ss.SSS"];
    NSString *msg = [NSString stringWithFormat:@"[%@-%@] - [%@:%d] %@ - %@", dateString, logType, fileNameString, lineNumber, methodNameString, message];
    [[YPLog sharedInstance].logDataList addObject:msg];
}

+ (void)load {
    yplog_msg(@"---------------------begin-------------------------");
}

@end
