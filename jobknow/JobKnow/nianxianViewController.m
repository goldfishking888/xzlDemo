//
//  nianxianViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "nianxianViewController.h"

@interface nianxianViewController ()

@end

@implementation nianxianViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作年限"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"工作年限"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    num=ios7jj;
    
    [self addBackBtn];
    
    [self addTitleLabel:@"工作年限"];
    
    if (IOS7) {
      
        myTabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
        
    }else
    {
        myTabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStylePlain];
    }
    
    myTabView.delegate = self;
    myTabView.dataSource =self;
    [self.view addSubview:myTabView];
    myAry = [[NSMutableArray alloc]init];
//    [myAry addObject:@"不限"];
    [myAry insertObject:@"在读学生" atIndex:0];
    [myAry insertObject:@"应届毕业生" atIndex:1];
    for (int i=1; i<61; i++) {
        NSString *str = [NSString stringWithFormat:@"%d年",i];
        [myAry addObject:str];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:520];
        [labeill removeFromSuperview];
        cell.accessoryView = nil;
    }
    cell.selectionStyle = UITableViewScrollPositionNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [myAry objectAtIndex:indexPath.row];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [myAry objectAtIndex:indexPath.row];
    NSString *nx=nil;
    if ([str isEqualToString:@"不限"]) {
            nx= [NSString stringWithFormat:@"%d",-2];
    }else if ([str isEqualToString:@"在读学生"]){
            nx= [NSString stringWithFormat:@"%d",-1];
    }else if ([str isEqualToString:@"应届毕业生"]){
            nx= [NSString stringWithFormat:@"%d",0];
    }else{
            nx = [str substringToIndex:str.length-1];
    }
    [self.deleat chuanzhi:nx];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
