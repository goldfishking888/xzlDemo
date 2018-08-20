//
//  JKDataBase.h
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBHelper : NSObject

@property (nonatomic, retain, readonly) FMDatabaseQueue *dbQueue;

+ (DBHelper *)shareInstance;

+ (NSString *)dbPath;

// 切换帐号的同时，切换数据库
- (void)switchDatabase;

@end
