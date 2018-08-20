//
//  ZXBOrderViewController.m
//  JobKnow
//
//  Created by admin on 14-7-30.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ZXBOrderViewController.h"
#import "UpdateOrderViewController.h"

int Pub_num;

@interface ZXBOrderViewController ()

@end

@implementation ZXBOrderViewController
@synthesize Pub_dic ;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Pub_num = ios7jj;
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"订单详情"];
    
    UIButton *updateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    updateBtn.backgroundColor=[UIColor clearColor];
    updateBtn.frame = CGRectMake(iPhone_width-85,-3+Pub_num,85,50);
    updateBtn.showsTouchWhenHighlighted=YES;
    updateBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [updateBtn setTitle:@"修改订单" forState:UIControlStateNormal];
    [updateBtn setTitle:@"修改订单" forState:UIControlStateHighlighted];
    [updateBtn addTarget:self action:@selector(updateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *canBuy = [NSString stringWithFormat:@"%@",[Pub_dic valueForKey:@"canbuy"]];
 
    NSString *state = [NSString stringWithFormat:@"%@",[Pub_dic valueForKey:@"state"]];
    
    if (![state isEqualToString:@"3"] && ![state isEqualToString:@"23"] && ![state isEqualToString:@"13"]&&[canBuy isEqualToString:@"1"]) {
        [self.view addSubview:updateBtn];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+Pub_num, iPhone_width, iPhone_height - 88-Pub_num) style:UITableViewStyleGrouped];
    tableView.backgroundView = nil;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces=NO;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor=[UIColor clearColor];
    buyBtn.frame = CGRectMake(10,260,300,40);
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [buyBtn setTitle:@"申请赔付" forState:UIControlStateNormal];
    [buyBtn setTitle:@"申请赔付" forState:UIControlStateHighlighted];
    [buyBtn addTarget:self action:@selector(doClaim:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
}

#pragma mark UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    UILabel *lbl01 = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 70,20)];
    lbl01.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
    lbl01.textColor = [UIColor blackColor];
    
    
    UILabel *lbl02 = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 160,20)];
    lbl02.font =  [UIFont systemFontOfSize:14];
    lbl02.textColor = [UIColor blackColor];
    
    NSString *state = [NSString stringWithFormat:@"%@", [Pub_dic valueForKey:@"state"]];
    NSString *stateName = @"";
    
    if([state isEqualToString:@"1"]){
        stateName = @"小宝";
    }else if([state isEqualToString:@"2"] || [state isEqualToString:@"12"]){
        stateName = @"二宝";
    }else if([state isEqualToString:@"3"] || [state isEqualToString:@"13"] || [state isEqualToString:@"23"]){
        stateName = @"三宝";
    }
    
    if (indexPath.row == 0) {
        lbl01.text = @"会员类型";
        lbl02.text = stateName;
    } else if(indexPath.row == 1){
        lbl01.text = @"开通日期";
        lbl02.text = [Pub_dic valueForKey:@"beginTime"];
    } else if(indexPath.row == 2){
        lbl01.text = @"截至日期";
        lbl02.text = [Pub_dic valueForKey:@"endTime"];
    }
    
    [cell.contentView addSubview: lbl01];
    [cell.contentView addSubview: lbl02];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 按钮响应事件

//修改订单
- (void)updateBtnClick:(id)sender
{
    UpdateOrderViewController *uvc = [[UpdateOrderViewController alloc] init];
    uvc.Pub_dic = self.Pub_dic;
    [self.navigationController pushViewController:uvc animated:YES];
}

- (void)doClaim:(id)sender
{
    NSString *isout = [NSString stringWithFormat:@"%@",[Pub_dic valueForKey:@"isout"]];
    if ([isout isEqualToString:@"1"]) {
        //mbat
    } else {
        OLGhostAlertView *alertView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
        alertView.position = OLGhostAlertViewPositionCenter;
        alertView.message = @"自购买之日起，满一年才可申请赔付哦！";
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end