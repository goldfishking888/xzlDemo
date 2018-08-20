//
//  SelectCompanyViewController.h
//  JobKnow
//
//  Created by Jiang on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectCompanyDelegate <NSObject>

- (void)selectCompanyWithPid:(NSString *)pid companyName:(NSString *)name;

@end

@interface SelectCompanyViewController : BaseViewController

@property (nonatomic, weak) id<SelectCompanyDelegate>delegate;
@property (nonatomic, strong) NSString *cityCode;

@end


