//
//  CityModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/11.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject
//list
@property (nonatomic ,copy) NSString *letter;// id
@property (nonatomic ,copy) NSArray *list;//

+ (CityModel *)ModelWithDic:(NSDictionary*)dic;


@end
