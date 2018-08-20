//
//  MessageListModel.m
//  JobKnow
//
//  Created by Jiang on 15/9/23.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "MessageListModel.h"


@implementation MessageListModel



// dic => model
+ (MessageListModel*)getMessageListModelWithDic:(NSDictionary*)dic IsHistory:(BOOL)isHistroy{
    
    MessageListModel *model = [[MessageListModel alloc] init];
    model.plid = dic[@"plid"];
    // 设置pk是必须的
    model.pk = [model getPkWithParamName:@"plid" paramValue:[NSString stringWithFormat:@"%@",dic[@"plid"]]];
    model.soureId = dic[@"soureId"];
    model.msg = dic[@"msg"];
    model.msgListhead = dic[@"msgListhead"];
    model.name = dic[@"name"];
    model.dateline = dic[@"dateline"];// 日期格式
    model.type = dic[@"type"];
//    model.isread = dic[@"isread"];
    if (isHistroy) {
        model.isread = [NSNumber numberWithInt:1];
    }else{
        model.isread = [NSNumber numberWithInt:0];
    }
    model.destType = dic[@"destType"];
    return model;
}

+ (NSArray *)transients
{
    return [NSArray array];
}

@end
