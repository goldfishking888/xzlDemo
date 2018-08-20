//
//  CityDetailModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDetailModel : NSObject
@property (nonatomic ,copy) NSString *letter;// id
@property (nonatomic ,copy) NSString *city;//
@property (nonatomic ,copy) NSString *code;//

+ (CityDetailModel *)ModelWithDic:(NSDictionary*)dic;
@end
