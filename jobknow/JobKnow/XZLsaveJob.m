//
//  XZLsaveJob.m
//  XzlEE
//
//  Created by ralbatr on 14-9-22.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import "XZLsaveJob.h"

@implementation XZLsaveJob

//单例
+ (id)standardDefault
{
    static XZLsaveJob *save = nil;
    
    if (save == nil) {
        
        //初始化要使用的数组
        save = [[XZLsaveJob alloc]init];
        save.saveArr = [[NSMutableArray alloc]init];
        save.jobDic = [[NSMutableDictionary alloc]init];

        
    }
    
    return save;
}

//返回已选择职业数组
- (NSMutableArray *)dicKeyName:(NSString *)jobItem jobKeyName:(NSString *)jobName
{
    NSMutableArray*mutableArray = [[self.jobDic valueForKey:jobItem]valueForKey:jobName];
    
    return mutableArray ;
}


//返回所有已选择职业的个数
- (NSInteger)allNumber
{
    NSInteger number = 0;
    NSArray *keyname = [self.jobDic allKeys];
    for (int i = 0; i < self.jobDic.count; i++) {
        NSArray *arr = [[self.jobDic valueForKey:[keyname objectAtIndex:i]] valueForKey:@"jobName"];
        number = number + arr.count;
    }
    return number;
}





@end
