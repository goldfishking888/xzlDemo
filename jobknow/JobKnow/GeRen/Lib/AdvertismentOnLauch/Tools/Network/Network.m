 //
//  Network.m
//  XHLaunchAdExample
//
//  Created by zhuxiaohui on 2016/6/28.
//  Copyright © 2016年 it7090.com. All rights reserved.
//  代码地址:https://github.com/CoderZhuXH/XHLaunchAd
//  数据请求类
#import "Network.h"

@implementation Network

/**
 *  此处模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdImageDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSDictionary *dic = [mUserDefaults valueForKey:@"AdDic"];
//        if (dic) {
//            success(dic);
//        }
        
//        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchImageAd" ofType:@"json"]];
//        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        NSMutableDictionary *paramDic = [NSMutableDictionary new];
        NSString *url = [NSString stringWithFormat:@"%@%@",KAPPAPI,@"/api/advertising/start"];
//
        [XZLNetWorkUtil requestGETURL:url params:paramDic success:^(id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSString *error = responseObject[@"error"];
                NSString *msg = responseObject[@"msg"];
                // NSString *outLimit = responseObject[@"outLimit"];
                if ([error intValue] == 0) {
                    NSArray *array = responseObject[@"data"];
                    NSDictionary *dic = array[0];
                    NSLog(@"广告数据 = %@",dic);
                    success(dic);
                    
                }
            }else{
                
            }
        } failure:^(NSError *error) {
            
        }];
//        if(success) success(json);

    });
}
/**
 *  此处模拟广告数据请求,实际项目中请做真实请求
 */
+(void)getLaunchAdVideoDataSuccess:(NetworkSucess)success failure:(NetworkFailure)failure;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LaunchVideoAd" ofType:@"json"]];
        NSDictionary *json =  [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        if(success) success(json);
        
    });
}
@end
