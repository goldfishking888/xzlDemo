//
//  PublicDB.h
//  MyPhone
//
//  Created by Ibokan on 12-9-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "City.h"
@interface PublicDB : NSObject

//打开数据库
+ (sqlite3 *)openDataBase;
//关闭数据库
+ (void)closeDataBase;

@end
