//
//  AliPayModel.m
//  yellowpage
//
//  Created by 孙扬 on 2017/2/17.
//  Copyright © 2017年 com.yingnet. All rights reserved.
//

#import "AliPayModel.h"

@implementation AliPayModel
+ (AliPayModel *)modelWithDic:(NSDictionary *)dic
{
    if (dic.count == 0) {
        return nil;
    }
    AliPayModel *model = [[AliPayModel alloc] init];
    model.app_id = [dic objectForKey:@"app_id"];
    model.biz_content =[dic objectForKey:@"biz_content"];
    model.charset = [dic objectForKey:@"charset"];
    model.method = [dic objectForKey:@"method"];
    model.notify_url = [dic objectForKey:@"notify_url"];
    model.sign = [dic objectForKey:@"sign"];
    model.sign_type = [dic objectForKey:@"sign_type"];
    model.timestamp = [NSString stringWithFormat:@"%@",[dic objectForKey:@"timestamp"]];
    model.version = [dic objectForKey:@"version"];
    
    return model;
}
@end
