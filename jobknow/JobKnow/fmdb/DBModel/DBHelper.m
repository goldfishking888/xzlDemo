//
//  JKDataBase.m
//  JKBaseModel
//
//  Created by zx_04 on 15/6/24.
//
//

#import "DBHelper.h"
#import "XZLPMDetailModel.h"
#import "XZLPMListModel.h"
#import "GRBookerModel.h"

@interface DBHelper ()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end

@implementation DBHelper

static DBHelper *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    
    return _instance;
}

+ (NSString *)dbPath
{
    NSString *docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *filemanage = [NSFileManager defaultManager];
    docsdir = [docsdir stringByAppendingPathComponent:@"DB"];
    BOOL isDir;
    BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
    if (!exit || !isDir) {
        [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *userUid = [NSString stringWithFormat:@"%@",[mUserDefaults objectForKey:@"userUid"]];
    if (userUid.length == 0 || [userUid isEqualToString:@"(null)"] == YES) {
        userUid = @"default";
    }
    NSString *dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db",userUid]];
    return dbpath;
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil || ([_dbQueue.path isEqualToString:[self.class dbPath]] == NO)) {// 当路径变化时，重新创建_dbQueue
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:[self.class dbPath]];
    }
    return _dbQueue;
}

- (void)switchDatabase{
    [self dbQueue];
    //create Table
    [XZLPMListModel createTable];
    [XZLPMDetailModel createTable];
    //订阅器
    [GRBookerModel createTable];
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [DBHelper shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [DBHelper shareInstance];
}

#if ! __has_feature(objc_arc)
- (oneway void)release
{
    
}

- (id)autorelease
{
    return _instance;
}

- (NSUInteger)retainCount
{
    return 1;
}
#endif

@end
