//
//  XZLPMDetailModel.m
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "XZLPMDetailModel.h"

@implementation XZLPMDetailModel
// dic => model
+ (XZLPMDetailModel *)getPMDetailModelWithDic:(NSDictionary *)dic andPMListUid:(NSString *)pmListUid{
    
    XZLPMDetailModel *model = [[XZLPMDetailModel alloc] init];
    NSString *temUid = dic[@"uid"];
    if ([temUid isEqualToString:pmListUid]) {
        model.isSelf = @"0";
    }else{
        model.isSelf = @"1";
    }
//    model.uid = dic[@"uid"];
    model.uid = pmListUid;
    // 设置pk是必须的
    model.pk = [model getPkWithParamName:@"created_time" paramValue:[NSString stringWithFormat:@"%@",dic[@"created_time"]]];
    model.portrait = dic[@"portrait"];
    NSString *nameStr = dic[@"name"];
    model.name = nameStr.length > 0 ? nameStr :@"未实名用户";
    model.content = dic[@"content"];
    model.created_time = dic[@"created_time"];
    model.sendStatus = MessageSendStatusSuccess;// 获取到的数据默认都是成功的
    return model;
    
    
}
@end
