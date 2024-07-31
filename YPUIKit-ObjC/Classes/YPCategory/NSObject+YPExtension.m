//
//  NSObject+YPExtension.m
//  WTPlatformSDK
//
//  Created by Hansen on 2023/1/3.
//

#import "NSObject+YPExtension.h"
#import <objc/runtime.h>
#import "NSDictionary+YPExtension.h"

@implementation NSObject (YPExtension)

+ (NSArray *)yp_allClassProperties {
    Class class;
    NSArray *names = [self yp_fetchClassProperties:class];
    return names;
}

+ (NSArray *)yp_currentClassProperties {
    NSArray *names = [self yp_fetchClassProperties:self];
    return names;
}

+ (NSArray *)yp_fetchClassProperties:(Class)root {
    Class cls = [self class];
    unsigned int count;
    if (root) {
        root = class_getSuperclass(root);
    }
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    while (cls != root) {
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        for (int i = 0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            if (![propertyNames containsObject:propertyName]) {
                [propertyNames addObject:propertyName];
            }
        }
        if (properties){
            free(properties);
        }
        cls = class_getSuperclass(cls);
    }
    return propertyNames;
}

- (NSDictionary *)yp_allClassPropertiesAndValues {
    Class class;
    NSDictionary *para = [self yp_fetchClassPropertiesAndValues:class];
    return para;
}


- (NSDictionary *)yp_currentClassPropertiesAndValues {
    NSDictionary *para = [self yp_fetchClassPropertiesAndValues:self.class];
    return para;
}

- (NSDictionary *)yp_fetchClassPropertiesAndValues:(Class)root {
    NSArray *propertyNames = [self.class yp_fetchClassProperties:root];
    NSMutableDictionary *para = [[NSMutableDictionary alloc] initWithCapacity:propertyNames.count];
    for (NSString *propertyName in propertyNames) {
        id object = [self valueForKey:propertyName];
        if (object) {
            [para setObject:object forKey:propertyName];
        }
    }
    return para;
}

- (NSString *)yp_objectToJsonString {
    NSDictionary *dic = [self yp_currentClassPropertiesAndValues];
    return dic.yp_dictionaryToJsonString;
}

- (NSString *)yp_objectToJsonStringNoSpace {
    NSDictionary *dic = [self yp_currentClassPropertiesAndValues];
    return dic.yp_dictionaryToJsonStringNoSpace;
}

- (NSDictionary *)yp_objectToDictionary {
    NSDictionary *dic = [self yp_currentClassPropertiesAndValues];
    return dic;
}

@end


@implementation NSObject (YPHook)

+ (void)yp_exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)yp_exchangeClassMethod1:(SEL)method1 method2:(SEL)method2 {
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end
