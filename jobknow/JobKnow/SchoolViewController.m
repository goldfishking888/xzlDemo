//
//  SchoolViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-6-20.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "SchoolViewController.h"

@interface SchoolViewController ()

@end

@implementation SchoolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择学校"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择学校"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return [_univercityArray count];
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

    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 44)];
    name.tag = 11;
    [name setBackgroundColor:[UIColor clearColor]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [name setFont:[UIFont boldSystemFontOfSize:14]];
    name.text = [_univercityArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:name];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [_univercityArray objectAtIndex:indexPath.row];
    NSArray *controllers = [self.navigationController viewControllers];
    UIViewController *VC = [controllers objectAtIndex:controllers.count - 3];
    [self.navigationController popToViewController:VC animated:YES];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:name,@"uname", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"u_name" object:self userInfo:dic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
