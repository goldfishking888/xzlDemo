//
//  MajorDetailViewController.m
//  JobKnow
//
//  Created by liuxiaowu on 13-9-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "MajorDetailViewController.h"

@interface MajorDetailViewController ()

@end

@implementation MajorDetailViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"教育信息"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"教育信息"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [self addBackBtn];
    
    [self addTitleLabel:@"选择专业"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *majorDic = [_majorArray objectAtIndex:0];
    return [majorDic valueForKey:@"name"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_majorArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *majorDic = [_majorArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.textLabel.text = [majorDic valueForKey:@"name"];
       cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,cell.frame.size.height-2, 320, 1)];
    nameLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [cell addSubview:nameLabel];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *majorDic = [_majorArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"u_name" object:self userInfo:majorDic];
    NSArray *vcs = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count - 3] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
