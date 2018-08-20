//
//  jiben2ViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-16.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "jiben2ViewController.h"

@interface jiben2ViewController ()

@end

@implementation jiben2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        myAry = [NSArray array];
        myAryCode = [NSArray array];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.myType isEqualToString:@"zhuangtai"]) {
        
         [[BaiduMobStat defaultStat] pageviewStartWithName:@"求职状态"];
 
    }else if ([self.myType isEqualToString:@"yuexin"]) {
      
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"期望月薪"];
        
    }else if ([self.myType isEqualToString:@"hunyu"]) {
     
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"婚育情况"];
        
    }else if ([self.myType isEqualToString:@"gzlx"]){
     
         [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作类型"];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    if ([self.myType isEqualToString:@"zhuangtai"]) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"求职状态"];
        
    }else if ([self.myType isEqualToString:@"yuexin"]) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"期望月薪"];
        
    }else if ([self.myType isEqualToString:@"hunyu"]) {
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"婚育情况"];
        
    }else if ([self.myType isEqualToString:@"gzlx"]){
        
        [[BaiduMobStat defaultStat] pageviewStartWithName:@"工作类型"];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = XZHILBJ_colour;
   
    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, iPhone_width, iPhone_height-46)];
    myTabView.delegate =self;
    myTabView.dataSource =self;
    myTabView.backgroundView = nil;
    myTabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTabView];
    [self addBackBtn];
    if ([self.myType isEqualToString:@"zhuangtai"]) {
        [self addTitleLabel:@"求职状态"];
        myAry = [NSArray arrayWithObjects:@"紧急,一个月内",@"一般，三个月内",@"拟求职，三个月以上",@"观望好的机会可以考虑",@"行业了解中暂不考虑换工作",nil];
        myAryCode = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    }else if ([self.myType isEqualToString:@"yuexin"]) {
        [self addTitleLabel:@"期望月薪"];
        myAry = [NSArray arrayWithObjects:@"面议",@"1000以下",@"1000-1199",@"1200-1499",@"1500-1799",@"1800-1999",@"2000-2499",@"2500-2999",@"3000-3499",@"3500-3999",@"4000-4499",@"4500-4999",@"5000-5999",@"6000-6999",@"7000-7999",@"8000-8999",@"9000-9999",@"10000-11999",@"12000-14999",@"15000-19999",@"20000-24999",@"25000-29999",@"30000-39999",@"40000-49999",@"50000-79999",@"80000-99999",@"100000以上",nil];
        myAryCode= [[NSArray alloc]initWithObjects:@"10",@"99",@"101",@"121",@"151",@"181",@"201",@"251",@"301",@"351",@"401",@"451",@"501",@"601",@"701",@"801",@"901",@"1001",@"1201",@"1501",@"2001",@"2501",@"3001",@"4001",@"5001",@"8001",@"10001",nil];
        
        
    }else if ([self.myType isEqualToString:@"hunyu"]) {
        [self addTitleLabel:@"婚育情况"];
        myAry = [NSArray arrayWithObjects:@"保密",@"未婚",@"已婚",@"离异",@"已婚已育", nil];
       myAryCode = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",nil];
    }else if ([self.myType isEqualToString:@"gzlx"]){
        [self addTitleLabel:@"工作类型"];
        myAry = [NSArray arrayWithObjects:@"不限",@"全职",@"兼职",@"实习",@"全兼皆可",nil];
        myAryCode = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4", nil];
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
    return 50;
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
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.textLabel.text = [myAry objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor =[UIColor darkGrayColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [myAryCode objectAtIndex:indexPath.row];
    [self.deleat chuanzhi:str ty:self.myType];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
