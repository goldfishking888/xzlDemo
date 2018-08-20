//
//  JobInfo.m
//  JobKnow
//
//  Created by faxin sun on 13-3-6.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "JobInfo.h"

@implementation JobInfo

+ (NSArray *)jobInfoPutToArray:(NSArray *)array
{
    NSMutableArray *infoArray = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in array) {
        JobInfo *info = [[JobInfo alloc]init];
        info.job_id = [dic valueForKey:@"jobid"];
        info.cid = [dic valueForKey:@"cid"];
        info.area = [dic valueForKey:@"workarea"];
        info.jobName = [dic valueForKey:@"jobname"];
        info.companyName = [dic valueForKey:@"cname"];
        info.publishDate =[JobInfo stringBecomeTime:[dic valueForKey:@"pubdate"]];
        info.cityName = [dic valueForKey:@"detailworkarea"];
        info.require =[JobInfo filterHtmlTag:[dic valueForKey:@"required"]];
        info.pid = [dic valueForKey:@"pid"];
        info.education = [dic valueForKey:@"degree"];
        info.salary = [dic valueForKey:@"salary"];
        info.companyType = [dic valueForKey:@"corpprop"];
        info.isfav = [dic valueForKey:@"isfav"];
        info.read = [dic valueForKey:@"isread"];
        info.isJianzhi=[[dic valueForKey:@"ispart"] integerValue];
        
        [infoArray addObject:info];
    }
    return infoArray;
}

//过滤html标签语言
+ (NSString *)filterHtmlTag:(NSString *)originHtmlStr{
    NSString *result = nil;
    NSRange arrowTagStartRange = [originHtmlStr rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound)
    {
        //如果找到
        NSRange arrowTagEndRange = [originHtmlStr rangeOfString:@">"];
        if (arrowTagEndRange.location == NSNotFound) {
            return originHtmlStr;
        }
        
        if (arrowTagEndRange.location < arrowTagStartRange.location) {
            return originHtmlStr;
        }
        result = [originHtmlStr stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];

        return [self filterHtmlTag:result];
        //递归，过滤下一个标签
    }else
    {
        result = [originHtmlStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        // 过滤&nbsp等标签
    }
    return result;
}


+ (NSString *)stringBecomeTime:(NSString *)time
{
    NSString *timeStr = nil;
    if (time.length >= 13) {
         timeStr = [time substringWithRange:NSMakeRange(0, time.length - 3)];
    }
   
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeStr doubleValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:confromTimesp];
    return str;
}

@end
