#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

//! Project version number for MacOSYPReachability.
FOUNDATION_EXPORT double YPReachabilityVersionNumber;

//! Project version string for MacOSYPReachability.
FOUNDATION_EXPORT const unsigned char YPReachabilityVersionString[];

/** 
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kYPReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, YPNetworkStatus) {
    // Apple YPNetworkStatus Compatible Names.
    YPNotReachable = 0,
    YPReachableViaWiFi = 2,
    YPReachableViaWWAN = 1
};

@class YPReachability;

typedef void (^YPNetworkReachable)(YPReachability * reachability);
typedef void (^YPNetworkUnreachable)(YPReachability * reachability);
typedef void (^YPNetworkYPReachability)(YPReachability * reachability, SCNetworkConnectionFlags flags);


@interface YPReachability : NSObject

@property (nonatomic, copy) YPNetworkReachable    reachableBlock;
@property (nonatomic, copy) YPNetworkUnreachable  unreachableBlock;
@property (nonatomic, copy) YPNetworkYPReachability reachabilityBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(instancetype)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(instancetype)reachabilityWithHostName:(NSString*)hostname;
+(instancetype)reachabilityForInternetConnection;
+(instancetype)reachabilityWithAddress:(void *)hostAddress;
+(instancetype)reachabilityForLocalWiFi;
+(instancetype)reachabilityWithURL:(NSURL*)url;

-(instancetype)initWithYPReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isYPReachableViaWWAN;
-(BOOL)isYPReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(YPNetworkStatus)currentYPReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentYPReachabilityString;
-(NSString*)currentYPReachabilityFlags;

@end
