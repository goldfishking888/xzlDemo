//
//  NetWorkConnection.h
//  JobsGather
//
//  Created by faxin sun on 13-1-22.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SendRequest.h"
#import "Net.h"

@interface NetWorkConnection : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableData *receiveData;
    NSMutableURLRequest *request;
    NSURLConnection *netConnection;
    NSString *companyId;
}

@property(nonatomic,assign)BOOL timeOut;

@property(nonatomic,assign)id <SendRequest> delegate;

//请求方法
//1.普通网络请求
//- (void)sendRequestURLStr:(NSString *)URLStr ParamDic:(NSDictionary *)paramDic Method:(NSString *)method;
//2.设置了ASIDownloadCache缓存的请求方式
- (void)requestCache:(NSString *)urlString param:(NSDictionary *)param;
//3.NSURLCache缓存的请求方式
- (void)requestCacheURL:(NSString *)str ParamDic:(NSDictionary *)paramDictionary;

- (void)request:(NSString *)urlString param:(NSDictionary *)param  andTime:(double)time;

- (void)sendMessageWithDictionary:(NSDictionary *)dic;
//将字典转化为url
+(NSURL *)dictionaryBecomeUrl:(NSDictionary *)dictionary urlString:(NSString *)urlStr;


//发送图片
- (void)sendToServerWithImage:(UIImage *)image imageName:(NSString *)name resume:(BOOL)resume;
- (void)sendToServerWithImage:(UIImage *)image imageName:(NSString *)name resume:(BOOL)resume companyid:(NSString*) cid;
- (void)send2ToServerWithImage:(UIImage *)image imageName:(NSString *)name param:(NSMutableDictionary *)params;
#pragma mark - HR圈上传头像 参数拼接进来
-(void)send_HRIcon_ToServerWithImage:(UIImage *)image imageName:(NSString *)name param:(NSMutableDictionary *)params withURLStr:(NSString *)URLStr;
//发送语音
- (void)sendToServerWithSound:(NSString *)soundPath soundName:(NSString *)name min:(NSString *)minetus resume:(BOOL)resume;
- (void)sendToServerWithSound2:(NSString *)soundPath soundName:(NSString *)name min:(NSString *)minetus resume:(BOOL)resume companyid:(NSString*) cid;
//清除缓存
+ (void)clearCacheNet;

@end
