//
//  RedEnvelope.h
//  JobKnow
//
//  Created by Apple on 14-7-31.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedEnvelope : NSObject

@property (nonatomic,assign)BOOL  isCanUse;             //使用还是不使用

@property (nonatomic,strong)NSString *envelopeID;       //红包ID

@property (nonatomic,strong)NSString *envelopeCode;     //红包代码

@property (nonatomic,strong)NSString *overdue;      //红包到期时间

@property (nonatomic,strong)NSString *isused;       //是否已经使用过

@property(nonatomic, assign)int money;       //红包的价格

@property (nonatomic,assign)int isOutOfDate; //是否过期

+ (RedEnvelope *)standerDefault;

@end