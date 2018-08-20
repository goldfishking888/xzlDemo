//
//  MajorViewController.m
//  JobKnow
//
//  Created by liuxiaowu on 13-9-17.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "MajorViewController.h"
#import "MajorDetailViewController.h"

@interface MajorViewController ()

@end

@implementation MajorViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择专业"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择专业"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *majorString = [[NSBundle mainBundle] pathForResource:@"major" ofType:@"plist"];
    
    _majorArray = [NSArray arrayWithContentsOfFile:majorString];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    sections = [NSArray arrayWithObjects:@"1",@"1",@"4",@"11",@"9",@"1",@"5",@"5",@"1",@"2",@"1", nil];
    heads = [NSArray arrayWithObjects:@"哲学类",@"经济学",@"管理学",@"文学",@"工学",@"法学",@"历史类",@"理学",@"教育类",@"医学",@"农学", nil];
    
    [self addBackBtn];
    [self addTitleLabel:@"选择专业"];
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 11;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sections objectAtIndex:section] integerValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [heads objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
      cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSLog(@"section----------------%d",indexPath.section);
    NSDictionary *majorDic = [_majorArray objectAtIndex:[self arrayIndex:indexPath.section now:indexPath.row]];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    cell.textLabel.text = [majorDic valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MajorDetailViewController *majorDetailVC = [[MajorDetailViewController alloc] init];
    majorDetailVC.majorArray = [[_majorArray objectAtIndex:[self arrayIndex:indexPath.section now:indexPath.row]] valueForKey:@"son"];
    [self.navigationController pushViewController:majorDetailVC animated:YES];
}


- (NSInteger)arrayIndex:(NSInteger)index now:(NSInteger)now
{
    NSInteger num = 0;
    for (NSInteger i = 0; i<index; i++) {
        NSString *count = [sections objectAtIndex:i];
        num = num + [count integerValue];
    }
    
    return num + now;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
