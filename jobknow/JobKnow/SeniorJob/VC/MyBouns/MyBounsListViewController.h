//
//  MyBounsListViewController.h
//  JobKnow
//
//  Created by Jiang on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBounsListTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *headerIV;// 头像
@property (nonatomic, strong)UILabel *companyNameLabel;// 公司名称
@property (nonatomic, strong)UILabel *jobNameLabel;// 职位名称
@property (nonatomic, strong)UILabel *bounsLabel;// 奖金
@property (nonatomic, strong)UILabel *statusLabel;// 提现状态

- (MyBounsListTableViewCell *)initWithReuseIdentifier:(NSString *)reuserId;

@end


@interface MyBounsListViewController : BaseViewController

@end


