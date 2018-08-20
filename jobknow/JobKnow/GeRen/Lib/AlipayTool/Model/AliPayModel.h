//
//  AliPayModel.h
//  yellowpage
//
//  Created by 孙扬 on 2017/2/17.
//  Copyright © 2017年 com.yingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayModel : NSObject

@property (nonatomic,copy) NSString *app_id;
@property (nonatomic,copy) NSString *biz_content;
@property (nonatomic,copy) NSString *charset;
@property (nonatomic,copy) NSString *method;
@property (nonatomic,copy) NSString *notify_url;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *sign_type;
@property (nonatomic,copy) NSString *timestamp;
@property (nonatomic,copy) NSString *version;

+ (AliPayModel *)modelWithDic:(NSDictionary *)dic;

@end
