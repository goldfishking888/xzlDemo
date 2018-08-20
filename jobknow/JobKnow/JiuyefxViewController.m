//
//  JiuyefxViewController.m
//  JobKnow
//
//  Created by Zuo on 14-3-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "JiuyefxViewController.h"
#import "MyTableCell.h"
#import "StudentViewController.h"
#import "PracticeViewController.h"
@interface JiuyefxViewController ()

@end

@implementation JiuyefxViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"就业分析"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"就业分析"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height-44) style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource =self;
    mytableView.backgroundView = nil;
    [self.view addSubview:mytableView];
    [self addBackBtn];
    [self addTitleLabel:@"就业分析"];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray1 = [NSArray arrayWithObjects:@"学生基本信息",@" 实习情况",nil];
    static NSString *identifier = @"Cell";
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labname.frame =CGRectMake(15, 10, 290, 20);
    cell.labname.text = [titleArray1 objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        StudentViewController *student = [[StudentViewController alloc]init];
        [self.navigationController pushViewController:student animated:YES];
    }else if (indexPath.section==0&&indexPath.row==1){
        PracticeViewController *practice = [[PracticeViewController alloc]init];
        [self.navigationController pushViewController:practice animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
