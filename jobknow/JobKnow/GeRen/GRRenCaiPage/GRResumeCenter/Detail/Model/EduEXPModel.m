//
//  EduEXPModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "EduEXPModel.h"

@implementation EduEXPModel
//@property (copy,nonatomic) NSString *university;
//@property (copy,nonatomic) NSString *date_start;
//@property (copy,nonatomic) NSString *date_end;
//@property (copy,nonatomic) NSString *major;
//@property (copy,nonatomic) NSString *degree;

- (id)init
{
    if (self = [super init])
    {
        self.EDUExp_Id = @"";
        self.resumeId = @"";
        self.university = @"";
        self.date_start = @"";
        self.date_end = @"";
        self.major = @"";
        self.major_code = @"";
        self.degree = @"";
        self.degree_code = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.EDUExp_Id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"rid"]];
        self.university = [NSString stringWithFormat:@"%@",dic[@"school"]];
        self.date_start = [NSString stringWithFormat:@"%@",dic[@"start_at"]];
        self.date_start = [self.date_start stringWithoutRi];
        self.date_end = [NSString stringWithFormat:@"%@",dic[@"end_at"]];
        self.date_end = [self.date_end stringWithoutRi];
        self.major = [NSString stringWithFormat:@"%@",dic[@"major"]];
        self.major_code = [NSString stringWithFormat:@"%@",dic[@"major_code"]];
        self.degree = [NSString stringWithFormat:@"%@",dic[@"degree"]];
        self.degree_code = [NSString stringWithFormat:@"%@",dic[@"degree_code"]];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    EduEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.EDUExp_Id = [self.EDUExp_Id copy];
    obj.resumeId = [self.resumeId copy];
    obj.university = [self.university copy];
    obj.date_start = [self.date_start copy];
    obj.date_end = [self.date_end copy];
    obj.major = [self.major copy];
    obj.major_code = [self.major_code copy];
    obj.degree = [self.degree copy];
    obj.degree_code = [self.degree copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    EduEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.EDUExp_Id = [self.EDUExp_Id mutableCopy];
    obj.resumeId = [self.resumeId mutableCopy];
    obj.university = [self.university mutableCopy];
    obj.date_start = [self.date_start mutableCopy];
    obj.date_end = [self.date_end mutableCopy];
    obj.major = [self.major mutableCopy];
    obj.major_code = [self.major_code mutableCopy];
    obj.degree = [self.degree mutableCopy];
    obj.degree_code = [self.degree mutableCopy];
    return obj;
}

@end
