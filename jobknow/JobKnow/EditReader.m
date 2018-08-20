//
//  EditReader.m
//  JobsGather
//
//  Created by faxin sun on 13-2-25.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "EditReader.h"
#import "jobRead.h"
@implementation EditReader
+ (EditReader *)standerDefault
{
    static EditReader *edit = nil;
    if (edit == nil) {
        edit = [[EditReader alloc]init];
        edit.industry = [[NSMutableArray alloc]init];
        edit.jobArray = [[NSMutableArray alloc]init];
        edit.imageArray = [[NSMutableArray alloc] init];
        edit.jobOtherArray = [[NSMutableArray alloc] init];
        edit.areaArray = [NSMutableArray array];
    }
    return edit;
}

//行业字符串
+ (NSString *)tradeStr
{
    EditReader *edit = [EditReader standerDefault];
    //判断行业数组是否为空
    if (edit.industry.count > 0) {
        NSMutableString *jobStr = [[NSMutableString alloc]init];
        //遍历行业数组，将数组中的
        for (int i = 0;i < edit.industry.count; i++)
        {
            jobRead *job = [edit.industry objectAtIndex:i];
             //NSLog(@"-----------==-------%@",job.name);
            if (i == (edit.industry.count-1))
            {
                [jobStr appendString:job.name];
            }else
            {
                [jobStr appendFormat:@"%@,",job.name];
            }
        }
        return jobStr;
    }
    return @"选择行业";
}

+ (NSString *)jobStr
{
    EditReader *edit = [EditReader standerDefault];
    if (edit.jobArray.count > 0)
    {
        NSMutableString *jobStr = [[NSMutableString alloc]init];
        for (int i = 0; i < edit.jobArray.count; i++)
        {
            jobRead *job = [edit.jobArray objectAtIndex:i];
            if (i == (edit.jobArray.count-1))
            {
                [jobStr appendString:job.name];
            }else
            {
                [jobStr appendFormat:@"%@,",job.name];
            }
            //NSLog(@"jobstr........%@",job.name);
        }
        
        return jobStr;
    }
    return @"选择职业";
}


//期望地点字符串
+ (NSString *)areaStr
{
    EditReader *edit = [EditReader standerDefault];
    //判断行业数组是否为空
    if (edit.areaArray.count > 0) {
        NSMutableString *jobStr = [[NSMutableString alloc]init];
        //遍历行业数组，将数组中的
        for (int i = 0;i < edit.areaArray.count; i++)
        {
            jobRead *job = [edit.areaArray objectAtIndex:i];
            if (i == (edit.areaArray.count-1))
            {
                [jobStr appendString:job.name];
            }else
            {
                [jobStr appendFormat:@"%@,",job.name];
            }
        }
        return jobStr;
    }
    return @"";
}


+ (NSString *)areaCode
{
    EditReader *edit = [EditReader standerDefault];
    if (edit.areaArray.count > 0)
    {
        NSMutableString *arr = [[NSMutableString alloc]init];
        for (int i = 0;i <edit.areaArray.count ; i++)
        {
            jobRead *job = [edit.areaArray objectAtIndex:i];
            if (i == (edit.areaArray.count -1)) {
                [arr appendString:job.code];
            }else
            {
                [arr appendFormat:@"%@,",job.code];
            }
        }
        return arr;
    }
    return @"";
}

+ (NSString *)industryCode
{
    EditReader *edit = [EditReader standerDefault];
    if (edit.industry.count > 0)
    {
        NSMutableString *arr = [[NSMutableString alloc]init];
        for (int i = 0;i <edit.industry.count ; i++)
        {
            jobRead *job = [edit.industry objectAtIndex:i];
            if (i == (edit.industry.count -1)) {
                [arr appendString:job.code];
            }else
            {
                [arr appendFormat:@"%@,",job.code];
            }
        }
        return arr;
    }
    return @"0000";
}

+ (NSString *)jobCode
{
    EditReader *edit = [EditReader standerDefault];
    if (edit.jobArray.count > 0) {
        NSMutableString *arr = [[NSMutableString alloc]init];
        for (int i = 0;i <edit.jobArray.count ; i++) {
            jobRead *job = [edit.jobArray objectAtIndex:i];
            if (i == (edit.jobArray.count -1)) {
                [arr appendString:job.code];
            }else
            {
                [arr appendFormat:@"%@,",job.code];
                
            }
        }
        return arr;
    }
    return @"0000";
}

+ (BOOL)containTheCode:(NSString *)code
{
    EditReader *edit = [EditReader standerDefault];
    if (edit.jobArray > 0)
    {
        for (jobRead *job in edit.jobArray) {
            if ([job.code integerValue]==[code integerValue]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (BOOL)containTheTradeCode:(NSString *)code
{
    EditReader *edit = [EditReader standerDefault];
    if (edit.industry > 0)
    {
        for (jobRead *job in edit.industry) {
            if ([job.code integerValue]==[code integerValue]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (void)deleteJobWithCode:(NSString *)code
{
    EditReader *edit = [EditReader standerDefault];
    for (jobRead *job in edit.jobArray) {
        if ([job.code integerValue]==[code integerValue]) {
            [edit.jobArray removeObject:job];
            break;
        }
    }
}


+ (void)deleteTradeWithCode:(NSString *)code
{
    EditReader *edit = [EditReader standerDefault];
    for (jobRead *job in edit.industry) {
        if ([job.code integerValue]==[code integerValue]) {
            [edit.industry removeObject:job];
            break;
        }
    }
}

+ (void)removeAllData
{
    EditReader *edit = [EditReader standerDefault];
    [edit.industry removeAllObjects];
    //edit.industry = nil;
    [edit.imageArray removeAllObjects];
    //edit.imageArray = nil;
    [edit.jobArray removeAllObjects];
    //edit.jobArray = nil;
    [edit.jobOtherArray removeAllObjects];
    //edit.jobOtherArray = nil;
}
@end
