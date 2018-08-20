//
//  PersonalViewController.m
//  JobKnow
//
//  Created by Zuo on 14-3-25.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "PersonalViewController.h"
#import "MyTableCell.h"
#import "collectViewController.h"
#import "PassWordViewController.h"
#import "StudentViewController.h"
@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"个人中心"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"个人中心"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height-44) style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource =self;
    mytableView.backgroundView = nil;
    [self.view addSubview:mytableView];
    [self addBackBtn];
    [self addTitleLabel:@"个人中心"];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray1 = [NSArray arrayWithObjects:@"基本信息",@"就业分析",@"密码修改",@"职位收藏",nil];
    static NSString *identifier = @"Cell";
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labname.frame =CGRectMake(15, 10, 290, 20);
    cell.labname.text = [titleArray1 objectAtIndex:indexPath.row];
    
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0&&indexPath.row==0) {
        InfoPerfectViewController *infoVC = [[InfoPerfectViewController alloc] init];
        infoVC.deleate = self;
        infoVC.myType = [NSString stringWithFormat:@"mima"];
        [self.navigationController pushViewController:infoVC animated:YES];
    }else if (indexPath.section==0&&indexPath.row==1){


        StudentViewController *student = [[StudentViewController alloc]init];
        [self.navigationController pushViewController:student animated:YES];
    }else if (indexPath.section==0&&indexPath.row==2){
        
        NSLog(@"密码修改");
        
        PassWordViewController *pass = [[PassWordViewController alloc]init];
        pass.myType = [NSString stringWithFormat:@"1"];
        [self.navigationController pushViewController:pass animated:YES];
        
        
        
        
    }else if (indexPath.section==0&&indexPath.row==3){
        collectViewController *collectVC=[[collectViewController alloc]init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)changeColur1
{
    NSLog(@"走代理");
    //    olghost.message = @"信息添加成功";
    //    olghost.position = OLGhostAlertViewPositionCenter;
    //    [olghost show];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
