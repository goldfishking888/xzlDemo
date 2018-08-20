//
//  PositionRecommandViewController.m
//  FreeChat
//
//  Created by WangJinyu on 7/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "PositionRecommandViewController.h"
#import "PositionRecommandCell.h"
#import "RecommendProcessViewController.h"

@interface PositionRecommandViewController ()
{
    UITableView *mainTableView;
}

@end

@implementation PositionRecommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    [self addBackBtn];
    [self addCenterTitle:self.comNameStr];
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;

    
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + (ios7jj), self.view.frame.size.width, self.view.frame.size.height - (44 + (ios7jj)))];
    mainTableView.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    mainTableView.dataSource = self;
    mainTableView.delegate = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTableView];
}

#pragma mark tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    PositionRecommandCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[PositionRecommandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataDic = self.dataDic[@"jobResumeList"][indexPath.row];
    if (indexPath.row == [self.dataDic[@"recommendPersons"] integerValue] - 1)
    {
        cell.isDownLine = @"0";
    }
    else
    {
        cell.isDownLine = @"1";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataDic[@"recommendPersons"] integerValue];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
    bgView.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255. blue:243 / 255.0 alpha:1];
    
    UIView *bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 48)];
    bgView1.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:bgView1];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(13, 19, 10, 10)];
    icon.image = [UIImage imageNamed:@"hrcircle_resume_recomm_pos.png"];
    [bgView1 addSubview:icon];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(18, 29, 1, 26)];
    line.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:225 / 255.0 blue:225 / 255.0 alpha:1];
    [bgView addSubview:line];
    
    UILabel *posLabel = [[UILabel alloc] initWithFrame:CGRectMake(33, 0, 150, 48)];
    posLabel.text = self.dataDic[@"jobName"];
    posLabel.font = [UIFont systemFontOfSize:12];
    posLabel.textColor = [UIColor colorWithRed:92 / 255.0 green:92 / 255.0 blue:92 / 255.0 alpha:1];
    [bgView1 addSubview:posLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 95, 48)];
    priceLabel.text = [NSString stringWithFormat:@"￥%@", self.dataDic[@"jobMoney"]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:12];
    priceLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:146 / 255.0 blue:4 / 255.0 alpha:1];
    [bgView1 addSubview:priceLabel];
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendProcessViewController *recommendProcessVc = [[RecommendProcessViewController alloc] init];
    recommendProcessVc.uidStr = [NSString stringWithFormat:@"%@",self.dataDic[@"jobResumeList"][indexPath.row][@"resumeUid"]];
    recommendProcessVc.companyIdStr = [NSString stringWithFormat:@"%@", self.dataDic[@"companyId"]];
    recommendProcessVc.jobIdStr = [NSString stringWithFormat:@"%@", self.dataDic[@"jobId"]];
    [self.navigationController pushViewController:recommendProcessVc animated:YES];
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
