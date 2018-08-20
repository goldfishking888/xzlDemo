//
//  City.m
//  JobsGather
//
//  Created by faxin sun on 13-2-5.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "City.h"

@implementation City

- (id)initWithID:(NSString*)cid Code:(NSString *)code CityName:(NSString *)cityName Letter:(NSString *)letter sourceStr:(NSString *)sourceStr sourceAllStr:(NSString *)sourceAllStr com_num:(NSString *)com_num
{
    self=[super init];
    
    if (self) {
        _cid=cid;
        _code=code;
        _com_num=com_num;
        _cityName=cityName;
        _letter=letter;
        _sourceStr=sourceStr;
        _sourceAllStr=sourceAllStr;
    }

    return self;
    
    
    
}

-(void)encodeWithCoder:(NSCoder*)aCoder{
    [aCoder encodeObject:self.cid  forKey:@"cid"];
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.letter forKey:@"letter"];
    [aCoder encodeObject:self.sourceStr forKey:@"source"];
    [aCoder encodeObject:self.sourceAllStr forKey:@"sources"];
    [aCoder encodeObject:self.sourceAllStr forKey:@"com_num"];
}

-(id)initWithCoder:(NSCoder*)aDecoder{
    
    if((self=[super init])) {
        self.cid=[aDecoder decodeObjectForKey:@"cid"];
        self.code=[aDecoder decodeObjectForKey:@"code"];
        self.cityName=[aDecoder decodeObjectForKey:@"cityName"];
        self.letter=[aDecoder decodeObjectForKey:@"letter"];
        self.sourceStr=[aDecoder decodeObjectForKey:@"source"];
        self.sourceAllStr=[aDecoder decodeObjectForKey:@"sources"];
        self.com_num=[aDecoder decodeObjectForKey:@"com_num"];
    }
    return self;
}


//添加数据
+ (BOOL)add:(City *)city WithTable:(NSString *)tableName
{
    //打开数据库
    sqlite3 *db = [PublicDB openDataBase];
    sqlite3_stmt *stmt; //创建数据库状态指针
  
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@ (code,cityName,letter,source,sources,com_num) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",tableName,city.code,city.cityName,city.letter,city.sourceStr,city.sourceAllStr,city.com_num];
    

//  NSLog(@"数据存储路径======%@",sqlStr);
    
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, nil);

//判断sql语句是否操作成功
//NSLog(@"error---------sql-------%d",result);
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

//删除所有数据
+ (BOOL)deleteAll
{
    //打开数据库
    sqlite3 *db = [PublicDB openDataBase];
    //创建数据库状态指针
    sqlite3_stmt *stmt;
    //sql语句
    NSString *sqlStr = [NSString stringWithFormat:@"delete from newCityList2"];
    
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


//取数据
+ (NSMutableArray *)findAllWith:(NSString *)tableName
{
    //打开数据库
    sqlite3 *db = [PublicDB openDataBase];
    
    //创建数据库状态指针
    sqlite3_stmt *stmt;
    
    //order_by xxx desc
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",tableName];
    
    int result = sqlite3_prepare_v2(db,[sqlStr UTF8String], -1, &stmt, nil);
    
    //code,cityName,letter,source,sources,com_num
    
    NSLog(@"result is %d",result);
    
    //判断sql语句是否操作成功
    if (result == SQLITE_OK) {
        
        //创建可变数组
        NSMutableArray *mutableArray = [NSMutableArray array];
        //判断当前执行行数
        while (SQLITE_ROW == sqlite3_step(stmt)) {
            //获取字段值
            //int cId = sqlite3_column_int(stmt, 0);
            const unsigned char * cId = sqlite3_column_text(stmt, 0);
            const unsigned char * cCode = sqlite3_column_text(stmt, 1);
            const unsigned char *cCityName = sqlite3_column_text(stmt, 2);
            const unsigned char *cLetter = sqlite3_column_text(stmt, 3);
            const unsigned char *cSource=sqlite3_column_text(stmt,4);
            const unsigned char *cSources=sqlite3_column_text(stmt,5);
            const unsigned char *cCom_num=sqlite3_column_text(stmt,6);
            //创建对象
//           City *city=[[City alloc]initWithID:[NSString stringWithUTF8String:(const char *)cId] Code:[NSString stringWithUTF8String:(const char *)cCode]  CityName:[NSString stringWithUTF8String:(const char *)cCityName]Letter:[NSString stringWithUTF8String:(const char *)cLetter] sourceStr:[NSString stringWithUTF8String:(const char *)cSource]  sourceAllStr:[NSString stringWithUTF8String:(const char *)cSources] ];
            
            City *city=[[City alloc]initWithID:[NSString stringWithUTF8String:(const char *)cId] Code:[NSString stringWithUTF8String:(const char *)cCode]  CityName:[NSString stringWithUTF8String:(const char *)cCityName] Letter:[NSString stringWithUTF8String:(const char *)cLetter] sourceStr:[NSString stringWithUTF8String:(const char *)cSource] sourceAllStr:[NSString stringWithUTF8String:(const char *)cSources] com_num:[NSString stringWithUTF8String:(const char *)cCom_num]];
            
            [mutableArray addObject:city];
        }
        
        NSLog(@"mutableArray===%d",mutableArray.count);
        sqlite3_finalize(stmt);//关闭数据库状态指针
        [PublicDB closeDataBase];//关闭数据库
        return mutableArray;//返回成功
        
    } else {
        
        sqlite3_finalize(stmt);//关闭数据库状态指针
        [PublicDB closeDataBase];//关闭数据库
        return nil;//返回失败
    }
    
}

@end
