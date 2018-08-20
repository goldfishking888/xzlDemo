//
//  UnivercityNameViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "UnivercityNameViewController.h"

@interface UnivercityNameViewController ()

@end

@implementation UnivercityNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.school = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"选择学校"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"选择学校"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = XZHILBJ_colour;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44-20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.backgroundColor = XZHILBJ_colour;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self addBackBtn];
    [self addTitleLabel:@"学校名称"];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.school count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [self.school objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [self.school objectAtIndex:indexPath.row];
    [self.nameDelegate selectUnivercityName:name];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
