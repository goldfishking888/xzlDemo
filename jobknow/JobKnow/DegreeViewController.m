//
//  DegreeViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-29.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "DegreeViewController.h"

@interface DegreeViewController ()

@end

@implementation DegreeViewController

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
    
    _showArray = [NSArray arrayWithObjects:@"初中以上",@"高中以上",@"中技以上",@"中专以上",@"大专以上",@"本科以上",@"硕士以上",@"博士以上",@"其他",nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"学历"];
    
    [self initData];
    
    if (IOS7) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStyleGrouped];
    }else
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num) style:UITableViewStylePlain];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}

#pragma mark UITableView  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_showArray count];
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
    static NSString *indenifier=@"cellIndenifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indenifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenifier];
    }
    
    cell.textLabel.text=[_showArray objectAtIndex:indexPath.row];
    
    cell.textLabel.font=[UIFont systemFontOfSize:14.0f];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(changeDegree:)]) {
        
        [self.delegate changeDegree:[_showArray objectAtIndex:indexPath.row]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end