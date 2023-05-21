//
//  NSDictionary+YPExtension.m
//  YPUIKit-ObjC
//
//  Created by Hansen on 2023/5/21.
//

#import "NSDictionary+YPExtension.h"

@implementation NSDictionary (YPExtension)

- (NSString *)yp_dictionaryToJsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self copy] options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString *)yp_dictionaryToJsonStringNoSpace {
    NSString *jsonString = [self yp_dictionaryToJsonString];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}

@end
