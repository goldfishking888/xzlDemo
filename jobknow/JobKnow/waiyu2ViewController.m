//
//  waiyu2ViewController.m
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "waiyu2ViewController.h"
#import "JSONKit.h"
#define  jianliWY @"api/resume_manage/language_list_save?"

@interface waiyu2ViewController ()
@end
@implementation waiyu2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
        alert.position = OLGhostAlertViewPositionCenter;
        
    }
    return self;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"外语能力2"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"外语能力2"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = XZHILBJ_colour;
    [self addBackBtn];
    [self addTitleLabel:@"外语能力"];
    int num = ios7jj;
    //保存
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(iPhone_width-35, 9+num, 25, 25);
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateHighlighted];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Confirm.png"] forState:UIControlStateNormal];
    //pressLogin
    [registBtn addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
    UIButton *residBtn01 =[UIButton buttonWithType:UIButtonTypeCustom];
    residBtn01.frame = CGRectMake(250, 0, 70, 44);
    [residBtn01 addTarget:self action:@selector(pressLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:residBtn01];

    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 46, iPhone_width, iPhone_height-46)style:UITableViewStyleGrouped];
    myTableView.delegate =self;
    myTableView.dataSource = self;
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    if ([self.myType isEqualToString:@"gai"]) {
        waiyupz = [NSString stringWithFormat:@"%@",self.waiyu];
        shuiping = [NSString stringWithFormat:@"%@",self.jibie];
    }else{
        self.myID = [NSString stringWithFormat:@""];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray *ary = [NSArray arrayWithObjects:@"外语语种",@"水      平", nil];
    cell.textLabel.text = [ary objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, 150, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor grayColor];
    label.tag = 520;
    label.font = [UIFont fontWithName:Zhiti size:14];
    [cell.contentView addSubview:label];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        label.text = waiyupz;
    }else if (indexPath.section ==0 && indexPath.row ==1){
        label.text = shuiping;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        waiyu3ViewController *waiyu = [[waiyu3ViewController alloc]init];
        waiyu.type = [NSString stringWithFormat:@"yuzh"];
        waiyu.delaet =self;
        [self.navigationController pushViewController:waiyu animated:YES];
    }
    else if(indexPath.row == 1 && indexPath.section == 0)
    {
        waiyu3ViewController *waiyu3 = [[waiyu3ViewController alloc]init];
        waiyu3.type = [NSString stringWithFormat:@"jibie"];
        waiyu3.delaet =self;
        [self.navigationController pushViewController:waiyu3 animated:YES];
    }    
}
- (void)chuanzhi:(NSString *)str myType:(NSString *)type
{
    if ([type isEqualToString:@"jibie"]) {
        shuiping = [NSString stringWithFormat:@"%@",str];
    }else{
        waiyupz = [NSString stringWithFormat:@"%@",str];
    }
    [myTableView reloadData];
}
- (void)pressLogin:(id)sender
{
    if (shuiping && waiyupz) {
        NSLog(@"ok");
        
        /***判断是否联网***/
        Net *n=[Net standerDefault];
        
        if (n.status ==NotReachable) {
            alert.message=@"无网络连接,请检查您的网络!";
            [alert show];
            return;
        }
        loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self resquext];
    }else{
        NSLog(@"wan shan");
        alert.message=@"请先完善信息";
        [alert show];
    }
}
//网络请求
- (void)resquext
{
    NSString *url = kCombineURL(KXZhiLiaoAPI,kSaveEducation);
    NSMutableDictionary*urlParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"user_language",@"table",self.myID,@"id",shuiping,@"languageLevel",waiyupz,@"languageName", nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:urlParamter urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        [loadView setHidden:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"外语保存的字典==%@",resultDic);
        NSString *errorstr = [resultDic valueForKey:@"error"];
        if ([errorstr integerValue]==0) {
            NSMutableArray *ary = [resultDic valueForKey:@"data"];
            NSLog(@"外语保存的数组=%@",ary);
            [self.deleat changeLangue:ary];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
    }];
    [request startAsynchronous];
}
- (void)requestTimeOut
{
}
- (void)receiveDataFail:(NSError *)error
{
}
- (void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    NSDictionary *reslult = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"外语保存的字典==%@",reslult);
    NSString *error = [reslult valueForKey:@"error"];
    if ([error integerValue]==0) {
         NSMutableArray *ary = [reslult valueForKey:@"data"];
         NSLog(@"外语保存的数组=%@",ary);
        [self.deleat changeLangue:ary];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
