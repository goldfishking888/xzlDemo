//
//  XZLLocaRead.m
//  XzlEE
//
//  Created by ralbatr on 14-10-29.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import "XZLLocaRead.h"

@implementation XZLLocaRead

+ (id)standardDefault
{
    static XZLLocaRead *save = nil;
    if (save == nil) {
        save.modelArray = [[NSMutableArray alloc] init];
    }
    return save;
}

+ (id)shareInstance
{
    static XZLLocaRead *dc = nil;
    if (dc == nil) {
        dc = [[[self class] alloc] init];
    }
    return dc;
    
}

- (id)initWithId:(NSInteger)l_id lcode:(NSString *)lcode lname:(NSString *)lname lson:(NSString *)lson
{
    self = [super init];
    if (self) {
        self.l_id = l_id;
        self.name = lname;
        self.son = lson;
        self.code = lcode;
    }
    return self;
}

//hope_city数据解析
- (NSString *)getCodeNameStr:(NSString *)nameStr
{
    //城市code 跟name 数据解析
    NSString *txtPath = [[NSBundle mainBundle] pathForResource:@"expect_city_jsons" ofType:@"txt"];
    
    NSString *resultStr=[[NSString alloc]initWithContentsOfFile:txtPath encoding:NSUTF8StringEncoding error:nil];
    
    //    NSLog(@"resultStr in beginning is %@",resultStr);
    
    NSData *resultData=[NSData dataWithContentsOfFile:txtPath options:NSDataReadingMappedIfSafe error:nil];
    
    NSArray *Dicarray=[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
    

    NSString *endstr;
    NSMutableArray *forarr = [[NSMutableArray alloc] init];
    NSString *locacode;
    
    NSRange range = [nameStr rangeOfString:@","];
//当选择了多个城市的时候
    if (range.location != NSNotFound) {
        
        NSArray *cityArr = [nameStr componentsSeparatedByString:@","];
        
        for (int y = 0; y<cityArr.count; y++) {
            NSString *cityStr = [cityArr objectAtIndex:y];
            
        
        
        for (int i =0; i<Dicarray.count; i++) {
            id objc = [[Dicarray objectAtIndex:i] objectForKey:@"name"];
            
            NSArray *sonarr = [[Dicarray objectAtIndex:i] objectForKey:@"son"];
            //NSLog(@"sonarr=====%d",sonarr.count);
            if (sonarr.count >0) {
                for (int j =0; j<sonarr.count; j++) {
                    NSString *sonstr = [[sonarr objectAtIndex:j] objectForKey:@"name"];
                    //                NSLog(@"name====%@",sonstr);
                    if ([sonstr isEqual:cityStr]) {
                        locacode = [[sonarr objectAtIndex:j] objectForKey:@"code"];
                        //                    NSLog(@"code=====%@",locacode);
                                                
                    }
                }
            }
            
            
            
            if ([cityStr isEqual:objc]) {
                locacode = [[Dicarray objectAtIndex:i] objectForKey:@"code"];
            }
        }
            [forarr addObject:locacode];

    }
        endstr = [forarr componentsJoinedByString:@","];
        
    }
    
    //当只有一个选项时
    if (range.location == NSNotFound) {
        
    
    for (int i =0; i<Dicarray.count; i++) {
        id objc = [[Dicarray objectAtIndex:i] objectForKey:@"name"];
        
        NSArray *sonarr = [[Dicarray objectAtIndex:i] objectForKey:@"son"];
        //NSLog(@"sonarr=====%d",sonarr.count);
        if (sonarr.count >0) {
            for (int j =0; j<sonarr.count; j++) {
                NSString *sonstr = [[sonarr objectAtIndex:j] objectForKey:@"name"];
//                NSLog(@"name====%@",sonstr);
                if ([sonstr isEqual:nameStr]) {
                locacode = [[sonarr objectAtIndex:j] objectForKey:@"code"];
//                    NSLog(@"code=====%@",locacode);
                    endstr = locacode;
                    return endstr;
                }
            }
        }
        
        

        if ([nameStr isEqual:objc]) {
            locacode = [[Dicarray objectAtIndex:i] objectForKey:@"code"];
            endstr = locacode;
        }
    }
    }
    return endstr;
}



//job_str数据解析
- (NSString *)getjob_sortStr:(NSString *)job_sortStr
{
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"occupation" ofType:@"json"];
    
    NSData *Data=[NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingMutableContainers error:nil];
    NSArray *array = [dict objectForKey:@"sort"];
    
    NSString *Jobstr;
    NSString *endstr;
    NSMutableArray *forarr = [[NSMutableArray alloc] init];
    
    
    //当选择了多个职业时处理
    NSRange range = [job_sortStr rangeOfString:@","];
    if (range.location != NSNotFound) {
        NSArray *strArr = [job_sortStr componentsSeparatedByString:@","];
        for (int y =0; y<strArr.count; y++) {
            NSString *Arrstr = [strArr objectAtIndex:y];
            //NSLog(@"arrst====%@",Arrstr);
            
            for (int i =0; i<array.count; i++) {
                id objc = [[array objectAtIndex:i] objectForKey:@"name"];
                
                NSArray *sonarr = [[array objectAtIndex:i] objectForKey:@"son"];
                //NSLog(@"sonarr=====%d",sonarr.count);
                if (sonarr.count >0) {
                    for (int j =0; j<sonarr.count; j++) {
                        NSString *sonstr = [[sonarr objectAtIndex:j] objectForKey:@"name"];
                        //                NSLog(@"name====%@",sonstr);
                        if ([sonstr isEqual:Arrstr]) {
                            Jobstr = [[sonarr objectAtIndex:j] objectForKey:@"code"];
                            //                    NSLog(@"code=====%@",locacode);
                           // NSLog(@"解析===%@",Jobstr);
                            
                        }
                    }
                }
                
                
                
                if ([Arrstr isEqual:objc]) {
                    Jobstr = [[array objectAtIndex:i] objectForKey:@"code"];
                }
            }
            [forarr addObject:Jobstr];
            
            
        }
        
        endstr = [forarr componentsJoinedByString:@","];
        //NSLog(@"endstr====%@",endstr);
    }
    
   //只有一个数据的时候
    if (range.location == NSNotFound) {
        
        for (int i =0; i<array.count; i++) {
            id objc = [[array objectAtIndex:i] objectForKey:@"name"];
            
            NSArray *sonarr = [[array objectAtIndex:i] objectForKey:@"son"];
            //NSLog(@"sonarr=====%d",sonarr.count);
            if (sonarr.count >0) {
                for (int j =0; j<sonarr.count; j++) {
                    NSString *sonstr = [[sonarr objectAtIndex:j] objectForKey:@"name"];
                    //                NSLog(@"name====%@",sonstr);
                    if ([sonstr isEqual:job_sortStr]) {
                        Jobstr = [[sonarr objectAtIndex:j] objectForKey:@"code"];
                        //                    NSLog(@"code=====%@",locacode);
                        //NSLog(@"解析===%@",Jobstr);
                        endstr = Jobstr;
                        return endstr;
                    }
                }
            }
            
            
            
            if ([job_sortStr isEqual:objc]) {
                Jobstr = [[array objectAtIndex:i] objectForKey:@"code"];
            }
        
        }
        endstr = Jobstr;

    }
    
    
    return endstr;
    
    
}
//xml里面的数据解析
- (NSString *)getWorkYear:(NSString *) workyearStr Num1:(NSInteger) num1 Num2:(NSInteger)num2
{
    //年限xml解析;
    NSString *patn = [[NSBundle mainBundle] pathForResource:@"Untitled 2" ofType:@"json"];
    NSData *Data=[NSData dataWithContentsOfFile:patn options:NSDataReadingMappedIfSafe error:nil];
    
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:Data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *resourcesDic = [dict objectForKey:@"resources"];
    NSArray *stringarray = [resourcesDic objectForKey:@"string-array"];
    
    
    NSString *workyear;
    NSMutableArray *endArr = [[NSMutableArray alloc] init];
    NSString *endStr;
    
    NSRange range = [workyearStr rangeOfString:@","];
    //判断是是否选择了多个职业分开解析
    if (range.location != NSNotFound) {
        NSArray *rangeArr = [workyearStr componentsSeparatedByString:@","];
        for (int y =0; y<rangeArr.count; y++) {
            NSString *rangeStr = [rangeArr objectAtIndex:y];
            
            
            
            NSArray *erArray  =[[stringarray objectAtIndex:num1] objectForKey:@"item"];
            
            for (int i = 0; i<erArray.count; i++) {
                if ([[erArray objectAtIndex:i] isEqualToString:rangeStr]) {
                    
                    workyear = [[[stringarray objectAtIndex:num2] objectForKey:@"item"] objectAtIndex:i];
                    //            NSLog(@"workyear====%@",workyear);
                    
                }
            }
            [endArr addObject:workyear];
            
        }
        endStr = [endArr componentsJoinedByString:@","];
        //NSLog(@"workyears====%@",endStr);
        
    }
    //只有一个数据
    if (range.location == NSNotFound) {
    
        
        
        NSArray *erArray  =[[stringarray objectAtIndex:num1] objectForKey:@"item"];
        
        for (int i = 0; i<erArray.count; i++) {
            if ([[erArray objectAtIndex:i] isEqualToString:workyearStr]) {
                
                workyear = [[[stringarray objectAtIndex:num2] objectForKey:@"item"] objectAtIndex:i];
                            NSLog(@"workyear====%@",workyear);
                
            }
        }
        endStr = workyear;
    
    }
    return endStr;
}

@end
