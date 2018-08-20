//
//  SeniorJobFilterViewController.m
//  JobKnow
//
//  Created by Suny on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "SeniorJobFilterViewController.h"
#import "jobRead.h"
@interface SeniorJobFilterViewController ()

@end

@implementation SeniorJobFilterViewController

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
    
    SaveJob *save=[SaveJob standardDefault];
    [save clearTheCache];
    
    num=ios7jj;
    
    isHangYeEmpty = YES;
    isZhiWeiEmpty = YES;
    
    _dataArray = [NSArray arrayWithObjects:@"职业",@"排序方式",@"工作经验",@"学历", nil];//@"行业",@"公司性质",
    
    mySrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    
    mySrollView.contentSize = CGSizeMake(iPhone_width, iPhone_height-44-num);
    
    //创建tableView
    if (IOS7) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,300) style:UITableViewStyleGrouped];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    
    UILabel *vLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, iPhone_width - 130, 44)];
    vLabel.backgroundColor = [UIColor clearColor];
    vLabel.font = [UIFont systemFontOfSize:14];
    vLabel.textAlignment = NSTextAlignmentRight;
    vLabel.backgroundColor = [UIColor clearColor];
    if (!save.seniorChoiceArr.count>0) {
        [save seniorChoiceArrInit];
    }
    jobRead *read = [save.seniorChoiceArr objectAtIndex:indexPath.row];
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
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0,43,iPhone_width,1)];
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
    
    SeniorConditionDetailViewController *conditionVC = [[SeniorConditionDetailViewController alloc]init];
    
    conditionVC.delegate = self;
    
    index = indexPath.row;
    
    switch (indexPath.row) {
//        case 0:
//            {
//                PositionsViewController *positionVC = [[PositionsViewController alloc]init];
//                positionVC.delegate=self;
//                positionVC.isEmpty = isHangYeEmpty;
//                [self.navigationController pushViewController:positionVC animated:YES];
//                return;
//            }
//            
//            break;
        case 0:
            {
                WorkDetailViewController *workVC = [[WorkDetailViewController alloc]init];
                workVC.delegate=self;
                workVC.isEmpty = isZhiWeiEmpty;
                [self.navigationController pushViewController:workVC animated:YES];
                return;
            }
            break;
        case 1:
            conditionVC.selectOption = SeniorSelectPaiLieFangshi;
            break;
        case 2:
            conditionVC.selectOption = SeniorSelectWorkExp;
            break;
        case 3:
            conditionVC.selectOption = SeniorSelectEduExp;
            break;
//        case 5:
//            conditionVC.selectOption = SeniorSelectCompanyType;
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

#pragma mark- SeniorConditionDelegate代理方法的实现
- (void)selectValueToUp:(jobRead *)select
{
    SaveJob *save=[SaveJob standardDefault];
    [save.seniorChoiceArr replaceObjectAtIndex:index withObject:select];
    [self.tableView reloadData];
}

#pragma mark- positonViewDelegate代理方法的实现
- (void)positonViewChange{
    
    SaveJob *save=[SaveJob standardDefault];
    jobRead *read=[[jobRead alloc]init];
    read.name = [save industry];
    read.code = [save industryCode];
    [save.seniorChoiceArr replaceObjectAtIndex:0 withObject:read];
    [self.tableView reloadData];
}

#pragma mark- workDetailDelegate代理方法的实现
- (void)workDetailChange{
    
    SaveJob *save=[SaveJob standardDefault];
    jobRead *read=[[jobRead alloc]init];
    read.name = [save jobStr];
    read.code = [save jobCodeStr];
    [save.seniorChoiceArr replaceObjectAtIndex:1 withObject:read];
    [self.tableView reloadData];
}

#pragma mark- JobNameViewDelegate代理方法的实现
- (void)JobNameViewChange{
    SaveJob *save=[SaveJob standardDefault];
    jobRead *read=[[jobRead alloc]init];
    read.name = [save jobStr];
    read.code = [save jobCodeStr];
    [save.seniorChoiceArr replaceObjectAtIndex:1 withObject:read];
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
