//
//  SeniorJobRightViewController.m
//  JobKnow
//
//  Created by Suny on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "SeniorJobRightViewController.h"
#import "JumpWebViewController.h"
#import "MyBounsListViewController.h"
#import "ApplyEntryBounsViewController.h"
#import "MyBonusApplyViewController.h"


#define RightTableWith (320-60)
#define RightTableCellIconHeight 25

@interface SeniorJobRightViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSArray *_iconArray;
}

@end

@implementation SeniorJobRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, RightTableWith, self.view.frame.size.height)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView setBackgroundColor:XZHILBJ_colour];
    [self.view addSubview:_tableView];
    
    _titleArray = @[@"申请入职奖金",@"我的奖金申请",@"关于入职奖金",@"我的入职奖金"];
    _iconArray = @[@"apply_bonus",@"check_bonus",@"about_bonus",@"my_bonus"];
  
}

#pragma mark - 入职奖金图片的点击方法
- (void)tapOnHeaderView{
    //关闭rightView
    [_drawer close];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [headerView setBackgroundColor:XZHILBJ_colour];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (150-60)/2, 320-60, 60)];
    [imgView setImage:[UIImage imageNamed:@"bonus_slidingmenu"]];
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [headerView addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.frame.origin.y+imgView.frame.size.height, 320-60, 40)];
    [label setText:@"入职奖金"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor grayColor]];
    [headerView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 150, headerView.frame.size.width, 0.5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [headerView addSubview:line];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnHeaderView)];
    [headerView addGestureRecognizer:tapGesture];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, (66-RightTableCellIconHeight)/2, RightTableCellIconHeight, RightTableCellIconHeight)];
    [imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",_iconArray[indexPath.row]]]];
    [cell addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50+RightTableCellIconHeight+10, (66-20)/2, 120, 20)];
    [label setText:[NSString stringWithFormat:@"%@",_titleArray[indexPath.row]]];
    [label setTextColor:[UIColor grayColor]];
    [cell addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 65, cell.frame.size.width, 0.5)];
    [line setBackgroundColor:[UIColor lightGrayColor]];
    [cell addSubview:line];
    
    cell.backgroundColor = XZHILBJ_colour;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
}
- (BOOL)judgmentLogin
{
    
    BOOL isLogin = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginNew"]] isEqualToString:@"0"];
    if( kUserTokenStr!= nil && ![kUserTokenStr isEqual: @""] && isLogin)    return YES;
    
    else return NO;
    //    NSUserDefaults *AppUD = [NSUserDefaults standardUserDefaults];
    //    NSString *pwd = [AppUD valueForKey:@"passWord"];
    //    if(pwd.length>0)
    //    {
    //        return YES;
    //    }else
    //    {
    //        return NO;
    //    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
