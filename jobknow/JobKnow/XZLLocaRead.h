//
//  XZLLocaRead.h
//  XzlEE
//
//  Created by ralbatr on 14-10-29.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLLocaRead : NSObject
@property (nonatomic, assign) NSInteger l_id;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *son;
@property (nonatomic, strong) NSMutableArray *modelArray;

- (id)initWithId:(NSInteger)l_id lcode:(NSString *)lcode lname:(NSString *)lname lson:(NSString *)lson;
- (NSString *)getCodeNameStr:(NSString *)nameStr;
- (NSString *)getWorkYear:(NSString *) workyearStr Num1:(NSInteger) num1 Num2:(NSInteger)num2;
- (NSString *)getjob_sortStr:(NSString *)job_sortStr;

+ (id)standardDefault;
+ (id)shareInstance;
@end
