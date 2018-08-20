//
//  RegisterModel.h
//  JobKnow
//
//  Created by Jiang on 15/10/19.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject

@property (nonatomic, strong) NSString *registType;// 1 求职者；2 HR；3 兼职猎手
@property (nonatomic, strong) NSString *mobile;// 手机号
@property (nonatomic, strong) NSString *verifyCode;// 验证码
@property (nonatomic, strong) NSString *password;// 密码
@end
