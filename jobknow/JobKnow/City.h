//
//  City.h
//  JobsGather
//
//  Created by faxin sun on 13-2-5.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic,strong)NSString *cid;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *letter;
@property (nonatomic,strong)NSString *com_num;
@property (nonatomic,strong)NSString *sourceStr;
@property (nonatomic,strong)NSString *sourceAllStr;

- (id)initWithID:(NSString*)cid Code:(NSString *)code CityName:(NSString *)cityName Letter:(NSString *)letter sourceStr:(NSString *)sourceStr sourceAllStr:(NSString *)sourceAllStr com_num:(NSString *)com_num;
+ (BOOL)add:(City *)city WithTable:(NSString *)tableName;//添加数据
+ (NSMutableArray *)findAllWith:(NSString *)tableName;//取出所有数据
+ (BOOL)deleteAll;//删除所有数据

@end
