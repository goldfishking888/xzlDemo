//
//  HrSelectBankViewController.h
//  JobKnow
//
//  Created by admin on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol HrSelectBankDelegate<NSObject>

- (void)didSelectBank:(NSString *)bankCode bankName:(NSString *)bankName;

@end


@interface HrSelectBankViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) id<HrSelectBankDelegate> delegate;

@end
