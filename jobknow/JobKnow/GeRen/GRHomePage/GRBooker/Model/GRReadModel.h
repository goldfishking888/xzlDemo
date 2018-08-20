//
//  GRReadModel.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRReadModel : NSObject

@property (nonatomic ,copy) NSString *code;// id
@property (nonatomic ,copy) NSString *name;//

+ (GRReadModel *)ModelWithDic:(NSDictionary*)dic;

@end
