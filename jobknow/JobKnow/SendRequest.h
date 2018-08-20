//
//  SendRequest.h
//  JobsGather
//
//  Created by faxin sun on 13-2-22.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendRequest <NSObject>

@optional

//不带缓存
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection;
- (void)receiveDataFail:(NSError *)error;
- (void)requestTimeOut;

//带缓存
- (void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection;
- (void)receiveRequestFail:(NSError *)error;

//ASI代理方法
- (void)receiveASIRequestFinish:(NSData *)receData;
- (void)receiveASIRequestFail:(NSError *)error;

@end
