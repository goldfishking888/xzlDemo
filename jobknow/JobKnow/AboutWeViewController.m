//
//  AboutWeViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "AboutWeViewController.h"
#import "LookIntroduceViewController.h"
#import "LookStartViewController.h"
#import "WebViewController.h"
#import "SampleViewController.h"
#import "FeedbackVC.h"
#import "MyTableCell.h"
#import "ProtocolViewController.h"
#import "GuanfzhViewController.h"
@interface AboutWeViewController ()

@end

@implementation AboutWeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        infoImg = [UIImage imageNamed:@"1234567.png"];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"关于我们"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"关于我们"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, iPhone_height)];
    scrollView.backgroundColor = RGBA(236, 236, 236, 1);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:infoImg];
    imageView.frame = CGRectMake(0, 0, 320, 732);
    
    for (int i = 0 ; i<7; i++) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(5, 732+i*48, 310, 48);
        NSArray *ary = [[NSArray alloc]initWithObjects:@"about1.png",@"about2.png",@"about3.png",@"about4.png",@"about7.png",@"about5.png",@"about6.png", nil];
        NSMutableArray *muAry = [NSMutableArray arrayWithObjects:@"软件版本 V1.7.1",@"查看介绍页",@"查看起始页",@"用户协议",@"意见反馈",@"   www.xzhiliao.com",@"0532-80901998", nil];
        NSString *image = [ary objectAtIndex:i];
        NSString *title = [muAry objectAtIndex:i];
        button.tag = i+1001;
        button.highlighted = NO;
        [button setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateNormal)];
        [button setBackgroundImage:[UIImage imageNamed:image] forState:(UIControlStateHighlighted)];
        [button setTitle:title forState:(UIControlStateNormal)];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button addTarget:self action:@selector(comeback:) forControlEvents:UIControlEventTouchUpInside];
//        [scrollView addSubview:button];
    }
    
    newSize = CGSizeMake(320, 732+44+48*7);
    scrollView.delegate = self;
   [scrollView setContentSize:newSize];
   
    
    mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44) style:UITableViewStyleGrouped];
    mytableView.delegate = self;
    mytableView.dataSource =self;
    mytableView.backgroundView = nil;
    [self.view addSubview:mytableView];
    [self addBackBtn];
    [self addTitleLabel:@"关于我们"];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( section == 0)
    return 3;
    else
        return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==1) {
        return 25;
    }
     return 0.5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArray1 = [NSArray arrayWithObjects:@"功能介绍",@"查看起始页",@"用户协议",nil];
    NSArray *img1 = [NSArray arrayWithObjects:@"about_pic1.png",@"about_pic3.png",@"about_pic4.png", nil];
    NSArray *titleArray2 = [NSArray arrayWithObjects:@"客服电话:0532-80901998",nil];
    NSArray *img2 = [NSArray arrayWithObjects:@"about_pic9.png", nil];
    static NSString *identifier = @"Cell";
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{}
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labname.frame =CGRectMake(50, cell.frame.size.height/2-10, 290, 20);
    if (indexPath.section==0) {
        cell.labname.text = [titleArray1 objectAtIndex:indexPath.row];
        cell.imagview.image = [UIImage imageNamed:[img1 objectAtIndex:indexPath.row]];
    }else{
        cell.labname.text = [titleArray2 objectAtIndex:indexPath.row];
        cell.imagview.image = [UIImage imageNamed:[img2 objectAtIndex:indexPath.row]];
    
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        UIView *cview = [[UIView alloc]initWithFrame:CGRectMake(0,0, tableView.bounds.size.width,120)];
        cview.backgroundColor = XZHILBJ_colour;
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(125, 10, 70, 70);
        [button2 setBackgroundImage:[UIImage imageNamed:@"icon"] forState:UIControlStateNormal];
        [cview addSubview:button2];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, 320, 25)];
        label2.textAlignment = NSTextAlignmentCenter;
        NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
        label2.text = [NSString stringWithFormat:@"小职了 %@",[appInfo objectForKey:@"CFBundleShortVersionString"]];
        label2.backgroundColor = [UIColor clearColor];
        label2.font = [UIFont boldSystemFontOfSize:15];
        [cview addSubview:label2];
        return cview;
    }return nil;
}
//表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 120;
    }return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)//功能介绍
    {    
        WebViewController *web = [[WebViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"about"];
        web.urlStr = strUrl;
        web.floog = @"功能介绍";
        [self.navigationController pushViewController:web animated:YES];
    }
//    else if( indexPath.section == 0&& indexPath.row == 1)//介绍页
//    {
//        LookIntroduceViewController *look = [[LookIntroduceViewController alloc]init];
//         [self.navigationController pushViewController:look animated:YES];
//    }
    else if (indexPath.section == 0&& indexPath.row == 1)//起始页
    {
         LookStartViewController *start = [[LookStartViewController alloc]init];
         [self.navigationController pushViewController:start animated:YES];      
    }else if (indexPath.section == 0&& indexPath.row ==2)//协议
    {
        ProtocolViewController *protol = [[ProtocolViewController alloc]init];
        [self.navigationController pushViewController:protol animated:YES];
    }
    else if (indexPath.section == 1&& indexPath.row ==999990)//荣誉
    {
        WebViewController *web = [[WebViewController alloc]init];
        NSString *strUrl = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,@"about_honor"];
        web.urlStr = strUrl;
        web.floog = @"小职了荣誉";
        [self.navigationController pushViewController:web animated:YES];
    }
    else if (indexPath.section == 1&& indexPath.row ==9999991)//官方账号
    {
        GuanfzhViewController *guanfang = [[GuanfzhViewController alloc]init];
        [self.navigationController pushViewController:guanfang animated:YES];
    }
    else if (indexPath.section == 1&& indexPath.row == 99999)//官网
    {
        WebViewController *web = [[WebViewController alloc]init];
        web.urlStr = @"www.xzhiliao.com";
        web.floog = @"小职了官网";
        [self.navigationController pushViewController:web animated:YES];
    }
    else if (indexPath.section == 1&& indexPath.row == 0)//客服电话
    {
         [self telPhone];
    }
}
- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)comeback:(id)sender
{
    UIButton *button1 = (UIButton *)sender;
    LookIntroduceViewController *look = [[LookIntroduceViewController alloc]init];
    LookStartViewController *start = [[LookStartViewController alloc]init];
    SampleViewController *webView = [[SampleViewController alloc]init];
    FeedbackVC *feedc = [[FeedbackVC alloc]init];
    switch (button1.tag) {
        case 1001:
            [self.deleat upDatebb01:YES];
            break;
        case 1002:
            [self.navigationController pushViewController:look animated:YES];
            break;
        case 1003:
            [self.navigationController pushViewController:start animated:YES];
            break;
        case 1004:
            //用户协议
      webView.urlStr = @"www.hrbanlv.com/serve/agreement.jsp";
           [self presentModalViewController:webView animated:YES];
             break;
        case 1006:
            //官网
           webView.urlStr = @"www.xzhiliao.com";
              [self presentModalViewController:webView animated:YES];
            break;
        case 1007:
            //电话
            [self telPhone];
           // [[UIApplication sharedApplication] openURL:url];
            break;
            case 1005:
             [self.navigationController pushViewController:feedc animated:YES];
            break;
        default:
            break;
    }
}
- (void)telPhone
{
    UIActionSheet *actionSheet02;
    actionSheet02 = [[UIActionSheet alloc]
                     initWithTitle:@"拨打电话 "
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:@"0532-80901998"
                     otherButtonTitles:nil];
    actionSheet02.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet02 showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:0532-80901998"];
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
    }else {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
