//
//  HR_SettingViewController.m
//  JobKnow
//
//  Created by Suny on 15/8/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_SettingViewController.h"
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
#import "RecommendDynamicList.h"
#import "JumpWebViewController.h"


#import "ZhangXinBaoViewController.h"

#import "JobFairViewController.h"

@interface HR_SettingViewController ()

@end

@implementation HR_SettingViewController

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
    
    [self addTitleLabel:@"设置"];
    
    [self initData];
    

    NSArray *titleArray = [NSArray arrayWithObjects:@"修改密码",@"推荐动态开关",@"分享给好友",@"反馈意见",@"常见问题",@"退出登录",nil];//@"人才经纪人家族关系",
    
    NSArray *imgArray = [NSArray arrayWithObjects:@"hr_psd",@"hr_set_trend",@"hr_set_share",@"hr_feedback",@"hr_question",@"hr_logout",nil];//@"hr_invite",
    
    NSMutableArray *subArray = [NSMutableArray array];
    
    for (int i = 0; i < [titleArray count]; i++)
    {
        More *more = [[More alloc] init];
        
        more.moreImage = [UIImage imageNamed:[imgArray objectAtIndex:i]];
        
        more.moreName = [titleArray objectAtIndex:i];
        
        [subArray addObject:more];
        
        switch (i)
        {
            case 0:
                [_moreArray addObject:subArray];
                subArray= [NSMutableArray array];
                break;
            case 1:
                [_moreArray addObject:subArray];
                subArray= [NSMutableArray array];
                break;
            case 2:
                [_moreArray addObject:subArray];
                subArray = [NSMutableArray array];
                break;
            case 5:
                [_moreArray addObject:subArray];
                subArray = [NSMutableArray array];
                break;
//            case 6:
//                [_moreArray addObject:subArray];
//                break;
        }
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,44+num, iPhone_width, iPhone_height-44-num) style:UITableViewStyleGrouped];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor=XZhiL_colour2;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_moreArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    cell.labname.textColor=[UIColor blackColor];
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UIButton *btn_trend = [[UIButton alloc] initWithFrame:CGRectMake(iPhone_width-54, 10, 39, 21)];
        btn_trend.tag = 13001;
        btn_trend.userInteractionEnabled = NO;
        [btn_trend setImage:[UIImage imageNamed:@"switch_off"] forState:UIControlStateNormal];
        [btn_trend setImage:[UIImage imageNamed:@"switch_on"] forState:UIControlStateSelected];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:RecommendDynamicPlayStatus] isEqualToString:@"on"]) {
            [btn_trend setSelected:YES];
        }else{
            [btn_trend setSelected:NO];
        }
        [cell addSubview:btn_trend];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.section == 0){
//        
//        JumpWebViewController *vc = [[JumpWebViewController alloc] init];
//        vc.webTitle = @"人才经纪人家族关系";
//        
//        vc.jumpRequest = [NSString stringWithFormat:@"%@common/page_secret/set_invite_code?userToken=%@&userImei=%@",KXZhiLiaoAPI,kUserTokenStr,IMEI];
//        vc.isFromNodataApplyList = NO;
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    }else
        if (indexPath.section == 0) {
        //修改密码
        PassWordViewController *pass = [[PassWordViewController alloc]init];
        pass.myType = [NSString stringWithFormat:@"1"];
        [self.navigationController pushViewController:pass animated:YES];
    }else if (indexPath.section == 1) {//推荐动态开关
        UIButton *btn = (UIButton *)[[tableView cellForRowAtIndexPath:indexPath] viewWithTag:13001];
        if (btn.selected == YES) {
            [btn setSelected:NO];
            [[NSUserDefaults standardUserDefaults] setValue:@"off" forKey:RecommendDynamicPlayStatus];
        }else{
            [btn setSelected:YES];
            [[NSUserDefaults standardUserDefaults] setValue:@"on" forKey:RecommendDynamicPlayStatus];
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 0){
        //分享给好友
        if ([self judgmentLogin]){
            NSString *isHr = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"isHr"]];
            if ([isHr isEqualToString:@"2"]) {
                [self SharePTJHunter];
            }else{
                [self Share];
            }
            
        }else{
            
        }
        
    }else if (indexPath.section == 3 && indexPath.row == 0){
        //反馈意见
        if ([self judgmentLogin]){
            HRQuestionFeedbackViewController *feedBack = [[HRQuestionFeedbackViewController alloc] init];
            [self.navigationController pushViewController:feedBack animated:YES];
        }else{
            
        }
        
    }else if (indexPath.section == 3 && indexPath.row == 1){
        //常见问题
        WebViewController *web = [[WebViewController alloc]init];
        NSString *urlString = kCombineURL(KXZhiLiaoAPI,HRCommenQuestion);
        web.urlStr = urlString;
        web.floog = @"常见问题";
        [self.navigationController pushViewController:web animated:YES];
        
    }else if (indexPath.section == 3 && indexPath.row == 2){
        if([self judgmentLogin])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确认退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1100;
            [alert show];
            
        }else
        {
            ghostView.message=@"亲,您还没登录!";
            [ghostView show];
            return;
        }

    
    }
}

- (void)Share
{
    NSLog(@"分享按钮被执行到了。。。。。。");
    
//    NSString *shareTitle = @"全国HR都扎堆到小职了HR圈了！" ;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.tencentData.title = shareTitle;
//    
////    NSString *inviteCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"inviteId"];
//    NSString *shareLink = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xiao-zhi-le-qiu-zhi-zhao-pin/id840017362?mt=8"];
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareLink;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareLink;
//    [UMSocialData defaultData].extConfig.qqData.url = shareLink;
//    [UMSocialData defaultData].extConfig.qzoneData.url = shareLink;
//    
//    NSString *shareText = @"强烈推荐小职了HR圈！这个城市的所有同行HR都在这里的HR圈！我也在了，你呢？";
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@%@",shareText,shareLink];
//    [UMSocialData defaultData].extConfig.tencentData.shareText = [NSString stringWithFormat:@"%@%@",shareText,shareLink];
//    if ([XZLUtil isShareAppInstalled] == NO) {
//        mAlertView(nil, @"未发现分享所需的客户端");
//        return;
//    }
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToTencent,nil] delegate:nil];
}

- (void)SharePTJHunter
{
//    NSLog(@"分享按钮被执行到了。。。。。。");
//    
//    NSString *shareTitle = @"手里的简历能变现啦！" ;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qqData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.qzoneData.title = shareTitle;
//    [UMSocialData defaultData].extConfig.tencentData.title = shareTitle;
//    
////    NSString *inviteCode = [[NSUserDefaults standardUserDefaults] valueForKey:@"inviteId"];
//    NSString *shareLink = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/xiao-zhi-le-qiu-zhi-zhao-pin/id840017362?mt=8"];
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareLink;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareLink;
//    [UMSocialData defaultData].extConfig.qqData.url = shareLink;
//    [UMSocialData defaultData].extConfig.qzoneData.url = shareLink;
//    
//    NSString *shareText = @"我不是HR，我只是小职了的兼职猎手~在这里向企业推荐人才能拿奖金，你也快来试试！";
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@%@",shareText,shareLink];
//    [UMSocialData defaultData].extConfig.tencentData.shareText = [NSString stringWithFormat:@"%@%@",shareText,shareLink];
//    if ([XZLUtil isShareAppInstalled] == NO) {
//        mAlertView(nil, @"未发现分享所需的客户端");
//        return;
//    }
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppkey shareText:shareText shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ,UMShareToQzone,UMShareToTencent,nil] delegate:nil];
}

+ (void)removeAllInfo
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"LoginNew"];
    [user removeObjectForKey:@"userToken"];
    [user removeObjectForKey:@"UserName"];
    [user removeObjectForKey:@"passWord"];
    [user removeObjectForKey:@"canDeliver"];
    [user removeObjectForKey:@"inviteId"];
    
    [user removeObjectForKey:@"personName"];
    [user removeObjectForKey:@"user_tel"];
    [user removeObjectForKey:@"mWorkYear"];
    [user removeObjectForKey:@"isComplete"];
    
    [user synchronize];
}

#pragma mark- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
    }else {
        if (alertView.tag == 1100) {
            [self logout];
        }
    }
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


//退出登录
-(void)logout{
    
    NSString *url = kCombineURL(KXZhiLiaoAPI,zhuxiao);
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    NSURL *url2 = [NetWorkConnection dictionaryBecomeUrl:param urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url2];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [request setCompletionBlock:^{
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableLeaves error:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *error = [resultDic valueForKey:@"error"];
        if ([error integerValue] == 0) {
            NSLog(@"注销成功");
            [self removeDefaultInfo];
            
            //清楚简历库缓存
            if ([[HR_ResumeShareTool defaultTool] haveData]) {
                [[HR_ResumeShareTool defaultTool] clearData];
            }
            
            NSNotification *notification = [NSNotification notificationWithName:@"ResetSiXinCount" object:nil userInfo:[NSDictionary dictionaryWithObject:@"logout" forKey:@"logout"]];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSString *userName = [userDefaults valueForKey:@"UserName"];
            [userDefaults setValue:userName forKey:@"UserName"];
            [userDefaults setValue:@"Hr" forKey:@"LoginType"];
            [[HR_ResumeShareTool defaultTool] clearData];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app setRootVC];
        }
        
    }];
    [request setFailedBlock:^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    [request startAsynchronous];
}


-(void)removeDefaultInfo{
    [userDefaults removeObjectForKey:@"LoginNew"];
    [userDefaults removeObjectForKey:@"userToken"];
    //    [user removeObjectForKey:@"UserName"];
    [userDefaults removeObjectForKey:@"passWord"];
    [userDefaults removeObjectForKey:@"canDeliver"];
    [userDefaults removeObjectForKey:@"inviteId"];
    
    [userDefaults removeObjectForKey:@"personName"];
    [userDefaults removeObjectForKey:@"user_tel"];
    [userDefaults removeObjectForKey:@"mWorkYear"];
    [userDefaults removeObjectForKey:@"isComplete"];
    
    [userDefaults synchronize];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
