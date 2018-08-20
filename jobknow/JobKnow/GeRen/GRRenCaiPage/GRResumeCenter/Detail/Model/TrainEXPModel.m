//
//  TrainEXPModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "TrainEXPModel.h"

@implementation TrainEXPModel
//@property (copy,nonatomic) NSString *train_name;
//@property (copy,nonatomic) NSString *date_start;
//@property (copy,nonatomic) NSString *date_end;
//@property (copy,nonatomic) NSString *train_city;
//@property (copy,nonatomic) NSString *train_cer;
//@property (copy,nonatomic) NSString *train_intro;

- (id)init
{
    if (self = [super init])
    {
        self.train_id = @"";
        self.resumeId = @"";
        self.train_name = @"";
        self.train_city = @"";
        self.date_start = @"";
        self.date_end = @"";
        self.train_cer = @"";
        self.train_intro = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.train_id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"rid"]];
        self.train_name = [NSString stringWithFormat:@"%@",dic[@"institute"]];
        self.train_city = [NSString stringWithFormat:@"%@",dic[@"addr"]];
        self.train_city = [self.train_city stringWithoutShi];
        self.date_start = [NSString stringWithFormat:@"%@",dic[@"start_at"]];
        self.date_start = [self.date_start stringWithoutRi];
        self.date_end = [NSString stringWithFormat:@"%@",dic[@"end_at"]];
        self.date_end = [self.date_end stringWithoutRi];
        self.train_cer = [NSString stringWithFormat:@"%@",dic[@"certificate"]];
        self.train_intro = [NSString stringWithFormat:@"%@",dic[@"describe"]];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TrainEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.train_id = [self.train_id copy];
    obj.resumeId = [self.resumeId copy];
    
    obj.train_name = [self.train_name copy];
    obj.train_city = [self.train_city copy];
    obj.date_start = [self.date_start copy];
    obj.date_end = [self.date_end copy];
    obj.train_cer = [self.train_cer copy];
    obj.train_intro = [self.train_intro copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    TrainEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.train_id = [self.train_id mutableCopy];
    obj.resumeId = [self.resumeId mutableCopy];
    
    obj.train_name = [self.train_name mutableCopy];
    obj.train_city = [self.train_city mutableCopy];
    obj.date_start = [self.date_start mutableCopy];
    obj.date_end = [self.date_end mutableCopy];
    obj.train_cer = [self.train_cer mutableCopy];
    obj.train_intro = [self.train_intro mutableCopy];
    return obj;
}


@end
