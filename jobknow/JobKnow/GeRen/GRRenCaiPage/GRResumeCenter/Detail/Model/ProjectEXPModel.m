//
//  ProjectEXPModel.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/3.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "ProjectEXPModel.h"

@implementation ProjectEXPModel

//@property (copy,nonatomic) NSString *project_name;
//@property (copy,nonatomic) NSString *date_start;
//@property (copy,nonatomic) NSString *date_end;
//@property (copy,nonatomic) NSString *duty_content;
//@property (copy,nonatomic) NSString *project_intro;

- (id)init
{
    if (self = [super init])
    {
        self.project_ID = @"";
        self.resumeId = @"";
        self.project_name = @"";
        self.date_start = @"";
        self.date_end = @"";
        self.duty_content = @"";
        self.project_intro = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.project_ID = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.resumeId = [NSString stringWithFormat:@"%@",dic[@"rid"]];
        self.project_name = [NSString stringWithFormat:@"%@",dic[@"project_name"]];
        self.date_start = [NSString stringWithFormat:@"%@",dic[@"project_start_at"]];
        self.date_start = [self.date_start stringWithoutRi];
        self.date_end = [NSString stringWithFormat:@"%@",dic[@"project_end_at"]];
        self.date_end = [self.date_end stringWithoutRi];
        self.duty_content = [NSString stringWithFormat:@"%@",dic[@"project_duty"]];
        self.project_intro = [NSString stringWithFormat:@"%@",dic[@"project_description"]];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ProjectEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.project_ID = [self.project_ID copy];
    obj.resumeId = [self.resumeId copy];
    obj.project_name = [self.project_name copy];
    obj.date_start = [self.date_start copy];
    obj.date_end = [self.date_end copy];
    obj.duty_content = [self.duty_content copy];
    obj.project_intro = [self.project_intro copy];
    return obj;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    ProjectEXPModel *obj = [[[self class] allocWithZone:zone] init];
    obj.project_ID = [self.project_ID mutableCopy];
    obj.resumeId = [self.resumeId mutableCopy];
    obj.project_name = [self.project_name mutableCopy];
    obj.date_start = [self.date_start mutableCopy];
    obj.date_end = [self.date_end mutableCopy];
    obj.duty_content = [self.duty_content mutableCopy];
    obj.project_intro = [self.project_intro mutableCopy];
    return obj;
}
@end
