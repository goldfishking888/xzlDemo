//
//  jobRead.m
//  JobsGather
//
//  Created by faxin sun on 13-1-29.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//
#import "jobRead.h"
@implementation jobRead
- (id)initWithID:(NSInteger)j_id JobCode:(NSString *)code JobName:(NSString *)jobName
{
    self = [super init];
    if (self) {
        self.j_id = j_id;
        self.code = code;
        self.name = jobName;
    }
    return self;
}
- (id)initWithID:(NSInteger)j_id WorkCode:(NSString *)code WorkName:(NSString *)workName
{
    self = [super init];
    if (self) {
        self.j_id = j_id;
        self.code = code;
        self.name = workName;
    }
    return self;
}


//查询数据
+ (NSArray *)findAllWith:(NSString *)tableName
{
    //打开数据库
    sqlite3 *db = [PublicDB openDataBase];
    //创建数据库状态指针
    sqlite3_stmt *stmt;
    //sql语句
    
    //    order_by xxx desc
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, nil);
    //判断sql语句是否操作成功
    if (result == SQLITE_OK) {
        
        //创建可变数组
        NSMutableArray *mutableArray = [NSMutableArray array];
        //判断当前执行行数
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            //获取字段值
            int cId = sqlite3_column_int(stmt, 0);
            const unsigned char * cDomain = sqlite3_column_text(stmt, 1);
            const unsigned char *cStatus = sqlite3_column_text(stmt, 2);
            
            //创建对象
            jobRead *job = [[jobRead alloc]initWithID:cId JobCode:[NSString stringWithUTF8String:(const char *)cDomain] JobName:[NSString stringWithUTF8String:(const char *)cStatus]];
            
            [mutableArray addObject:job];
            
        }
        
        sqlite3_finalize(stmt);//关闭数据库状态指针
        [PublicDB closeDataBase];//关闭数据库
        return mutableArray;//返回成功
        
    } else {
        
        sqlite3_finalize(stmt);//关闭数据库状态指针
        [PublicDB closeDataBase];//关闭数据库
        return nil;//返回失败
    }
}

//添加数据
+ (BOOL)add:(jobRead *)job WithTable:(NSString *)tableName
{
    //打开数据库
    sqlite3 *db = [PublicDB openDataBase];
    //创建数据库状态指针
    sqlite3_stmt *stmt;
    //sql语句
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (workCode,workName) values (\"%@\", \"%@\") ",tableName, job.code,job.name];
    
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, nil);
    //判断sql语句是否操作成功
    if (result == SQLITE_OK) {
        sqlite3_step(stmt);//执行sql语句操作
        sqlite3_finalize(stmt);//关闭数据库状态指针
        [PublicDB closeDataBase];//关闭数据库
        return YES;
    } else {
        sqlite3_finalize(stmt);//关闭数据库状态指针
        [PublicDB closeDataBase];//关闭数据库
        return NO;//返回失败
    }
}



@end
