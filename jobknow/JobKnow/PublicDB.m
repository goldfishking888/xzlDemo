//
//  PublicDB.m
//  MyPhone
//
//  Created by Ibokan on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PublicDB.h"
#define kDBNameAndType @"jobdatabase.sqlite"
#define kDBName @"jobdatabase"
@implementation PublicDB

static sqlite3 *dbPointer = nil;

//打开数据库
+ (sqlite3 *)openDataBase
{
    if (dbPointer) {
        return dbPointer;
    } else {
        
        NSString *srcPath = [[NSBundle mainBundle] pathForResource:kDBName ofType:@"sqlite"];
        sqlite3_open([srcPath UTF8String], &dbPointer);
        return dbPointer;
    }
}

//关闭数据库
+ (void)closeDataBase
{
    if (dbPointer)
    {
        sqlite3_close(dbPointer);
        dbPointer = NULL;
    }
}

@end
