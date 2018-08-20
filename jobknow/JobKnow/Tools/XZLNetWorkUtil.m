//
//  XZLNetWorkUtil.m
//  JobKnow
//
//  Created by 孙扬 on 2017/4/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "XZLNetWorkUtil.h"

#import "AFNetworking.h"

@implementation XZLNetWorkUtil

+ (void)requestPostURL:(NSString *)urlString
                params:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    if (!parameters) {
        parameters = [[NSDictionary alloc] init];
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    [dic setValue:kAppVersion forKey:@"version"];
    [dic setValue:IMEI forKey:@"imei"];
    [dic setValue:@"iOS" forKey:@"platform"];
    [dic setValue:[XZLUserInfoTool getToken] forKey:@"token"];

    // 设置UserAgent（所有的api请求都应该设置UserAgent）
    //    [manager.requestSerializer setValue:[NSString stringWithFormat:@"IOSDuobao Version/%@/",[MyUtil getShortVersion]] forHTTPHeaderField:@"User-Agent"];
    [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)requestPostURLWithoutAddingParams:(NSString *)urlString
                params:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    
    
    // 设置UserAgent（所有的api请求都应该设置UserAgent）
    //    [manager.requestSerializer setValue:[NSString stringWithFormat:@"IOSDuobao Version/%@/",[MyUtil getShortVersion]] forHTTPHeaderField:@"User-Agent"];
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}


+ (void)requestGETURL:(NSString *)urlString
               params:(NSDictionary *)parameters
              success:(void (^)(id responseObject))success
              failure:(void (^)(NSError *error))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:30.0];
    
    [parameters setValue:kAppVersion forKey:@"version"];
    [parameters setValue:IMEI forKey:@"imei"];
    [parameters setValue:@"iOS" forKey:@"platform"];
    
    // 设置UserAgent（所有的api请求都应该设置UserAgent）
    //    [manager.requestSerializer setValue:[NSString stringWithFormat:@"IOSDuobao Version/%@/",[MyUtil getShortVersion]] forHTTPHeaderField:@"User-Agent"];
    [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+(void)uploadImageWithUrl:(NSString *)urlString
                    Image:(UIImage *)image
                   params:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if (!parameters) {
        parameters = [[NSDictionary alloc] init];
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];

    
    NSURLSessionDataTask *task = [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"Filedata"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task,id _Nullable responseObject) {
        //上传成功
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        //上传失败
        if (failure) {
            failure(error);
        }
    }];
}


@end
