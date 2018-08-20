//
//  NetWorkConnection.m
//  JobsGather
//
//  Created by faxin sun on 13-1-22.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "NetWorkConnection.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "OtherLogin.h"
@implementation NetWorkConnection

#pragma mark connection代理方法的实现
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    netConnection = connection;
    
    receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(timeOutMethod:) object:self];
    
    _timeOut = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(receiveDataFinish:Connection:)]) {
        [_delegate receiveDataFinish:receiveData Connection:connection];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(receiveDataFail:)]) {
        [_delegate receiveDataFail:error];
    }    
}

#pragma mark 发送私信方法
- (void)sendMessageWithDictionary:(NSDictionary *)dic
{
    request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    NSArray *keys = [dic allKeys];
    NSMutableString *URLStr = [[NSMutableString alloc] init];
    for(int i = 0;i < keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        if (i==0)
        {
             [URLStr appendFormat:@"%@=%@",key,[NSString stringWithFormat:@"%@",[dic objectForKey:key]]];
        }
        else
        {
             [URLStr appendFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",[dic objectForKey:key]]];
        }
    }
    
    NSLog(@"url----------------------------%@",URLStr);
    
    NSString *url = kCombineURL(KXZhiLiaoAPI, kSendMessage);
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPBody:[URLStr dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark 将传进去的字典和字符串转化为NSURL
+ (NSURL *)dictionaryBecomeUrl:(NSDictionary *)dictionary urlString:(NSString *)urlStr
{
    NSMutableString *URLStr = [NSMutableString stringWithString:urlStr];
    NSArray *keys = [dictionary allKeys];
    for(int i = 0;i < keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        if (i==0)
        {
            [URLStr appendFormat:@"%@=%@",key,[NSString stringWithFormat:@"%@",[dictionary objectForKey:key]]];
        }
        else
        {
            [URLStr appendFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",[dictionary objectForKey:key]]];
        }
    }
    
    NSLog(@"url----------------------------%@",URLStr);
    
    return [NSURL URLWithString:[URLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark 网络请求方法
-(void)sendRequestURLStr:(NSString *)URLStr ParamDic:(NSDictionary *)paramDic Method:(NSString *)method
{
    [self performSelector:@selector(timeOutMethod:) withObject:self afterDelay:30];
    
    _timeOut = YES;
    
    Net *n = [Net standerDefault];
    
    if (n.status == NotReachable) {
        return;
    }
    
    char c = [URLStr characterAtIndex:URLStr.length-1];
    
    NSArray *keys = [paramDic allKeys];
    
    netConnection = nil;
    
    for(int i = 0;i < keys.count;i++)
    {
        
        NSString *key = [keys objectAtIndex:i];
        
        if (i==0) {
            
            if (c == '?'){
                
                URLStr = [URLStr stringByAppendingFormat:@"%@=%@",key,[NSString stringWithFormat:@"%@",[paramDic objectForKey:key]]];
            
            }else
            {
                URLStr = [URLStr stringByAppendingFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",[paramDic objectForKey:key]]];
            }
        }
        else
        {
            URLStr = [URLStr stringByAppendingFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",[paramDic objectForKey:key]]];
        }
        
    }
    
    NSLog(@"url----------------------------%@",URLStr);
    
    NSString *url = [NSString stringWithUTF8String:[URLStr UTF8String]];
    url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSURL *u=[NSURL URLWithString:url];
    request = [[NSMutableURLRequest alloc] initWithURL:u];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)requestCache:(NSString *)urlString param:(NSDictionary *)param
{
    NSArray *keys = [param allKeys];
    
    for(int i = 0;i < keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        
        if (i==0) {
            urlString = [urlString stringByAppendingFormat:@"%@=%@",key,[NSString stringWithFormat:@"%@",[param objectForKey:key]]];
        }
        else
        {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",[param objectForKey:key]]];
        }
        
    }
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"urlstring==========================%@",urlString);
    
    __weak ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:url];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    [request1 setDownloadCache:appDelegate.myCache];
    
    [request1 setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    
    //设置请求超时
    [request1 setTimeOutSeconds:30];
    
    [request1 setRequestMethod:@"GET"];
    
    //设置缓存的有效时间,现在设置的时间是8小时，以后再改
    [request1 setSecondsToCache:60*60*5];
    
    //下载成功
    [request1 setCompletionBlock :^{
    
        NSLog(@"request成功。。。。。。。");
        
        BOOL isCache= [request1 didUseCachedResponse];
        
        if (isCache) {
            NSLog(@"是使用缓存数据。。。。");
        }
        
        NSString *data = [[NSString alloc] initWithData:request1.responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"data is %@",data);
        
        if ([data isEqualToString:@"please login"]) {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
        }
    
        if (_delegate && [_delegate respondsToSelector:@selector(receiveRequestFinish:Connection:)]) {
            [self.delegate receiveRequestFinish:request1.responseData Connection:nil];
        }
    }];
    
    //下载失败
    [request1 setFailedBlock :^{
        NSLog(@"request失败。。。。。。");
        if (_delegate && [_delegate respondsToSelector:@selector(receiveRequestFail:)]) {
            [self.delegate receiveRequestFail:nil];
        }
    }];
    
    //开始异步请求
    [request1 startAsynchronous];
}

- (void)request:(NSString *)urlString param:(NSDictionary *)param  andTime:(double)time
{
    NSArray *keys = [param allKeys];
    
    for(int i = 0;i < keys.count;i++)
    {
        NSString *key = [keys objectAtIndex:i];
        
        if (i==0) {
            urlString = [urlString stringByAppendingFormat:@"%@=%@",key,[NSString stringWithFormat:@"%@",[param objectForKey:key]]];
        }
        else
        {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@",key,[NSString stringWithFormat:@"%@",[param objectForKey:key]]];
        }
    }
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"urlstring==========================%@",urlString);
    
    __weak ASIHTTPRequest *request1 = [ASIHTTPRequest requestWithURL:url];
    
    [request1 setTimeOutSeconds:time];
    
    [request1 setRequestMethod:@"GET"];
    
    //下载成功
    [request1 setCompletionBlock :^{
        if (_delegate && [_delegate respondsToSelector:@selector(receiveASIRequestFinish:)]) {
            [self.delegate receiveASIRequestFinish:request1.responseData];
        }
    }];
    [request1 setFailedBlock :^{
        if (_delegate && [_delegate respondsToSelector:@selector(receiveASIRequestFail:)]) {
            [self.delegate receiveASIRequestFail:nil];
        }
    }];
    
    [request1 startAsynchronous];
}

- (void)requestCacheURL:(NSString *)str ParamDic:(NSDictionary *)paramDictionary
{
    NSURLCache *urlCache = [NSURLCache sharedURLCache];
    
    /* 设置缓存的大小为1M*/
    [urlCache setMemoryCapacity:1*1024*1024];
    
    //创建一个NSURL
    NSURL *url = [NetWorkConnection dictionaryBecomeUrl:paramDictionary urlString:str];
    
    //创建一个请求
    NSMutableURLRequest *requestCache =
    
    [NSMutableURLRequest
     
     requestWithURL:url
     
     cachePolicy:NSURLRequestReloadRevalidatingCacheData
     
     timeoutInterval:40.0f];
    
    //从请求中获取缓存输出
    NSCachedURLResponse *response =
    
    [urlCache cachedResponseForRequest:requestCache];
    
    //判断是否有缓存
    
    if (response != nil){
        
        NSLog(@"如果有缓存输出，从缓存中获取数据");
        NSLog(@"response=============%@",response);
    }
    
    [NSURLConnection connectionWithRequest:requestCache delegate:self];
}

- (void)sendToServerWithImage:(UIImage *)image imageName:(NSString *)name resume:(BOOL)resume companyid:(NSString*) cid
{
    companyId = cid;
    [self sendToServerWithImage:image imageName:name resume:resume];
}


#pragma mark 和图片有关的网络请求
- (void)sendToServerWithImage:(UIImage *)image imageName:(NSString *)name resume:(BOOL)resume
{    
    NSString *TWITTERFON_FORM_BOUNDARY = @"--------------et567z";
    //根据url初始化request
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://timages.hrbanlv.com/pm2/upload"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:15];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 0.8);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"2",@"pflag", nil];

    if (resume) {
        [params setObject:@"1" forKey:@"flag"];
    }
    
    if (companyId.length>0 &&companyId!=nil) {
        [params setObject:companyId forKey:@"otherId"];
    }
    
    [params setObject:@"0" forKey:@"iscom"];
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:@"pic"])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        }
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"%@\"\r\n",name];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: */*\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
   // NSData *resdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [NSURLConnection connectionWithRequest:request delegate:self];

}

#pragma mark - HR圈上传头像
-(void)send_HRIcon_ToServerWithImage:(UIImage *)image imageName:(NSString *)name param:(NSMutableDictionary *)params withURLStr:(NSString *)URLStr
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"--------------et567z";
    //根据url初始化request
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLStr]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:15];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 0.8);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"%@\"\r\n",name];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: */*\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    // NSData *resdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
//简历上传头像
- (void)send2ToServerWithImage:(UIImage *)image imageName:(NSString *)name param:(NSMutableDictionary *)params
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"--------------et567z";
    //根据url初始化request
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"new_api/loginuser/usr_face?"];
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:15];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 0.8);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"%@\"\r\n",name];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: */*\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    // NSData *resdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}


/*
 *发送语音
 *soundPath语音文件路径
 *文件名称
 *文件时长
 *resume，yes则是上传简历语音，no发送私信语音
 */
- (void)sendToServerWithSound:(NSString *)soundPath soundName:(NSString *)name min:(NSString *)minetus resume:(BOOL)resume
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"--------------et567z";
    //根据url初始化request
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://timages.hrbanlv.com/pm2/upload"]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:15];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSFileManager *file = [NSFileManager defaultManager];
    
    NSData* data = [file contentsAtPath:soundPath];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"1",@"pflag",@"0",@"flag",minetus,@"soundTime", nil];
    if (resume) {
        [params setValue:@"1" forKey:@"flag"];
    }
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"%@\"\r\n",name];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: */*\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)timeOutMethod:(id)sender
{
        [self cancelReauest];
    if (_delegate && [_delegate respondsToSelector:@selector(requestTimeOut)]) {
        [self.delegate requestTimeOut];
    }
        self.delegate = nil;
}

- (void)cancelReauest
{
    [netConnection cancel];
}

/*
 *发送语音
 *soundPath语音文件路径
 *文件名称
 *文件时长
 *resume，yes则是上传简历语音，no发送私信语音
 */
- (void)sendToServerWithSound2:(NSString *)soundPath soundName:(NSString *)name min:(NSString *)minetus resume:(BOOL)resume companyid:(NSString*) cid
{
    NSString *TWITTERFON_FORM_BOUNDARY = @"--------------et567z";
    //根据url初始化request
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://timages.hrbanlv.com/pm2/upload"]
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:15];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSFileManager *file = [NSFileManager defaultManager];
    
    NSData* data = [file contentsAtPath:soundPath];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"1",@"pflag",@"0",@"flag",minetus,@"soundTime", nil];
    
    [params setObject:cid forKey:@"otherId"];
    if (resume) {
        [params setValue:@"1" forKey:@"flag"];
    }
    
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
    }
    
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明pic字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"Filedata\"; filename=\"%@\"\r\n",name];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: */*\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%d", [myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    //建立连接，设置代理
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}
#pragma mark 清除缓存的方法
+ (void)clearCacheNet
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.myCache clearCachedResponsesForStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
}
@end
