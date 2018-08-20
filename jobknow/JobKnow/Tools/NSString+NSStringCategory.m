//
//  NSString+NSStringCategory.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/25.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "NSString+NSStringCategory.h"

@implementation NSString (NSStringCategory)
-(NSString *)stringWithoutShi{
    return [self stringByReplacingOccurrencesOfString:@"市" withString:@""];
}

//2017-08这种格式
-(NSString *)stringWithoutRi{
    if (self.length>7) {
        return [self substringToIndex:7];
    }
    return self;
}
//2017-08-02这种格式
-(NSString *)stringWithRi{
    if (self.length>10) {
        return [self substringToIndex:10];
    }
    return self;
}
@end
