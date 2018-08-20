//
//  UserDatabase.m
//  JobKnow
//
//  Created by Zuo on 14-1-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "UserDatabase.h"

@implementation UserDatabase

+ (id)sharedInstance {
    
    static id _s;
    
    if (_s == nil) {
        _s = [[[self class] alloc] init];
    }
    return _s;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/tshinghua.db"];
        _db=[FMDatabase databaseWithPath:path];
        //创建数据库对象，数据库还没有打开
        BOOL ret=[_db open];
        
        if (ret ==NO) {
            NSLog(@"数据库打开失败");
            return nil;
        }
        
    }
    return self;
}

#pragma mark 插入数据库的方法

- (BOOL)addOneRecord:(JobModel *)model
{
    if ([self getOneRecordFromXZLAllJobWithBookId:model.bookID] != nil) {//如果当前bookID数据存在，则认为是插入数据成功
        NSLog(@"Jiang--重复数据。。。。。。。。。。");
        return YES;
    }
    NSString *sql = @"insert into XZLAllJob(bookID,positionName,industry,todayData,totalData,city,cityCode,flag,keyWord) values (?,?,?,?,?,?,?,?,?)";
    
    BOOL ret=[_db executeUpdate:sql,model.bookID,model.positionName,model.industry,model.todayData,model.totalData,model.cityStr,model.cityCodeStr,model.flag,model.keyWord];
    if (ret) {
        NSLog(@"插入成功");
    }else
    {
        NSLog(@"插入失败");
    }
    return ret;
}

- (BOOL)addAllRecord2:(NSArray *)cityArray
{
    BOOL ret = true;
    
    NSString *sql = @"insert into CITYINFO(cityCode,cityName,cityletter,com_num,sourceStr,sourceAllStr) values (?,?,?,?,?,?)";
    [_db beginTransaction];
    BOOL isRollBack = NO;
    @try {
   
        for (int i = 0; i<[cityArray count]; i++) {
           City *city=[cityArray objectAtIndex:i];
            BOOL a = [_db executeUpdate:sql,city.code,city.cityName,city.letter,city.com_num,city.sourceStr,city.sourceAllStr];
            if (!a) {
                ret = false;
                NSLog(@"插入失败1");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        ret = false;
        [_db rollback];
    }
    @finally {
        if (!isRollBack) {
            [_db commit];
        }
    }
        return ret;
}

- (BOOL)addOneRecord3:(NSArray*)cityArray
{
    BOOL ret = true;
    NSString *sql = @"insert into CITYINFO2(cityCode,cityName,cityletter) values (?,?,?)";
    [_db beginTransaction];
    BOOL isRollBack = NO;
    @try {
        
        for (int i = 0; i<[cityArray count]; i++) {
            City *city=[cityArray objectAtIndex:i];
            BOOL a = [_db executeUpdate:sql,city.code,city.cityName,city.letter];
            if (!a) {
                ret = false;
                NSLog(@"插入失败1");
            }
        }
    }
    @catch (NSException *exception) {
        isRollBack = YES;
        ret = false;
        [_db rollback];
    }
    @finally {
        if (!isRollBack) {
            [_db commit];
        }
    }
    return ret;
}

- (BOOL)addSearchRecord:(SearchModel*)model
{
    NSString *sql=@"insert into SEARCHINFO(keyWord,cityName,cityCode,industry,industryCode,position,positionCode,salary,salaryCode,jobType,jobTypeCode,education,educationCode,experience,experienceCode,workYear,workYearCode,nature,natureCode) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    
    BOOL ret=[_db executeUpdate:sql,model.keyWord,model.cityName,model.cityCode,model.industry,model.industryCode,model.position,model.positionCode,model.salary,model.salaryCode,model.jobType,model.jobTypeCode,model.education,model.educationCode,model.experience,model.experienceCode,model.workYear,model.workYearCode,model.nature,model.natureCode];
    
    if (ret) {
        NSLog(@"添加搜索条件成功");
    }else
    {
        NSLog(@"添加搜索条件失败");
    }
    return ret;
}


#pragma mark 删除数据库的方法

-(BOOL)deleteRecordAll
{
    NSString *sql = @"delete from XZLAllJob";
    BOOL ret = [_db executeUpdate:sql];
    return ret;
}

-(BOOL)deleteRecordAll2
{
    NSString *sql = @"delete from CITYINFO";
    BOOL ret = [_db executeUpdate:sql];
    return ret;
}

-(BOOL)deleteRecordAll3
{
    NSString *sql = @"delete from CITYINFO2";
    BOOL ret = [_db executeUpdate:sql];
    return ret;
}

-(BOOL)deleteRecord:(JobModel *)model
{
    NSString *sql = @"delete from XZLAllJob where bookID=?";
    BOOL ret = [_db executeUpdate:sql,model.bookID];
    if (ret) {
        NSLog(@"删除成功");
    }else
    {
        NSLog(@"删除失败");
    }
    return ret;
}

-(BOOL)deleteSearchRecord
{
    NSString *sql = @"delete from SEARCHINFO";
    BOOL ret = [_db executeUpdate:sql];
    if (ret) {
        NSLog(@"删除成功");
    }else
    {
        NSLog(@"删除失败");
    }
    return ret;
}


#pragma mark 查询数据库的方法

- (JobModel *)getOneRecordFromXZLAllJobWithBookId:(NSString *)bookId{
    NSString *sql=@"select * from XZLAllJob where bookID=?;";
    FMResultSet *set=[_db executeQuery:sql,bookId];
    while ([set next]) {
        JobModel *model=[[JobModel alloc]init];
        model.bookID=[set stringForColumn:@"bookID"];
        model.positionName=[set stringForColumn:@"positionName"];
        model.industry=[set stringForColumn:@"industry"];
        model.todayData=[set stringForColumn:@"todayData"];
        model.totalData=[set stringForColumn:@"totalData"];
        model.cityStr=[set stringForColumn:@"city"];
        model.cityCodeStr=[set stringForColumn:@"cityCode"];
        model.flag=[set stringForColumn:@"flag"];
        model.keyWord=[set stringForColumn:@"keyWord"];
        return model;
    }
    return nil;
}

- (NSArray *)getAllRecords:(NSString *)flagStr
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select * from XZLAllJob where flag=?;";
    
    FMResultSet *set=[_db executeQuery:sql,flagStr];
    
    while ([set next]) {
        JobModel *model=[[JobModel alloc]init];
        model.bookID=[set stringForColumn:@"bookID"];
        model.positionName=[set stringForColumn:@"positionName"];
        model.industry=[set stringForColumn:@"industry"];
        model.todayData=[set stringForColumn:@"todayData"];
        model.totalData=[set stringForColumn:@"totalData"];
        model.cityStr=[set stringForColumn:@"city"];
        model.cityCodeStr=[set stringForColumn:@"cityCode"];
        model.flag=flagStr;
        model.keyWord=[set stringForColumn:@"keyWord"];
        [_arr addObject:model];
    }
    return _arr;
}

- (NSArray *)getAllRecords
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select * from XZLAllJob;";
    
    FMResultSet *set=[_db executeQuery:sql];
    
    while ([set next]) {
        JobModel *model=[[JobModel alloc]init];
        model.bookID=[set stringForColumn:@"bookID"];
        model.positionName=[set stringForColumn:@"positionName"];
        model.industry=[set stringForColumn:@"industry"];
        model.todayData=[set stringForColumn:@"todayData"];
        model.totalData=[set stringForColumn:@"totalData"];
        model.cityStr=[set stringForColumn:@"city"];
        model.cityCodeStr=[set stringForColumn:@"cityCode"];
        model.flag=[set stringForColumn:@"flag"];
        model.keyWord=[set stringForColumn:@"keyWord"];
        [_arr addObject:model];
    }
    return _arr;
}


- (NSArray *)getAllRecords2
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select * from CITYINFO;";
    
    FMResultSet *set=[_db executeQuery:sql];
    
    while ([set next]) {
        City *city=[[City alloc]init];
        city.code=[set stringForColumn:@"cityCode"];
        city.cityName=[set stringForColumn:@"cityName"];
        city.letter=[set stringForColumn:@"cityletter"];
        city.com_num=[set stringForColumn:@"com_num"];
        city.sourceStr=[set stringForColumn:@"sourceStr"];
        city.sourceAllStr=[set stringForColumn:@"sourceAllStr"];
        [_arr addObject:city];
    }
    
    return _arr;
}

- (NSArray*)getAllRecords2:(NSString *)cityName
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select * from CITYINFO where cityName =?;";
    
    FMResultSet *set=[_db executeQuery:sql,cityName];
    
    while ([set next]) {
        City *city=[[City alloc]init];
        city.code=[set stringForColumn:@"cityCode"];
        city.cityName=[set stringForColumn:@"cityName"];
        city.letter=[set stringForColumn:@"cityletter"];
        city.com_num=[set stringForColumn:@"com_num"];
        city.sourceStr=[set stringForColumn:@"sourceStr"];
        city.sourceAllStr=[set stringForColumn:@"sourceAllStr"];
        [_arr addObject:city];
    }    
    return _arr;
}


- (NSUInteger)getAllRecords2Count
{
    NSString *sql=@"select count(*) from CITYINFO;";
    
    FMResultSet *set=[_db executeQuery:sql];
    
    NSUInteger count=0;
    
    while ([set next]){
        count=[set intForColumnIndex:0];
    }
    
    return count;
}

- (NSUInteger)getAllRecords3Count
{
    NSString *sql=@"select count(*) from CITYINFO2;";
    
    FMResultSet *set=[_db executeQuery:sql];
    
    NSUInteger count=0;
    
    while ([set next]){
        count=[set intForColumnIndex:0];
    }
    
    return count;
}

- (NSArray *)getAllRecords3
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from CITYINFO2;";
    FMResultSet *set=[_db executeQuery:sql];
    
    while ([set next]) {
        City *city=[[City alloc]init];
        city.cityName=[set stringForColumn:@"cityName"];
        city.code=[set stringForColumn:@"cityCode"];
        city.letter=[set stringForColumn:@"cityletter"];
        [_arr addObject:city];
    }
    return _arr;
}


- (NSArray *)getAllRecords4
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select * from SEARCHINFO;";
    
    FMResultSet *set=[_db executeQuery:sql];

    while ([set next]) {
    
        SearchModel *searchModel=[[SearchModel alloc]init];
        
        searchModel.keyWord=[set stringForColumn:@"keyWord"];
        
        searchModel.cityName=[set stringForColumn:@"cityName"];
        searchModel.cityCode=[set stringForColumn:@"cityCode"];
        
        searchModel.industry=[set stringForColumn:@"industry"];
        searchModel.industryCode=[set stringForColumn:@"industryCode"];
        
        searchModel.position=[set stringForColumn:@"position"];
        searchModel.positionCode=[set stringForColumn:@"positionCode"];

        searchModel.salary=[set stringForColumn:@"salary"];
        searchModel.salaryCode=[set stringForColumn:@"salaryCode"];
        
        searchModel.jobType=[set stringForColumn:@"jobType"];
        searchModel.jobTypeCode=[set stringForColumn:@"jobTypeCode"];
        
        searchModel.education=[set stringForColumn:@"education"];
        searchModel.educationCode=[set stringForColumn:@"educationCode"];
        
        searchModel.experience=[set stringForColumn:@"experience"];
        searchModel.experienceCode=[set stringForColumn:@"experienceCode"];
        
        searchModel.workYear=[set stringForColumn:@"workYear"];
        searchModel.workYearCode=[set stringForColumn:@"workYearCode"];
        
        searchModel.nature=[set stringForColumn:@"nature"];
        searchModel.natureCode=[set stringForColumn:@"natureCode"];
        [_arr addObject:searchModel];
    }
    return _arr;
}

- (NSArray *)getAllCityRecords
{
    NSMutableArray *_arr=[[NSMutableArray alloc]init];
    
    NSString *sql=@"select * from XZLAllJob GROUP BY city";
    
   //NSString *sql=@"select distinct  city from XZLAllJob";
    
    FMResultSet*set =[_db executeQuery:sql];
    
    while ([set next]) {
        JobModel *model=[[JobModel alloc]init];
        model.bookID=[set stringForColumn:@"bookID"]?:@"";
        model.positionName=[set stringForColumn:@"positionName"]?:@"";
        model.industry=[set stringForColumn:@"industry"]?:@"";
        model.todayData=[set stringForColumn:@"todayData"]?:@"";
        model.totalData=[set stringForColumn:@"totalData"]?:@"";
        model.cityStr=[set stringForColumn:@"city"]?:@"";
        model.cityCodeStr=[set stringForColumn:@"cityCode"]?:@"";
        model.flag=[set stringForColumn:@"flag"]?:@"";
        [_arr addObject:model];
    }
    
    return _arr;
}

#pragma mark 修改数据库的方法

- (BOOL)modifyOneRecord:(JobModel *)model   //修改每日新增数量
{
    NSString *sql=@"UPDATE XZLAllJob SET todayData =? WHERE bookID=?";
    
    NSString *sql2=@"UPDATE XZLAllJob SET totalData =? WHERE bookID=?";
    
    BOOL ret = [_db executeUpdate:sql,model.todayData,model.bookID];
    
    BOOL ret2=[_db executeUpdate:sql2,model.totalData,model.bookID];
    
    NSLog(@"ret in modifyOneRecord is %d",ret);
    
    NSLog(@"ret2 in modifyOneRecord is %d",ret2);
    
    return ret;
}

@end
