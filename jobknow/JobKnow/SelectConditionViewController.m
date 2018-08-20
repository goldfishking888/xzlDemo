//
//  SelectConditionViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "SelectConditionViewController.h"
#import "jobRead.h"
@interface SelectConditionViewController ()

@end

@implementation SelectConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"此处执行到了。。。。。。");
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位筛选"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位筛选"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    [self addTitleLabel:@"筛选"];
    
    num=ios7jj;
    
    _dataArray = [NSArray arrayWithObjects:@"发布时间",@"工作经验",@"学历",@"待遇",@"职位类型",@"公司性质", nil];
    
    mySrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    
    mySrollView.contentSize = CGSizeMake(iPhone_width, iPhone_height-44-num);
    
    //创建tableView
    if (IOS7) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,300) style:UITableViewStyleGrouped];
    }else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,300) style:UITableViewStylePlain];
        
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    
    _tableView.backgroundView = nil;
    _tableView.bounces=NO;
    _tableView.backgroundColor = [ UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [mySrollView addSubview:_tableView];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10,280,300,40);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlEventTouchUpInside];
    
    [sureBtn addTarget:self action:@selector(finishSelect:) forControlEvents:UIControlEventTouchUpInside];
    [mySrollView addSubview:sureBtn];
    [self.view addSubview:mySrollView];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        NSArray *views = [cell.contentView subviews];
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    SaveJob *save=[SaveJob standardDefault];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *vLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, iPhone_width - 150, 44)];
    vLabel.backgroundColor = [UIColor clearColor];
    vLabel.font = [UIFont systemFontOfSize:14];
    vLabel.textAlignment = NSTextAlignmentRight;
    vLabel.backgroundColor = [UIColor clearColor];
    jobRead *read = [save.choiceArr objectAtIndex:indexPath.row];
    vLabel.text = read.name;
    vLabel.textColor = [UIColor grayColor];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.font = [UIFont fontWithName:Zhiti size:15];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.text = [_dataArray objectAtIndex:indexPath.row];
    typeLabel.textColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:vLabel];
    [cell.contentView addSubview:typeLabel];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,44,iPhone_width,1)];
    label1.backgroundColor=[UIColor colorWithWhite:0.9 alpha:1];
    [cell.contentView addSubview:label1];
    
    if (IOS7) {
        
    }else
    {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConditionDetailViewController *conditionVC = [[ConditionDetailViewController alloc]init];
    
    conditionVC.delegate = self;
    
    index = indexPath.row;
    
    switch (indexPath.row) {
        case 0:
            conditionVC.selectOption = SelectPublishDate;
            break;
        case 1:
            conditionVC.selectOption = SelectJobYear;
            break;
        case 2:
            conditionVC.selectOption = SelectEducation;
            break;
        case 3:
            conditionVC.selectOption = SelectMonthSalary;
            break;
        case 4:
            conditionVC.selectOption = SelectJobType;
            break;
        case 5:
            conditionVC.selectOption = SelectCompanyType;
            break;
    }
    
    [self.navigationController pushViewController:conditionVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    return 0;
}

#pragma mark ConditionDetailView代理方法的实现
- (void)selectValueToUp:(jobRead *)select
{
    SaveJob *save=[SaveJob standardDefault];
    [save.choiceArr replaceObjectAtIndex:index withObject:select];
    [self.tableView reloadData];
}

- (void)finishSelect:(id)sender
{
    [self.delegate finishSelect];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
