//
//  MoreViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-19.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "MoreViewController.h"
#import "More.h"
#import "JobSourceViewController.h"
#import "QuestionFeedbackViewController.h"
#import "LookIntroduceViewController.h"
#import "LookStartViewController.h"
#import "MyTableCell.h"
#import "SinaWeiboRequest.h"
#import "AppDelegate.h"
#import "WeiboViewController.h"

#import "TipsView.h"
#import "FeedbackVC.h"
#import "PersonalViewController.h"


#import "ZhangXinBaoViewController.h"

#import "JobFairViewController.h"
#import "HR_ScanToLoginVC.h"



@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    return self;
}


- (void)initData
{
    num = ios7jj;
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor = XZhiL_colour2;

    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];

    ghostView.position = OLGhostAlertViewPositionCenter;

    _moreArray = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtn];
    
    [self addTitleLabel:@"更多"];
    
    [self initData];
    
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    
    if ([AppUD valueForKey:@"isHr"]&&[[NSString stringWithFormat:@"%@",[AppUD valueForKey:@"LoginNew"]] isEqualToString:@"0"]) {
        if ([AppUD valueForKey:@"isHr"]) {
            userType = [[AppUD valueForKey:@"isHr"] integerValue];
            
        }else{
            userType = UserTypeGeren;
        }
        
    }else{
        userType  = UserTypeGeren;
    }
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"扫一扫 扫码登录小职了电脑版",@"个人中心",@"分享管理",@"数据管理",@"意见反馈",@"常见问题",@"关于我们",@"喜欢我们？打分鼓励下",@"注销",nil];//@"全城招聘会",
    
    NSArray *imgArray = [NSArray arrayWithObjects:@"more_scan",@"more_mycenter",@"more_share",@"more_data",@"more_feed",@"more_question",@"more_about",@"more_good",@"more_login",nil];//@"more_jobfair",
    
    NSMutableArray *subArray = [NSMutableArray array];
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        More *more = [[More alloc] init];
        
        more.moreImage = [UIImage imageNamed:[imgArray objectAtIndex:i]];
        
        more.moreName = [titleArray objectAtIndex:i];
        
        [subArray addObject:more];
        
        switch (i)
        {
            case 1:
                [_moreArray addObject:subArray];
                subArray= [NSMutableArray array];
                break;
            case 4:
                [_moreArray addObject:subArray];
                subArray = [NSMutableArray array];
                break;
            case 8:
                [_moreArray addObject:subArray];
                break;
        }
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor=XZhiL_colour2;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (userType!=UserTypeGeren) {
        return [_moreArray count] +1;
    }
    return [_moreArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (userType!=UserTypeGeren) {
        if (section == 0) {
            return 1;
        }
        return [[_moreArray objectAtIndex:section-1] count];
    }
    
    return [[_moreArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(userType!=UserTypeGeren){
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell(0,0)"];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell(0,0)"];
            }
            [cell setBackgroundColor:[UIColor clearColor]];
            
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(-2, 0, iPhone_width+4 , cell.frame.size.height)];
            [btn setBackgroundColor:[UIColor whiteColor]];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [XZhiL_colour CGColor];
//            [btn.layer setCornerRadius:2.0];//圆角
            if (userType == UserTypeHR) {
                [btn setTitle:@"切换到HR圈" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickBtnChangeToHr) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
            
            
            [cell.contentView addSubview:btn];
            return cell;
        }
        
        static NSString *identifier = @"Cell";
        
        MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil){
            cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }else
        {
            cell.accessoryView = nil;
        }
        
        More *more = [[_moreArray objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.labname.frame =CGRectMake(50, cell.frame.size.height/2-10, 290, 20);
        cell.labname.text = more.moreName;
        cell.imagview.image = more.moreImage;
        
        if (indexPath.section==1) {
            cell.labname.textColor=XZhiL_colour;
        }else
        {
            cell.labname.textColor=[UIColor blackColor];
        }
        
        return cell;
    }
    
    static NSString *identifier = @"Cell";
    
    MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil){
        cell = [[MyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else
    {
        cell.accessoryView = nil;
    }
    
    More *more = [[_moreArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.labname.frame =CGRectMake(50, cell.frame.size.height/2-10, 290, 20);
    cell.labname.text = more.moreName;
    cell.imagview.image = more.moreImage;
    
    if (indexPath.section==0) {
        cell.labname.textColor=XZhiL_colour;
    }else
    {
        cell.labname.textColor=[UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (userType != UserTypeGeren) {
        [self didSelectRowInTableViewWithIndexPath:indexPath];
        return;
    }else{
        if (indexPath.section == 0&& indexPath.row ==0) {//扫一扫
            
            if ([self judgmentLogin]){
                HR_ScanToLoginVC *scan =[[HR_ScanToLoginVC alloc]init];
                scan.usertype = @"2";
                scan.title_str = @"扫一扫";
                scan.content_str = @"在浏览器中输入www.xzhiliao.com\n点击【登录】按钮\n扫描二维码登录小职了电脑版";
                [self.navigationController pushViewController:scan animated:YES];
            }else{
            }

            
        }else if (indexPath.section ==0 && indexPath.row ==1)//个人中心
        {
            if ([self judgmentLogin]){
                PersonalViewController *person =[[PersonalViewController alloc]init];
                [self.navigationController pushViewController:person animated:YES];
            }else{
            }
            
        }
//        else if (indexPath.section ==0 && indexPath.row ==2)//全城招聘会
//        {
//            if ([self judgmentLogin]){
//                
//                JobFairViewController *jobFairVC=[[JobFairViewController alloc]init];
//                [self.navigationController pushViewController:jobFairVC animated:YES];
//                
//            }else{
//                HRLogin *loginVC = [[HRLogin alloc]init];
//                [self.navigationController pushViewController:loginVC animated:YES];
//            }
//            
//        }
        else if (indexPath.section ==1&&indexPath.row==0)
        {
            
          
            
        }else if (indexPath.section ==1&&indexPath.row==1)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清除缓存么?(职位缓存)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1100;
            [alert show];
            
        }else if (indexPath.section ==1&&indexPath.row==2)
        {
            FeedbackVC *feed = [[FeedbackVC alloc]init];
            [self.navigationController pushViewController:feed animated:YES];
            
        }else if (indexPath.section==2&&indexPath.row==0)   //常见问题
        {
            QuestionFeedbackViewController *questionVC = [[QuestionFeedbackViewController alloc] init];
            [self.navigationController pushViewController:questionVC animated:YES];
            
        }else if (indexPath.section==2&&indexPath.row==1)
        {
            AboutWeViewController *aboutVC = [[AboutWeViewController alloc] init];
            aboutVC.deleat =self;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }else if (indexPath.section==2&&indexPath.row==2)
        {
            NSURL *url = [NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=840017362"];
            
            [[UIApplication sharedApplication] openURL:url];
            
        }else if (indexPath.section==2&&indexPath.row==3)
        {
            //        NSUserDefaults *AppUD = [NSUserDefaults standardUserDefaults];
            
            NSString *loginStr=kUserTokenStr;
            
            NSLog(@"注销按钮................");
            
            if(kUserTokenStr&&loginStr.length >0)
            {
                UIActionSheet *personCenter = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销当前账号" otherButtonTitles: nil];
                personCenter.tag = 888;
                personCenter.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                [personCenter showInView:self.view];
                
            }else
            {
                ghostView.message=@"亲,您还没登录!";
                [ghostView show];
                return;
            }
        }
    }
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    }else {
        if (alertView.tag == 1100) {
            ghostView.message = @"删除成功!";
            [ghostView show];
        }else if(alertView.tag == 1111)
        {
            NSURL *url = [NSURL URLWithString:trackurl];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

+ (void)removeAllInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"userUid"];
    [user removeObjectForKey:@"LoginNew"];
    [user removeObjectForKey:@"userToken"];
//    [user removeObjectForKey:@"UserName"];
    [user removeObjectForKey:@"passWord"];
    [user removeObjectForKey:@"canDeliver"];
    [user removeObjectForKey:@"inviteId"];
    
    [user removeObjectForKey:@"personName"];
    [user removeObjectForKey:@"user_tel"];
    [user removeObjectForKey:@"mWorkYear"];
    [user removeObjectForKey:@"isComplete"];
    
    [user synchronize];
}

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 888){
        
        if (buttonIndex==0) {
            [MoreViewController removeAllInfo];
            NSNotification *notification = [NSNotification notificationWithName:@"ResetSiXinCount" object:nil userInfo:[NSDictionary dictionaryWithObject:@"logout" forKey:@"logout"]];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetJobSeeCount" object:nil];
            //注销成功
            ghostView.message = @"注销成功!";
            [ghostView show];
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
    }else if (actionSheet.tag == 250)
    {
        if (buttonIndex == 0) {
            
            NSString *loginStr= [[NSUserDefaults standardUserDefaults] valueForKey:@"LoginNew"];
            if(loginStr&&loginStr.integerValue==0){
                InfoPerfectViewController *infoVC = [[InfoPerfectViewController alloc] init];
                infoVC.deleate = self;
                infoVC.myType = [NSString stringWithFormat:@"mima"];
                [self.navigationController pushViewController:infoVC animated:YES];
            }else
            {
            }
        }
        else if (buttonIndex == 1)
        {
            
        }
    }
}

#pragma mark 功能函数

-(void)didSelectRowInTableViewWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0&& indexPath.row ==0) {
        //        //跳转到HR home页
        //        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //        [app setRootVC];
    }else if (indexPath.section == 1&& indexPath.row ==0) {
        
        if ([self judgmentLogin]){
            HR_ScanToLoginVC *scan =[[HR_ScanToLoginVC alloc]init];
            scan.usertype = @"2";
            scan.title_str = @"扫一扫";
            scan.content_str = @"在浏览器中输入www.xzhiliao.com\n点击【登录】按钮\n扫描二维码登录小职了电脑版";
            [self.navigationController pushViewController:scan animated:YES];

        }
        
    }else if (indexPath.section == 1 && indexPath.row ==1) {
        
        if ([self judgmentLogin]){
            PersonalViewController *person =[[PersonalViewController alloc]init];
            [self.navigationController pushViewController:person animated:YES];
        }else{

        }
        
    }
//    else if (indexPath.section ==1 && indexPath.row ==2)//全城招聘会
//    {
//        if ([self judgmentLogin]){
//            
//            JobFairViewController *jobFairVC=[[JobFairViewController alloc]init];
//            [self.navigationController pushViewController:jobFairVC animated:YES];
//            
//        }else{
//            HRLogin *loginVC = [[HRLogin alloc]init];
//            [self.navigationController pushViewController:loginVC animated:YES];
//        }
//        
//    }
    else if (indexPath.section ==2 && indexPath.row==0)
    {
               
    }else if (indexPath.section == 2&& indexPath.row==1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要清除缓存么?(职位缓存)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1100;
        [alert show];
        
    }else if (indexPath.section ==2&&indexPath.row==2)//意见反馈
    {
        if ([self judgmentLogin]){
            FeedbackVC *feed = [[FeedbackVC alloc]init];
            [self.navigationController pushViewController:feed animated:YES];
        }else{

        }
    }else if (indexPath.section==3&&indexPath.row==0)   //常见问题
    {
        QuestionFeedbackViewController *questionVC = [[QuestionFeedbackViewController alloc] init];
        [self.navigationController pushViewController:questionVC animated:YES];
        
    }else if (indexPath.section==3&&indexPath.row==1)
    {
        AboutWeViewController *aboutVC = [[AboutWeViewController alloc] init];
        aboutVC.deleat =self;
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }else if (indexPath.section==3&&indexPath.row==2)
    {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/xiao-zhi-le-qiu-zhi-zhao-pin/id840017362?mt=8"];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }else if (indexPath.section==3&&indexPath.row==3)
    {
        //        NSUserDefaults *AppUD = [NSUserDefaults standardUserDefaults];
        
        NSString *loginStr=kUserTokenStr;
        
        NSLog(@"注销按钮................");
        
        if(kUserTokenStr&&loginStr.length >0)
        {
            UIActionSheet *personCenter = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销当前账号" otherButtonTitles: nil];
            personCenter.tag = 888;
            personCenter.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
            [personCenter showInView:self.view];
            
        }else
        {
            ghostView.message=@"亲,您还没登录!";
            [ghostView show];
            return;
        }
    }

}

//跳转到HR home页
-(void)clickBtnChangeToHr{
    
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    [AppUD setValue:@"Hr" forKey:@"LoginType"];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setRootVC];
}

//跳转到兼职猎手 home页
-(void)clickBtnChangeToPTJHunter{
    
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    [AppUD setValue:@"PTJHunter" forKey:@"LoginType"];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app setRootVC];
}

- (void)myBack:(id)sender
{
    AboutWeViewController *about = [[AboutWeViewController alloc]init];
    [self.navigationController pushViewController:about animated:YES];
}

- (void)changeColur1
{
    ghostView.message = @"信息添加成功";
    ghostView.position = OLGhostAlertViewPositionCenter;
    [ghostView show];
}

//关于我们的代理方法
- (void)upDatebb01:(BOOL)flag
{
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/lookup?id=840017362"];
    
    ASIHTTPRequest *httpClient = [[ASIHTTPRequest alloc] initWithURL:url];
    
    [httpClient setTimeOutSeconds:60];

    loadView = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled = NO;

    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    //NSLog(@"-----------------%@",nowVersion);
    
    [httpClient setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSDictionary *deserializedData = [NSJSONSerialization JSONObjectWithData:httpClient.responseData options:NSJSONReadingMutableLeaves error:nil];
        
        //NSLog(@"result======更新信息====================%@",[[NSString alloc] initWithData:httpClient.responseData encoding:NSUTF8StringEncoding]);
        
        if ([[deserializedData valueForKey:@"resultCount"] integerValue] == 1)
        {
            NSArray *infoArray = [deserializedData objectForKey:@"results"];
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *latestVersion = [releaseInfo objectForKey:@"version"];
            trackurl = [releaseInfo valueForKey:@"trackViewUrl"];
            if (latestVersion.floatValue > nowVersion.floatValue) {
                NSString *mess = [releaseInfo valueForKey:@"releaseNotes"];
                NSString *last = [[NSString alloc] initWithFormat:@"新版本（%@）",latestVersion];
                UIAlertView *newAlertView = [[UIAlertView alloc] initWithTitle:last message:mess delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"去更新", nil];
                newAlertView.tag = 1111;
                [newAlertView show];
                
            }else
            {
                if (flag) {
                    ghostView.message = @"当前已是最新版本";
                    [ghostView show];
                }
                
            }
        }else{
            if (flag) {
                ghostView.message = @"没有可用的更新";
                [ghostView show];
            }
        }
        //NSLog(@"======================%@",deserializedData);
    }];
    
    if(flag){
        [httpClient setFailedBlock:^{
        
            [loadView hide:YES];
            //ghostView.message = @"网络连接失败，请检查网络";
            //[ghostView show];
        }];
    }
    
    [httpClient startAsynchronous];
}

//注销个人信息

-(void)requestZhuxiao{
    
    NSString *url = kCombineURL(KXZhiLiaoAPI,zhuxiao);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    NSURL *url2 = [NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url2];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request setCompletionBlock:^{
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *resume = [resultDic valueForKey:@"error"];
        if ([resume integerValue] == 0) {
            
        }
        
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
}

//判断是否已经登录

- (BOOL)judgmentLogin
{
    
    BOOL isLogin = [[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginNew"]] isEqualToString:@"0"];
    if( kUserTokenStr!= nil && ![kUserTokenStr isEqual: @""] && isLogin)    return YES;
    
    else return NO;

//    NSUserDefaults *AppUD = [NSUserDefaults standardUserDefaults];
//    NSString *pwd = [AppUD valueForKey:@"passWord"];
//    if(pwd.length>0)
//    {
//        return YES;
//    }else
//    {
//        return NO;
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
