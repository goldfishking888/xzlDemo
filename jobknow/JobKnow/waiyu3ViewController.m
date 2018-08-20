//
//  waiyu3ViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "waiyu3ViewController.h"

@interface waiyu3ViewController ()

@end

@implementation waiyu3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom  
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"外语能力3"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"外语能力3"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor =XZHILBJ_colour;
    [self addBackBtn];
    int num=ios7jj;
    if ([self.type isEqualToString:@"jibie"]) {
        [self addTitleLabel:@"外语水平"];
    }else{
        [self addTitleLabel:@"外语语种"];
    }  
    myTabView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46+num, iPhone_width, iPhone_height-46-num)];
    myTabView.delegate = self;
    myTabView.dataSource =self;
    myTabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTabView];
    
    yuzhAry = [[NSMutableArray alloc]initWithObjects:@"英语",@"日语",@"法语",@"俄语",@"西班牙语",@"韩语",@"阿拉伯语",@"葡萄牙语",@"意大利语", nil];
    jibeAry = [[NSMutableArray alloc]initWithObjects:@"一般",@"良好",@"熟练",@"精通", nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"jibie"]) {
        return [jibeAry count];
    }else{
         return [yuzhAry count];
    }
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
        cell.accessoryView = nil;
    }
    cell.selectionStyle=UITableViewCellSeparatorStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    if ([self.type isEqualToString:@"jibie"]) {
        cell.textLabel.text = [jibeAry objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [yuzhAry objectAtIndex:indexPath.row];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToString:@"jibie"]) {
        NSString *str01 = [jibeAry objectAtIndex:indexPath.row];
        [self.delaet chuanzhi:str01 myType:@"jibie"];
    }else{
        NSString *str02 = [yuzhAry objectAtIndex:indexPath.row];
        [self.delaet chuanzhi:str02 myType:@"yuzh"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
