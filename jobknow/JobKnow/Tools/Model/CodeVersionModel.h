//
//  CodeVersionModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/24.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeVersionModel : NSObject
@property (nonatomic ,copy) NSString *salary;//
@property (nonatomic ,copy) NSString *work_year;//
@property (nonatomic ,copy) NSString *company_crop;//
@property (nonatomic ,copy) NSString *company_size;//
@property (nonatomic ,copy) NSString *marriage;//
@property (nonatomic ,copy) NSString *degree;//
@property (nonatomic ,copy) NSString *work_crop;//
@property (nonatomic ,copy) NSString *now_status;//
@property (nonatomic ,copy) NSString *position_complain;//

+ (CodeVersionModel *)modelWithDic:(NSDictionary*)dic;
@end
