//
//  GRRegisterModel.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/27.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRRegisterModel : NSObject
@property (nonatomic, strong) NSString *registType;// 1 人才 2猎头顾问
@property (nonatomic, strong) NSString *mobile;// 手机号
@property (nonatomic, strong) NSString *verifyCode;// 验证码
@property (nonatomic, strong) NSString *password;// 密码
@end
