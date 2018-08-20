//
//  GuanfzhViewController.m
//  JobKnow
//
//  Created by Zuo on 14-2-11.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "GuanfzhViewController.h"
#import "MyTableCell.h"
#import "WebViewController.h"
@interface GuanfzhViewController ()

@end

@implementation GuanfzhViewController

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

    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height-44) style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource =self;
    mytableView.backgroundView = nil;
    [self.view addSubview:mytableView];
    [self addBackBtn];
    [self addTitleLabel:@"小职了官方账号"];
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
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray1 = [NSArray arrayWithObjects:@"QQ群:314385998",@"微信公共账号:小职了(xzhiliao1998)",@"新浪微博:小职了",@"腾讯微博:小职了",nil];
    NSArray *imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"share_qq.png"],[UIImage imageNamed:@"share_wechat.png"],[UIImage imageNamed:@"share_sina.png"],[UIImage imageNamed:@"share_tencentweibo.png"],nil];
    static NSString *identifier = @"Cell";
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{}
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labname.frame =CGRectMake(40, 10, 290, 20);
    cell.labname.text = [titleArray1 objectAtIndex:indexPath.row];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView.layer setCornerRadius:8.0f];
    [imgView.layer setMasksToBounds:YES];
    [imgView setImage: [imageArray objectAtIndex:[indexPath row]] ];
    [cell.contentView addSubview:imgView];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"314385998";
        OLGhostAlertView *olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
        olalterView.position = OLGhostAlertViewPositionCenter;
        olalterView.message =@"QQ群号码已复制到剪贴板，请打开QQ添加";
        [olalterView show];
    }else if (indexPath.section==0&&indexPath.row==1){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"小职了(xzhiliao1998)";
        OLGhostAlertView *olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:2 dismissible:YES];
        olalterView.position = OLGhostAlertViewPositionCenter;
        olalterView.message =@"微信公共帐号已复制到剪贴板，请打开QQ添加";
        [olalterView show];
    }else if (indexPath.section==0&&indexPath.row==2){
        WebViewController *web = [[WebViewController alloc]init];
        web.urlStr = @"http://weibo.cn/xiaozhiliao2012";
        web.floog = @"新浪微博";
        [self.navigationController pushViewController:web animated:YES];
    }else if (indexPath.section==0&&indexPath.row==3){
        WebViewController *web = [[WebViewController alloc]init];
        web.urlStr = @"http://t.qq.com/xiaozhiliao20122010";
        web.floog = @"腾讯微博";
        [self.navigationController pushViewController:web animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
