//
//  XZLNetWorkUtil.h
//  JobKnow
//
//  Created by 孙扬 on 2017/4/6.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZLNetWorkUtil : NSObject

// api请求（POST方法）
+ (void)requestPostURL:(NSString *)urlString params:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)requestPostURLWithoutAddingParams:(NSString *)urlString
                                   params:(NSDictionary *)parameters
                                  success:(void (^)(id responseObject))success
                                  failure:(void (^)(NSError *error))failure;
// api请求（GET方法）
+ (void)requestGETURL:(NSString *)urlString params:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
//上传图片文件
+(void)uploadImageWithUrl:(NSString *)urlString
                    Image:(UIImage *)image
                   params:(NSDictionary *)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;

@end
