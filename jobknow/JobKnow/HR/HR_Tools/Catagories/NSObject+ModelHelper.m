//
//  NSObject+ModelHelper.m
//  Wawa
//
//  Created by Alik on 14-8-12.
//  Copyright (c) 2014年 Alik. All rights reserved.
//

#import "NSObject+ModelHelper.h"
#import "RegexKitLite.h"
#import <objc/runtime.h>

@implementation NSObject (ModelHelper)

-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [self init];
    if (self) {
        [self reflectDataFromOtherObject:dic];
    }
    return self;
}

- (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    free(properties);
    return keys;
}

-(BOOL)reflectDataFromOtherObject:(NSDictionary *)dic
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSString *propertyName_withi;
        if ([[propertyName substringToIndex:1] isEqualToString:@"I"]) {
           propertyName_withi = [NSString stringWithFormat:@"i%@",[propertyName substringFromIndex:1]];
        }else
        {
            propertyName_withi = propertyName;

        }
        NSString *propertyType = [[NSString alloc] initWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        
        if ([[dic allKeys] containsObject:propertyName_withi]) {
            
            id value = [dic valueForKey:propertyName_withi];
            if (![value isKindOfClass:[NSNull class]] && value != nil) {
                if ([[propertyName_withi substringToIndex:1] isEqualToString:@"i"]) {
                    propertyName_withi = [NSString stringWithFormat:@"I%@",[propertyName substringFromIndex:1]];
                }
                
                if ([value isKindOfClass:[NSDictionary class]]) {
                    id pro = [self createInstanceByClassName:[self getClassName:propertyType]];
                    [pro reflectDataFromOtherObject:value];
                    [self setValue:pro forKey:propertyName_withi];
                }else{
                    [self setValue:value forKey:propertyName_withi];
                }
            }
        }
    }
    
    free(properties);
    return true;
}

//-(NSString *)reflectNSObjectToNSString:(NSObject *)obj
//{
//    NSDictionary *dic = [obj convertModelToDictionary];
//    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:NULL];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return string;
//}

//- (BOOL)reflectDataFromOtherObject:(NSObject*)dataSource
//{
//    BOOL ret = NO;
//    for (NSString *key in [self propertyKeys]) {
//        if ([dataSource isKindOfClass:[NSDictionary class]]) {
//            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
//        }
//        else
//        {
//            ret = [dataSource respondsToSelector:NSSelectorFromString(key)];
//        }
//        if (ret) {
//            id propertyValue = [dataSource valueForKey:key];
//            //该值不为NSNULL，并且也不为nil 并且也不为Dic
//            if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil && ![propertyValue isKindOfClass:[NSDictionary class]]) {
//                [self setValue:propertyValue forKey:key];
//            }
//        }
//    }
//    return ret;
//}

//-(id)

-(NSDictionary *)convertModelToDictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [self propertyKeys]) {
        id propertyValue = [self valueForKey:key];
        //该值不为NSNULL，并且也不为nil
        [dic setObject:propertyValue forKey:key];
    }
    
    return dic;
}

-(NSString *)getClassName:(NSString *)attributes
{
    NSString *type = [attributes substringFromIndex:[attributes rangeOfRegex:@"\""].location + 1];
    type = [type substringToIndex:[type rangeOfRegex:@"\""].location];
    return type;
}

-(id) createInstanceByClassName: (NSString *)className {
    NSBundle *bundle = [NSBundle mainBundle];
    Class aClass = [bundle classNamed:className];
    id anInstance = [[aClass alloc] init];
    return anInstance;
}

@end
