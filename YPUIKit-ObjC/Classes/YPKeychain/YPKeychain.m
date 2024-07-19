//
//  YPKeychain.m
//  Pods
//  作者：Hansen iOS Developer
//  Created by Hansen on 2023/4/24.
//

#import "YPKeychain.h"

@implementation YPKeychain

+ (NSDictionary *)keychainQueryInfoForKey:(NSString *)key user:(NSString *)userId {
    return @{(id) kSecClass : (id) kSecClassGenericPassword,
            (id) kSecAttrService : key,
            (id) kSecAttrAccount : userId,
            (id) kSecAttrAccessible : (id) kSecAttrAccessibleAfterFirstUnlock};
}

+ (BOOL)saveObject:(id)obj forKey:(NSString *)key {
    return [self saveObject:obj forKey:key user:key];
}

+ (BOOL)saveObject:(id)obj forKey:(NSString *)key user:(NSString *)userId {
    //Get search dictionary
    NSMutableDictionary *keychainQueryInfo = [[self keychainQueryInfoForKey:key user:userId] mutableCopy];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQueryInfo);
    //Add new object to search dictionary(Attention:the data format)
    keychainQueryInfo[(id) kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:obj];
    //Add item to keychain with the search dictionary
    OSStatus ret = SecItemAdd((__bridge CFDictionaryRef)keychainQueryInfo, NULL);
    return ret == noErr;
}

+ (id)loadObjectForKey:(NSString *)key {
    return [self loadObjectForKey:key user:key];
}

+ (id)loadObjectForKey:(NSString *)key user:(NSString *)userId {
    id result = nil;
    NSMutableDictionary *keychainQueryInfo = [[self keychainQueryInfoForKey:key user:userId] mutableCopy];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password, the form of a CFDataRef)
    // we can set the attribute kSecReturnData to kCFBooleanTrue
    keychainQueryInfo[(id) kSecReturnData] = (id) kCFBooleanTrue;
    keychainQueryInfo[(id) kSecMatchLimit] = (id) kSecMatchLimitOne;
    CFDataRef savedData = NULL;
    OSStatus keychainOperationResult = SecItemCopyMatching((__bridge CFDictionaryRef) keychainQueryInfo, (CFTypeRef *) &savedData);
    if (keychainOperationResult == noErr) {
        @try {
            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *) savedData];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    if (savedData) {
        CFRelease(savedData);
    }

    return result;
}

+ (BOOL)deleteObjectForKey:(NSString *)key {
    return [self deleteObjectForKey:key user:key];
}

+ (BOOL)deleteObjectForKey:(NSString *)key user:(NSString *)userId {
    if (userId.length == 0 || key.length == 0) return NO;
    NSDictionary *keychainQueryInfo = [self keychainQueryInfoForKey:key user:userId];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) keychainQueryInfo);
    return result == noErr;
}

#pragma mark - device only

+ (NSDictionary *)deviceOnlyKeychainQueryInfoForKey:(NSString *)key user:(NSString *)userId {
    return @{(id) kSecClass : (id) kSecClassGenericPassword,
             (id) kSecAttrService : key,
             (id) kSecAttrAccount : userId,
             (id) kSecAttrAccessible : (id) kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly};
}

+ (BOOL)saveDeviceOnlyObject:(id)obj forKey:(NSString *)key {
    return [self saveDeviceOnlyObject:obj forKey:key user:key];
}

+ (BOOL)saveDeviceOnlyObject:(id)obj forKey:(NSString *)key user:(NSString *)userId {
    //Get search dictionary
    NSMutableDictionary *keychainQueryInfo = [[self deviceOnlyKeychainQueryInfoForKey:key user:userId] mutableCopy];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQueryInfo);
    //Add new object to search dictionary(Attention:the data format)
    keychainQueryInfo[(id) kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:obj];
    //Add item to keychain with the search dictionary
    OSStatus ret = SecItemAdd((__bridge CFDictionaryRef)keychainQueryInfo, NULL);
    return ret == noErr;
}

+ (id)loadDeviceOnlyObjectForKey:(NSString *)key {
    return [self loadDeviceOnlyObjectForKey:key user:key];
}

+ (id)loadDeviceOnlyObjectForKey:(NSString *)key user:(NSString *)userId {
    id result = nil;
    NSMutableDictionary *keychainQueryInfo = [[self deviceOnlyKeychainQueryInfoForKey:key user:userId] mutableCopy];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password, the form of a CFDataRef)
    // we can set the attribute kSecReturnData to kCFBooleanTrue
    keychainQueryInfo[(id) kSecReturnData] = (id) kCFBooleanTrue;
    keychainQueryInfo[(id) kSecMatchLimit] = (id) kSecMatchLimitOne;
    CFDataRef savedData = NULL;
    OSStatus keychainOperationResult = SecItemCopyMatching((__bridge CFDictionaryRef) keychainQueryInfo, (CFTypeRef *) &savedData);
    if (keychainOperationResult == noErr) {
        @try {
            result = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *) savedData];
        } @catch (NSException *exception) {
        } @finally {
        }
    }
    if (savedData) {
        CFRelease(savedData);
    }
    
    return result;
}

+ (BOOL)deleteDeviceOnlyObjectForKey:(NSString *)key {
    return [self deleteDeviceOnlyObjectForKey:key user:key];
}

+ (BOOL)deleteDeviceOnlyObjectForKey:(NSString *)key user:(NSString *)userId {
    if (userId.length == 0 || key.length == 0) return NO;
    NSDictionary *keychainQueryInfo = [self deviceOnlyKeychainQueryInfoForKey:key user:userId];
    OSStatus result = SecItemDelete((__bridge CFDictionaryRef) keychainQueryInfo);
    return result == noErr;
}


@end
