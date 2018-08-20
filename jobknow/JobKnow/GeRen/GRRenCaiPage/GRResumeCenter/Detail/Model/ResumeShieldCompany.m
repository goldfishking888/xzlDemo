//
//  ResumeShieldCompany.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/25.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "ResumeShieldCompany.h"

@implementation ResumeShieldCompany
- (id)init
{
    if (self = [super init])
    {
        self.com_id = @"";
        self.resume_id = @"";
        self.company_name = @"";
        self.user_id = @"";
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        self.com_id = [NSString stringWithFormat:@"%@",dic[@"id"]];
        self.resume_id = [NSString stringWithFormat:@"%@",dic[@"rid"]];
        self.company_name = [NSString stringWithFormat:@"%@",dic[@"company_name"]];
        self.user_id = [NSString stringWithFormat:@"%@",dic[@"user_id"]];
    }
    return self;
}
@end
