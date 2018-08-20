//
//  MessageDetailModel.m
//  JobKnow
//
//  Created by Jiang on 15/9/23.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "MessageDetailModel.h"

@implementation MessageDetailModel


// dic => model
+ (MessageDetailModel*)getMessageDetailModelWithDic:(NSDictionary*)dic{
    
    MessageDetailModel *model = [[MessageDetailModel alloc] init];
    model.pmid = dic[@"pmid"];
    // 设置pk是必须的
    model.pk = [model getPkWithParamName:@"pmid" paramValue:[NSString stringWithFormat:@"%@",dic[@"pmid"]]];
    model.msg = dic[@"msg"];
    model.plid = dic[@"plid"];
    model.isself = dic[@"isself"];
    model.download_url = dic[@"download_url"];
    model.download_url_mini = dic[@"download_url_mini"];
    model.dateline = dic[@"dateline"];// 日期格式
    model.file_real_name = dic[@"file_real_name"];
    model.file_size = dic[@"file_size"];
    model.soundTime = dic[@"soundTime"];
    model.pmtype = dic[@"pmtype"];
    model.pm_type = dic[@"pm_type"];
    model.query_string = dic[@"query_string"];
    model.sendStatus = MessageSendStatusSuccess;// 获取到的数据默认都是成功的
    return model;
}

@end
