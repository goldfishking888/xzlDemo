//
//  jobRead.h
//  JobsGather
//
//  Created by faxin sun on 13-1-29.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PublicDB.h"

@interface jobRead : NSObject

@property (nonatomic,assign)NSInteger j_id;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *name;

- (id)initWithID:(NSInteger)j_id JobCode:(NSString *)code JobName:(NSString *)jobName;
- (id)initWithID:(NSInteger)j_id WorkCode:(NSString *)code WorkName:(NSString *)workName;

+ (NSArray *)findAllWith:(NSString *)tableName;
+ (BOOL)add:(jobRead *)job WithTable:(NSString *)tableName;

@end
