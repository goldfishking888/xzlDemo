//
//  HR_LoginSharedTool.h
//  JobKnow
//
//  Created by Suny on 15/8/21.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HR_LoginSharedTool : NSObject

+(void )saveUserInfoDic:(NSDictionary *)resultDic LoginType:(NSString *)type;
// 注销时清空本地保存的用户信息
+(void )clearUserInfo;
@end
