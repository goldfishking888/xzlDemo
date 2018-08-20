//
//  NSObject+JSON.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/29.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "NSObject+JSON.h"

@implementation NSObject (JSON)
-(NSString*)toJSONString
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
@end
