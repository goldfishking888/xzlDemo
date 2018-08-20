//
//  NSString+SPB.h
//  M_Music
//
//  Created by bianchx on 14-7-9.
//  Copyright (c) 2014年 青岛拓宇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SPB)

+(BOOL)isNullOrEmpty:(NSString *)str;

-(BOOL)isNullOrEmpty;

+(NSString *)urlEncoded:(NSString *)str;

-(NSString *)urlEncoded;

+(int)lenghtBySPBCount:(NSString *)str;

-(int)lenghtBySPBCount;

+(NSString *)stringWithjoin:(NSString *)ctor strings:(NSArray *)strings;

@end
