//
//  ProvinceViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-6-20.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ProvinceViewController.h"
#import "SchoolViewController.h"

@interface ProvinceViewController ()

@end

@implementation ProvinceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"根据省份选择学校"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"根据省份选择学校"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"univercity" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    _provinceArray = [dic allKeys];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44-20)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self addBackBtn];
    [self addTitleLabel:@"选择学校"];
	
}
- (void)backHomeVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_provinceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *la = (UILabel *)[cell.contentView viewWithTag:11];
        [la removeFromSuperview];
    }
       cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 44)];
    name.tag = 11;
    [name setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [name setFont:[UIFont boldSystemFontOfSize:14]];
    name.text = [_provinceArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:name];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_provinceArray objectAtIndex:indexPath.row];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"univercity" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SchoolViewController *schoolVC = [[SchoolViewController alloc] init];
    schoolVC.univercityArray = [dic valueForKey:key];
    [self.navigationController pushViewController:schoolVC animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
