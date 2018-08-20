//
//  HRSettingViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/16.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRSettingViewController.h"
#import "AppDelegate.h"
#import "XZLCommonWebViewController.h"
#import "SRAlertView.h"

@interface HRSettingViewController ()<UITableViewDelegate,UITableViewDataSource,SRAlertViewDelegate>
{
    UITableView * _tableView;
}


@end

@implementation HRSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"设置"];
    [self initTableView];
}

-(void)initTableView
{
    //高度减去tabbar高度50
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,  44 + self.num, iPhone_width, iPhone_height-50) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBA(245, 245, 245, 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * headBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 20)];
    headBgView.backgroundColor = RGBA(245, 245, 245, 1);
    return headBgView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 1;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"personCellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else
    {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 16, 16)];
        imageV.image = [UIImage imageNamed:@"HR_ChangePSW"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"密码修改";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }else if (indexPath.section == 1 && indexPath.row == 0){
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 16, 16)];
        imageV.image = [UIImage imageNamed:@"HR_FeedBackIcon"];
        [cell addSubview:imageV];
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(imageV.frame.origin.x + imageV.frame.size.width + 10, imageV.frame.origin.y, 150, 18)];
        lab.text = @"意见反馈";
        lab.textColor = RGB(74, 74, 74);
        lab.font = [UIFont systemFontOfSize:15];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width / 2 - 50, 19, 100, 18)];
        lab.text = @"退出账号";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = RGB(255, 146, 4);
        lab.font = [UIFont systemFontOfSize:18];
        [cell addSubview:lab];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
        vc.titleStr = @"密码修改";
        NSString *url = kCombineURL(kTestAPPAPIGR, @"/web/account/update_password");
        vc.urlStr = url;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
        vc.titleStr = @"意见反馈";
        NSString *url = kCombineURL(kTestAPPAPIGR, @"/web/account/feedback");
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?phone_os_version=%@&phone_os=iOS&phone_brand=%@",kDeviceVersion,[XZLUtil getCurrentDeviceModel]]];
        vc.urlStr = url;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        
        [self logout];
    }
}

#pragma mark-退出登录接口
- (void)logout{
    SRAlertView *alertView = [SRAlertView sr_alertViewWithTitle:@"退出登录"
                                                           icon:nil
                                                        message:@"您确定要立即退出吗？"
                                                leftActionTitle:@"取消"
                                               rightActionTitle:@"确定"
                                                 animationStyle:SRAlertViewAnimationNone
                                              selectActionBlock:^(SRAlertViewActionType actionType) {
                                                  NSLog(@"%zd", actionType);
                                                  if (actionType!=0) {
                                                      [self logoutRequest];
                                                  }
                                              }];
    alertView.blurEffect = NO;
    [alertView show];
    
}

-(void)logoutRequest{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTokenResume;
    [paramDic setValue:tokenStr forKey:@"token"];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/account/logout"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                NSDictionary *dataDic = responseObject[@"data"];
                [XZLUserInfoTool clearUserInfo];
                [mUserDefaults removeObjectForKey:@"isLogin"];
                //注销成功
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [app SetRootVC:nil];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
        }
    } failure:^(NSError *error) {
        mGhostView(nil, @"退出登录");
        
    }];
    
    
    NSString *str = [mUserDefaults valueForKey:@"isLogin"];
    NSLog(@"");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
