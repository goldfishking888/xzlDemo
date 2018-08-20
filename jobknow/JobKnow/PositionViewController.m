//
//  PositionViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "PositionViewController.h"
#import "jobRead.h"
@interface PositionViewController ()

@end

@implementation PositionViewController

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
    
    dataArray=[[NSMutableArray alloc]init];
    
    [dataArray  addObjectsFromArray:[jobRead findAllWith:@"workList"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"行业分类"];
    
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
    return [dataArray count]-1;
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
    
    jobRead *read=[dataArray objectAtIndex:indexPath.row+1];
    
    cell.textLabel.numberOfLines = 2;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    cell.textLabel.text = read.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    jobRead *read=[dataArray objectAtIndex:indexPath.row+1];
    
    if ([self.delegate respondsToSelector:@selector(changePosition:)]) {
        
        [self.delegate changePosition:read.name];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
