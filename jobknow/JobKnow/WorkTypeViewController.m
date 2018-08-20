//
//  WorkTypeViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "WorkTypeViewController.h"

#import "WorkDetailTypeViewController.h"

@interface WorkTypeViewController ()

@end

@implementation WorkTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData
{
    num=ios7jj;
    
    NSString *jobListPath = [[NSBundle mainBundle] pathForResource:@"jobList" ofType:@"plist"];
    
    NSString *jobPath = [[NSBundle mainBundle] pathForResource:@"job" ofType:@"plist"];
    
    /**根据工程路径中存放的数据创建两个字典**/
    NSMutableDictionary *jobListDic = [NSMutableDictionary dictionaryWithContentsOfFile:jobListPath];
    
    NSMutableDictionary *jobDic = [NSMutableDictionary dictionaryWithContentsOfFile:jobPath];
    
    NSArray *jobListArray = [jobListDic valueForKey:@"jobList"];
    
    NSArray *jobArray =  [jobDic valueForKey:@"job"];
    
    firstLiveArray = [NSMutableArray arrayWithArray:jobListArray];

    dataArray = [NSMutableArray arrayWithArray:jobArray];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"职业类别"];
    
    [self initData];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
}

#pragma mark TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [firstLiveArray count]-1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [firstLiveArray objectAtIndex:indexPath.row+1];
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    firstLiveStr = [firstLiveArray objectAtIndex:indexPath.row+1];
    
    detailJobArray = [dataArray objectAtIndex:indexPath.row+1];
    
    WorkDetailTypeViewController *workVC=[[WorkDetailTypeViewController alloc]init];
    
    workVC.jobItem=firstLiveStr;
    
    workVC.dataArray=detailJobArray;
    
    NSArray *view=self.navigationController.viewControllers;

    NSInteger count=[view count];
    
    workVC.delegate=[view objectAtIndex:count-2];

    [self.navigationController pushViewController:workVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end