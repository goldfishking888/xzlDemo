//
//  SaveJob.m
//  JobsGather
//
//  Created by faxin sun on 13-1-26.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "jobRead.h"
#import "SaveJob.h"
#import "CityInfo.h"
#import "GRReadModel.h"

@implementation SaveJob

//单例
+ (id)standardDefault
{
    static SaveJob *save = nil;
    
    if (save == nil) {
        
        //初始化要使用的数组
        save = [[SaveJob alloc]init];
        save.saveArr = [[NSMutableArray alloc]init];
        save.saveArrSalary = [[NSMutableArray alloc]init];
        save.saveArrEduQualification = [[NSMutableArray alloc]init];
        save.positionArr = [[NSMutableArray alloc]init];
        save.choiceArr=[[NSMutableArray alloc]init];
        save.seniorChoiceArr=[[NSMutableArray alloc]init];
        //jobDic在WorkDetailVC中用到
        save.jobDic = [[NSMutableDictionary alloc]init];

        [save positionArrInit];
        [save choiceArrInit];
    }
    
    return save;
}

- (NSMutableArray *)allSelectJobInfo
{
    
    NSArray *keys = [_jobDic allKeys];
    
    NSMutableArray *jobArray = [[NSMutableArray alloc]init];
    
    //遍历数组
    for (NSString *key in keys)
    {
        //取出self.jobDic中所有的职业，并添加到jobs
        NSMutableArray *arr = [self dicKeyName:key jobKeyName:@"jobName"];
        
        for (NSDictionary *dic in arr) {
            [jobArray addObject:dic];
        }
    }
    
    return jobArray;
}


//删除选中的某个职位
- (BOOL)deleteSelectJob:(NSDictionary *)dic
{

    NSArray *keys = [self.jobDic allKeys];
    
    for (NSString *key in keys)
    {
        //取出self.jobDic中所有的职业，并添加到jobs
        NSMutableArray *arr = [self dicKeyName:key jobKeyName:@"jobName"];
        for (NSDictionary *d in arr)
        {
            if([d isEqualToDictionary:dic])
            {
                [arr removeObject:d];
                 return YES;
            }
        }
    }
    return NO;
}

//返回所有选择的职业
- (NSMutableArray *)allSelectJob
{
    //得到jobdic所有的key
    NSArray *keys = [self.jobDic allKeys];
    NSMutableArray *jobs = [[NSMutableArray alloc]init];
    //遍历数组
    for (NSString *key in keys)
    {
        //取出self.jobDic中所有的职业，并添加到jobs
        NSMutableArray *arr = [self dicKeyName:key jobKeyName:@"jobName"];
        for (NSDictionary *dic in arr) {
            NSString *name = [dic valueForKey:@"code"];
            [jobs addObject:name];
        }
    }
    return jobs;
}

//用来显示按职位订阅中的行业字符串
- (NSString *)industry
{
    NSMutableString *job = [[NSMutableString alloc]init];
    
    NSLog(@"[self.saveArr count] in industry is %d",[self.saveArr count]);
    
    NSMutableArray *arr = [self.positionArr objectAtIndex:1];
    
    [arr removeAllObjects];
    
    if ([self.saveArr count] > 0) //判断行业数组是否为零
    {
        //遍历数组
        for (int i = 0;i <self.saveArr.count;i++)
        {
            jobRead *read = [self.saveArr objectAtIndex:i];
            [arr addObject:read.code];
            if (i < self.saveArr.count - 1)
            {
                [job appendFormat:@"%@,",[[self.saveArr objectAtIndex:i] name]];
            }
            else
            {
                [job appendString:[[self.saveArr objectAtIndex:i] name]];
            }
        }
        
        return job;
        
    }else
    {
        return @"选择行业";
    }
}

//用来显示按职位订阅中的行业字符串代码
- (NSMutableString *)industryCode
{
    NSMutableString *industryStr = [[NSMutableString alloc]init];
    
    NSLog(@"[self.saveArr count] in industry is %d",[self.saveArr count]);
    
    if (self.saveArr.count > 0) //判断行业数组是否为零
    {
        
        for (int i = 0;i <self.saveArr.count;i++)
        {
            jobRead *read = [self.saveArr objectAtIndex:i];
            
            if (i < self.saveArr.count - 1)
            {
                [industryStr appendFormat:@"%@,",read.code];
            }
            else
            {
                [industryStr appendString:read.code];
            }
        }
    
    }
    
    return industryStr;
}

//用来显示按职位订阅中的薪资字符串
- (NSString *)salary
{
    NSMutableString *job = [[NSMutableString alloc]init];
    
    NSLog(@"[self.saveArrSalary count] in salary is %lu",(unsigned long)[self.saveArrSalary count]);
    
    NSMutableArray *arr = [self.positionArr objectAtIndex:3];
    
    [arr removeAllObjects];
    
    if ([self.saveArrSalary count] > 0) //判断行业数组是否为零
    {
        //遍历数组
        for (int i = 0;i <self.saveArrSalary.count;i++)
        {
            GRReadModel *read = [self.saveArrSalary objectAtIndex:i];
            [arr addObject:read.code];
            if (i < self.saveArrSalary.count - 1)
            {
                [job appendFormat:@"%@,",[[self.saveArrSalary objectAtIndex:i] name]];
            }
            else
            {
                [job appendString:[[self.saveArrSalary objectAtIndex:i] name]];
            }
        }
        
        return job;
        
    }else
    {
        return @"选择薪资";
    }
}

//用来显示按职位订阅中的薪资字符串代码
- (NSMutableString *)salaryCode
{
    NSMutableString *industryStr = [[NSMutableString alloc]init];
    
    NSLog(@"[saveArrSalary count] in saveArrSalary is %lu",(unsigned long)[self.saveArrSalary count]);
    
    if (self.saveArrSalary.count > 0) //判断行业数组是否为零
    {
        
        for (int i = 0;i <self.saveArrSalary.count;i++)
        {
            GRReadModel *read = [self.saveArrSalary objectAtIndex:i];
            
            if (i < self.saveArrSalary.count - 1)
            {
                [industryStr appendFormat:@"%@,",read.code];
            }
            else
            {
                [industryStr appendString:read.code];
            }
        }
        
    }
    return industryStr;
}

//用来显示按中的学历字符串
- (NSString *)EDUQua
{
    NSMutableString *job = [[NSMutableString alloc]init];
    
    NSLog(@"[saveArrEduQualification count] in saveArrEduQualification is %lu",(unsigned long)[self.saveArrEduQualification count]);
    
    
    if ([self.saveArrEduQualification count] > 0) //判断行业数组是否为零
    {
        //遍历数组
        for (int i = 0;i <self.saveArrEduQualification.count;i++)
        {
            if (i < self.saveArrEduQualification.count - 1)
            {
                [job appendFormat:@"%@,",[[self.saveArrEduQualification objectAtIndex:i] name]];
            }
            else
            {
                [job appendString:[[self.saveArrEduQualification objectAtIndex:i] name]];
            }
        }
        
        return job;
        
    }else
    {
        return @"选择薪资";
    }
}

//用来显示中的学历字符串代码
- (NSMutableString *)EDUQuaCode
{
    NSMutableString *industryStr = [[NSMutableString alloc]init];
    
    NSLog(@"[saveArrSalary count] in saveArrSalary is %lu",(unsigned long)[self.saveArrEduQualification count]);
    
    if (self.saveArrEduQualification.count > 0) //判断行业数组是否为零
    {
        
        for (int i = 0;i <self.saveArrEduQualification.count;i++)
        {
            GRReadModel *read = [self.saveArrEduQualification objectAtIndex:i];
            
            if (i < self.saveArrEduQualification.count - 1)
            {
                [industryStr appendFormat:@"%@,",read.code];
            }
            else
            {
                [industryStr appendString:read.code];
            }
        }
        
    }
    return industryStr;
}


//添加，name是职位类别的名字
//- (void)exsitNameKey:(NSString *)name
//{
//    NSArray *keyNames = [_jobDic allKeys];
//    
//    //将_jobDic中为空的键都删除
//    for (int i = 0; i < [keyNames count]; i++) {
//        if (![_jobDic valueForKey:[keyNames objectAtIndex:i]])
//        {
//            [_jobDic removeObjectForKey:[keyNames objectAtIndex:i]];
//        }
//    }
//    
//    /**判断当前字典下是否存在键为name的项**/
//    if (![self key:name existInArray:keyNames]) {
//        //如果jobDic中不存在当前name,那么添加
//        NSMutableArray *jobNameArr = [NSMutableArray array];
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:jobNameArr,@"jobName", nil];
//        [_jobDic setObject:dic forKey:name];
//    }
//}

-(void)exsitNameKey:(NSString *)positionName
{
    NSArray *keyNames=[_jobDic allKeys];
    
    //
    if (![self key:positionName existInArray:keyNames]){
        NSMutableArray *jobNameArr=[NSMutableArray array];
        NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:jobNameArr,@"jobName", nil];
        [_jobDic setObject:dic forKey:positionName];
    }
}

/**判断keyName是否存在于后面的数组中**/
- (BOOL)key:(NSString *)keyName existInArray:(NSArray *)array
{
    for (NSString *str in array) {
        if ([str isEqualToString:keyName]){
            return YES;
        }
    }
    return NO;
}


//用来显示按职位订阅中的职业字符串
- (NSString *)jobStr
{
    NSMutableString *jobStr = [[NSMutableString alloc]init];
    
    NSArray *keys = [self.jobDic allKeys];//得到当前字典的所有键
    
    //将用来存放职业的数组取出来
    NSMutableArray *arr = [self.positionArr objectAtIndex:2];
    
    [arr removeAllObjects];
    
    if ([keys count] == 0)
    {
        return @"选择职业";
    }else
    {
        
        for (NSInteger i = 0;i < keys.count;i++)//遍历已选择的职业，将其添加到positionArr（存放所有选择的信息）数组中
        {
            
            NSMutableArray *jobArr = [self dicKeyName:[keys objectAtIndex:i] jobKeyName:@"jobName"];
            
            for (NSInteger j = 0;j < [jobArr count];j++)
            {
                
                NSDictionary *dic = [jobArr objectAtIndex:j];
                
                [arr addObject:[dic valueForKey:@"code"]];
                
                if (i == [keys count]-1 && j == [jobArr count] -1)
                {
                    [jobStr appendFormat:@"%@",[dic valueForKey:@"name"]];
                }else
                {
                    [jobStr appendFormat:@"%@,",[dic valueForKey:@"name"]];
                }
                
            }
        }
        
        return jobStr;
    }
}

//用来显示按职位订阅中的职业字符串
- (NSString *)jobCodeStr
{
    NSMutableString *jobStr = [[NSMutableString alloc]init];
    NSArray *keys = [self.jobDic allKeys];
    //将用来存放职业的数组取出来
    NSMutableArray *arr = [self.positionArr objectAtIndex:2];
    
    if (keys.count == 0)
    {
        return @"不限";
    }
    else
    {
        [arr removeAllObjects];
        
        //遍历已选择的职业，将其添加到positionArr（存放所有选择的信息）数组中
        for (NSInteger i = 0;i < keys.count;i++)
        {
            NSMutableArray *jobArr = [self dicKeyName:[keys objectAtIndex:i] jobKeyName:@"jobName"];
            for (NSInteger j = 0;j < jobArr.count;j++)
            {
                NSDictionary *dic = [jobArr objectAtIndex:j];
                
                [arr addObject:[dic valueForKey:@"code"]];
                
                if (i == [keys count]-1 && j == [jobArr count] -1)
                {
                    [jobStr appendFormat:@"%@",[dic valueForKey:@"code"]];
                }
                else
                {
                    [jobStr appendFormat:@"%@,",[dic valueForKey:@"code"]];
                }
            }
        }
        
        return jobStr;
    }
}

//positionArr初始化
- (void)positionArrInit
{
    /*
     1.选择行业
     2.选择职业
     3.待遇
     4.职位类型
     5.学历
     6.工作经验
     7.发布时间
     8.公司性质
     */
    //
    
    
    for (int i = 0; i <9; i++)
    {
        if (i ==1 || i == 2)
        {
            //将存放行业和职业的数组添加到positionArr
            NSMutableArray *workArray = [[NSMutableArray alloc]init];
            [_positionArr addObject:workArray];
        }
        else
        {
            jobRead *read = [[jobRead alloc]init];
            switch (i)
            {
                case 0:
                    
                    read.code=@"";
                    
                case 3:     //待遇
                    read.code = @"";
                    read.name=@"不限";
                    break;
                case 4:     //职位类型
                    read.code = @"";
                    read.name=@"不限";
                    break;
                case 5:    //学历
                    read.code = @"";
                    read.name=@"不限";
                    break;
                case 6:   //工作经验
                    read.code = @"";
                    read.name=@"不限";
                    break;
                case 7:  //发布时间
                    read.code = @"";
                    read.name=@"不限";
                    break;
                 case 8: //公司性质
                    read.code=@"";
                    read.name=@"不限";
                    break;
            }
            
            [self.positionArr addObject:read];
        }
    }
}

- (void)choiceArrInit
{
    for (int i = 0; i <6; i++)
    {
  
        jobRead *read = [[jobRead alloc]init];
        switch (i)
        {
            case 0:     //发布时间
                read.code = @"";

                break;
            case 1:     //工作经验
                read.code = @"";
                break;
            case 2:    //学历
                read.code = @"";
                break;
            case 3:   //待遇
                read.code = @"";
                break;
            case 4:  //职位类型
                read.code = @"";
                break;
            case 5: //公司性质
                read.code=@"";
                break;
        }
        read.name=@"不限";
        [self.choiceArr addObject:read];
    }
}

- (void)seniorChoiceArrInit
{
    for (int i = 0; i <6; i++)
    {
        
        jobRead *read = [[jobRead alloc]init];
        switch (i)
        {
            case 0:     //行业
                read.code = @"";
                
                break;
            case 1:     //职业
                read.code = @"";
                break;
            case 2:    //排序方式
                read.code = @"";
                break;
            case 3:   //工作经验
                read.code = @"";
                break;
            case 4:  //学历
                read.code = @"";
                break;
            case 5: //公司性质
                read.code=@"";
                break;
        }
        read.name=@"";
        [self.seniorChoiceArr addObject:read];
    }
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

//返回已选择职业数组
- (NSMutableArray *)dicKeyName:(NSString *)jobItem jobKeyName:(NSString *)jobName
{
    NSMutableArray*mutableArray = [[self.jobDic valueForKey:jobItem]valueForKey:jobName];
    
    return mutableArray ;
}

//清除订阅数据
- (void)clearTheCache
{
    [self.positionArr removeAllObjects];
    [self positionArrInit];
    [self.choiceArr removeAllObjects];
    [self.seniorChoiceArr removeAllObjects];
    
    [self.saveArr removeAllObjects];
    [self.saveArrSalary removeAllObjects];
    [self.saveArrEduQualification removeAllObjects];
    [self.jobDic removeAllObjects];
}

//过滤字符串中的错误字符
+ (NSString *)string2Json2:(NSString *)jsonString{
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r"withString:@"\\r"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@" "withString:@""];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\n"withString:@"&"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\t"withString:@"\\t"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\r\n"withString:@"\\r\\n"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\f"withString:@"\\f"];
    jsonString=[jsonString stringByReplacingOccurrencesOfString:@"\\"withString:@"\\\\"];
    return jsonString;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
}

//将unicode代码转化为字符串
+(NSString *)replaceUnicode:(NSString *)unicodeStr {

    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
