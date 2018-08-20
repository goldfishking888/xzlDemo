//
//  SalaryQueryViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-20.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "SalaryQueryViewController.h"

@interface SalaryQueryViewController ()

@end

@implementation SalaryQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44)];
    [self.view addSubview:_scrollView];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, iPhone_width, iPhone_height - 144) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_scrollView addSubview:_tableView];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, iPhone_width - 20, 30)];
    showLabel.font = [UIFont systemFontOfSize:15];
    showLabel.backgroundColor = [UIColor clearColor];
    showLabel.text = @"小职了提供“相同薪酬结构”上的精准查询。";
    [_scrollView addSubview:showLabel];
    
    UILabel *showLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, iPhone_width - 20, 30)];
    showLabel2.backgroundColor = [UIColor clearColor];
    showLabel2.text = @"请提交您的薪酬后将为您自动匹配查询。";
    showLabel2.font = [UIFont systemFontOfSize:15];
    [_scrollView addSubview:showLabel2];
    
    UILabel *showLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, iPhone_width - 20, 30)];
    showLabel3.backgroundColor = [UIColor clearColor];
    showLabel3.font = [UIFont systemFontOfSize:15];
    showLabel3.text = @"除说明外，均为必填项";
    [_scrollView addSubview:showLabel3];
    
    //添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn addTarget:self action:@selector(backUpPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)backUpPage:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
