//
//  XZLPMListModel.m
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "XZLPMListModel.h"

@implementation XZLPMListModel
// dic => model
+ (XZLPMListModel*)getPMListModelWithDic:(NSDictionary*)dic isHistory:(BOOL)isHistory{
    
    XZLPMListModel *model = [[XZLPMListModel alloc] init];
    model.uid = dic[@"uid"];
    // 设置pk是必须的
    model.pk = [model getPkWithParamName:@"uid" paramValue:[NSString stringWithFormat:@"%@",dic[@"uid"]]];
    model.portrait = dic[@"portrait"];
    NSString *nameStr = dic[@"name"];
    model.name = nameStr.length > 0 ? nameStr :@"未实名用户";
    model.content = dic[@"content"];
    model.created_time = dic[@"created_time"];
//    if (isHistory) {
//        model.unRead = @"0";
//    }else{
//        model.unRead = @"1";
//    }
//    model.unRead = @"1";//测试
    model.unRead = [NSString stringWithFormat:@"%@",dic[@"unRead"]];
    return model;
}
@end
