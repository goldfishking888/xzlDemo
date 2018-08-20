//
//  UserDatabase.h
//  JobKnow
//
//  Created by Apple on 14-1-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JobModel.h"
#import "SearchModel.h"
#import "FMDatabase.h"

@interface UserDatabase : NSObject
{
    FMDatabase *_db;
}

+ (id)sharedInstance;

- (BOOL)addOneRecord:(JobModel *)model;//插入表XZLAllJob，存放订阅职位的详细信息
- (BOOL)addAllRecord2:(NSArray *)cityArray;  //插入表CITYINFO，存放的是城市的详细信息
- (BOOL)addOneRecord3:(NSArray*)cityArray;//插入表CITYINFO，存放居住地的详细信息
- (BOOL)addSearchRecord:(SearchModel*)model;//插入表SEARCHINFO,存放居住地的详细信息

- (BOOL)deleteRecord:(JobModel*)model;//删除表XZLAllJob中的某一项
- (BOOL)deleteRecordAll;  //删除XZLAllJob中的所有数据
- (BOOL)deleteRecordAll2; //删除CITYINFO中的所有数据
- (BOOL)deleteRecordAll3; //删除CITYINFO2中的所有数据
- (BOOL)deleteSearchRecord;//删除搜索界面中的所有数据

- (BOOL)modifyOneRecord:(JobModel *)model;//修改表XZLAllJob中的数据

- (JobModel *)getOneRecordFromXZLAllJobWithBookId:(NSString *)bookId;//通过bookid查询XZLAllJob中的一条数据，无数据则返回nil
- (NSArray *)getAllRecords;  //查询XZLAllJob中的所有数据
- (NSArray *)getAllRecords2; //查询CITYINFO中的所有数据
- (NSArray *)getAllRecords3; //查询CITYINFO2中的所有数据
- (NSArray *)getAllRecords4; //查询SEARCHINFO中的所有数据

- (NSUInteger)getAllRecords2Count;  //查询CITYINFO中城市的数量
- (NSUInteger)getAllRecords3Count;  //查询CITYINFO2中城市的数量

- (NSArray *)getAllRecords:(NSString *)flagStr;//查询XZLAllJob中不同flag值的所有数据
- (NSArray*)getAllRecords2:(NSString *)cityName;  //查询某一个城市的所有属性
- (NSArray *)getAllCityRecords;  //查询订阅城市的数据

@end