//
//  ZhangXinBaoViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-25.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ZhangXinBaoViewController.h"
#import "WXApiObject.h"

#import "PurchaseViewController.h"
#import "NetWorkConnection.h"
#import "ZXBOrderViewController.h"
#import "HomeViewController.h"

#import "getRedEnvelopeViewController.h"

@interface ZhangXinBaoViewController ()

@property (nonatomic, copy) NSString *showWeb;

@end

@implementation ZhangXinBaoViewController

@synthesize dataArray=_dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
 
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addBackBtn];
    
    [self addTitleLabel:@"涨薪宝"];
    
    num=ios7jj;
    
    self.view.backgroundColor=XZhiL_colour2;
    
    _shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.backgroundColor=[UIColor clearColor];
    _shareBtn.frame = CGRectMake(iPhone_width-65,-3+num,65,50);
    _shareBtn.showsTouchWhenHighlighted=YES;
    _shareBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享" forState:UIControlStateHighlighted];
    [_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBtn];
    
    [self setNetConnection];
}

#pragma mark  网络连接

- (void)setNetConnection
{
    //得到当前用户状态的接口
    NSString *tUrlStr = kCombineURL(KXZhiLiaoAPI,kZXBGetStatus);
    
    NSMutableDictionary *tParamDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:kUserTokenStr,@"userToken",IMEI,@"userImei", nil];
    
    NSURL *tUrl = [NetWorkConnection dictionaryBecomeUrl:tParamDic urlString:tUrlStr];
    
    ASIHTTPRequest *tRequest = [ASIHTTPRequest requestWithURL:tUrl];
    
    [tRequest setTimeOutSeconds:15];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    loadView.userInteractionEnabled = NO;
    
    [tRequest setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:tRequest.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"dic of state is %@",resultDic);
        
        NSString *error = [NSString stringWithFormat:@"%@",[resultDic valueForKey:@"error"]];
        
        urlStr=[resultDic valueForKey:@"url"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults setObject:resultDic forKey:@"ZXBStateDic"];
        
        [userDefaults synchronize];
        
        _dataArray = [resultDic valueForKey:@"data"];
        
        if (!error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取涨薪宝数据" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
            
            [alert show];
            
            return;
        }
        
        if ([_showWeb isEqualToString:@"show"] || [error isEqualToString:@"1"]) {
            
            _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num)];
            _webView.delegate=self;
            [_webView stringByEvaluatingJavaScriptFromString:@""];
            [self.view addSubview:_webView];
            
            NSString *zhangxinStr=kCombineURL(KXZhiLiaoAPI,ZhangXinBao);
            
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"1",@"ios",nil];
            
            NSURL *url=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:zhangxinStr];
            
            NSURLRequest *request=[NSURLRequest requestWithURL:url];
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:NO];
            
            loadView.userInteractionEnabled = NO;
            
            [_webView loadRequest:request];
            
        }else  if ([error isEqualToString:@"0"]) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44+num, iPhone_width, 55)];
            imageView.image = [UIImage imageNamed:@"caishenImage.png"];
            [self.view addSubview:imageView];
            
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,100+num, iPhone_width, iPhone_height - 88-num) style:UITableViewStyleGrouped];
            tableView.bounces=NO;
            tableView.backgroundView = nil;
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:tableView];
            
            UIButton *showBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            showBtn.backgroundColor=[UIColor clearColor];
            showBtn.frame = CGRectMake(10,230+([_dataArray count]-1)*60,300,40);
            [showBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
            [showBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
            [showBtn setTitle:@"服务介绍" forState:UIControlStateNormal];
            [showBtn setTitle:@"服务介绍" forState:UIControlStateHighlighted];
            [showBtn addTarget:self action:@selector(intro:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:showBtn];
        }
    }];
    
    [tRequest setFailedBlock:^{
        
        [loadView hide:YES];
    
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法获取涨薪宝数据" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        
        [alertView show];
        
    }];
    
    [tRequest startAsynchronous];
}


#pragma mark UITableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }else
    {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
    
    imageView.image = [UIImage imageNamed:@"zxbIcon.png"];
    
    NSDictionary *tDic = [_dataArray objectAtIndex:indexPath.row];
    
    NSString *state = [NSString stringWithFormat:@"%@", [tDic valueForKey:@"state"]];
    
    NSString *stateName = @"";
    
    if([state isEqualToString:@"1"]){
        stateName = @"小宝";
    }else if([state isEqualToString:@"2"] || [state isEqualToString:@"12"]){
        stateName = @"二宝";
    }else if([state isEqualToString:@"3"] || [state isEqualToString:@"13"] || [state isEqualToString:@"23"]){
        stateName = @"三宝";
    }
    
    UILabel *stateNameLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 60,15)];
    stateNameLab.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    stateNameLab.textColor = [UIColor blackColor];
    stateNameLab.text = stateName;
    
    NSString *claim;
    
    NSString *applyStatus = [NSString stringWithFormat:@"%@", [tDic valueForKey:@"applystatus"] ];
    
    if ([applyStatus isEqualToString:@"0"]) {
        claim = @"等待赔付";
    } else if ([applyStatus isEqualToString:@"1"]) {
        claim = @"赔付成功";
    } else if ([applyStatus isEqualToString:@"2"]) {
        claim = @"赔付失败";
    } else if ([applyStatus isEqualToString:@"5"]) {
        claim = @"";
    }
    
    UILabel *claimLab = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 60,15)];
    claimLab.font =  [UIFont systemFontOfSize:14];
    claimLab.textColor = [UIColor orangeColor];
    claimLab.text = claim;
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 160,15)];
    timeLab.font =  [UIFont systemFontOfSize:14];
    timeLab.textColor = [UIColor blackColor];
    timeLab.text = [NSString stringWithFormat:@"%@~%@",[tDic valueForKey:@"beginTime"],[tDic valueForKey:@"endTime"]];
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:stateNameLab];
    [cell.contentView addSubview: claimLab];
    [cell.contentView addSubview: timeLab];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tDic = [_dataArray objectAtIndex:indexPath.row];
    
    NSString *applyStatus = [NSString stringWithFormat:@"%@", [tDic valueForKey:@"applystatus"] ];
    
    if ([applyStatus isEqualToString:@"2"] || [applyStatus isEqualToString:@"5"]) {
    
        ZXBOrderViewController *order = [[ZXBOrderViewController alloc] init];
        
        order.Pub_dic = tDic;
        
        [self.navigationController pushViewController:order animated:YES];
    }else {
        
        //mbat
        //赔付页面
    }
}

#pragma mark 按钮响应事件

//抢红包
- (void)getBtnClick:(id)sender
{
    getRedEnvelopeViewController *getRedVC=[[getRedEnvelopeViewController alloc]init];
    
    getRedVC.getString=@"抢红包";
    
    getRedVC.shareURL=urlStr;
    
    [self.navigationController pushViewController:getRedVC animated:YES];
}

//发红包
- (void)putBtnClick:(id)sender
{
    getRedEnvelopeViewController *getRedVC=[[getRedEnvelopeViewController alloc]init];
    
    getRedVC.getString=@"发红包";
    
    getRedVC.shareURL=urlStr;
    
    [self.navigationController pushViewController:getRedVC animated:YES];
}

#pragma mark 进入购买界面

- (void)intro:(id)sender  //进入购买界面的按钮
{
    ZhangXinBaoViewController *zvc = [[ZhangXinBaoViewController alloc] init];
    zvc.showWeb = @"show";
    [self.navigationController pushViewController:zvc animated:YES];
}

#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadView hide:YES];
    
    _webView.frame = CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num-40);
    
    UIButton *getBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    getBtn.frame=CGRectMake(0,iPhone_height-40,iPhone_width/2-0.2,40);
    getBtn.backgroundColor=XZhiL_colour;
    [getBtn setTitle:@"抢红包" forState:UIControlStateNormal];
    [getBtn setTitle:@"抢红包" forState:UIControlStateHighlighted];
    [getBtn addTarget:self action:@selector(getBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getBtn];
    
    UIButton *putBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    putBtn.frame=CGRectMake(iPhone_width/2+0.4,iPhone_height-40,iPhone_width/2-0.2,40);
    putBtn.backgroundColor=XZhiL_colour;
    [putBtn setTitle:@"发红包" forState:UIControlStateNormal];
    [putBtn setTitle:@"发红包" forState:UIControlStateHighlighted];
    [putBtn addTarget:self action:@selector(putBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:putBtn];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadView hide:YES];
    
    _webView.frame = CGRectMake(0,44+num,iPhone_width,iPhone_height-44-num);
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType  {
    
    NSString *urlString = [[request URL] absoluteString];
    
    if ([urlString isEqualToString:@"objc://requestFromJs"]) {
        
        [self enterPurchaseView];
    }
    
    return YES;
}

#pragma mark 按钮响应事件

- (void)enterPurchaseView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults valueForKey:@"ZXBStateDic"];
    
    NSString *error = [NSString stringWithFormat:@"%@",[dic valueForKey:@"error"]];
    
    NSString *isout = [NSString stringWithFormat:@"%@",[dic valueForKey:@"isout"]];
   
    if([error isEqualToString:@"1"]){
    
        PurchaseViewController *purchaseVC=[[PurchaseViewController alloc]init];
        [self.navigationController pushViewController:purchaseVC animated:YES];
        
    } else if (![isout isEqualToString:@"1"]) {
        OLGhostAlertView *alert = [[OLGhostAlertView alloc] init];
        alert.message = @"您已购买涨薪宝，可在详情页面升级服务！";
        alert.position = OLGhostAlertViewPositionBottom;
        alert.timeout = 2;
        [alert show];
        
    }else if([error isEqualToString:@"0"]){
        
        ZhangXinBaoViewController *sVC = [[ZhangXinBaoViewController alloc] init];
        
        [self.navigationController pushViewController:sVC animated:YES];
    }
}

//分享按钮响应事件
- (void)shareBtnClick:(id)sender
{
}

//后退
- (void)backUp:(id)sender
{
    if ([_webView canGoBack]) {
    
        [_webView goBack];
        
    }else
    {
        if ([self.showWeb isEqualToString:@"show"]) {
         
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            NSArray *view = self.navigationController.viewControllers;
            
            NSLog(@"view in this VC is %@",view);
            
            [self.navigationController popToViewController:[view objectAtIndex:0] animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
