//
//  AccountsViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "AccountsViewController.h"
#import "ZhangXinProtocolViewController.h"

#import "HongBaoViewController.h"

#import "ASIHTTPRequest/ASIHTTPRequest.h"

#import "ZhiFuBaoViewController.h"
#import "UserDatabase.h"
#import "ReaderViewController.h"
#import "ZhangXinBaoViewController.h"
#import "jianliViewController.h"
#import "RedEnvelope.h"

@interface AccountsViewController ()

@end

@implementation AccountsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _nameStr=[[NSString alloc]init];
    }
    
    return self;
}

- (void)initData
{
    num=ios7jj;
    
    moneyy=0;
    
    _redEnvelopeStr=@"红包";
    
    resDic=[[NSDictionary alloc]init];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //微信支付成功后关闭MBProgressHUD
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHUD) name:@"HUDDismissNotification" object:nil];
    
    //微信支付成功后跳回首页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toZXB) name:@"ToZXBMainNotification" object:nil];

    [self addBackBtn];
    
    [self addTitleLabel:@"结算"];
    
    [self initData];
    
    NSLog(@"_nameStr in Accounts is %@",_nameStr);
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,400) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=NO;
    _tableView.backgroundView=nil;
    [self.view addSubview:_tableView];

    firstBtn=[myButton buttonWithType:UIButtonTypeCustom];
    firstBtn.tag=101;
    firstBtn.isClicked=YES;
    firstBtn.frame=CGRectMake(10,230,30,30);
    firstBtn.backgroundColor=[UIColor clearColor];
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"dotselect.png"] forState:UIControlStateNormal];
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"dotselect.png"] forState:UIControlStateHighlighted];
    [_tableView addSubview:firstBtn];
    
    secondBtn=[myButton buttonWithType:UIButtonTypeCustom];
    secondBtn.tag=102;
    secondBtn.isClicked=NO;
    secondBtn.frame=CGRectMake(10,274,30,30);
    secondBtn.backgroundColor=[UIColor clearColor];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateNormal];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateHighlighted];
    [_tableView addSubview:secondBtn];
    
    agreeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.backgroundColor=[UIColor clearColor];
    agreeBtn.frame=CGRectMake(30,390,20,20);
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateNormal];
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateHighlighted];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];

    UIButton* agreeBtn2=[UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn2.backgroundColor=[UIColor clearColor];
    agreeBtn2.frame=CGRectMake(20,380,40,40);
    [agreeBtn2 addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn2];

    protocolBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    protocolBtn.frame=CGRectMake(60,380,240,40);
    protocolBtn.backgroundColor=[UIColor clearColor];
    protocolBtn.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [protocolBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-50,0,0)];
    [protocolBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
    [protocolBtn setTitleColor:XZhiL_colour forState:UIControlStateHighlighted];
    [protocolBtn setTitle:@"我已阅读并同意涨薪宝购买协议" forState:UIControlStateNormal];
    [protocolBtn setTitle:@"我已阅读并同意涨薪宝购买协议" forState:UIControlStateHighlighted];
    [protocolBtn addTarget:self action:@selector(protocolBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protocolBtn];

    accountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    accountBtn.backgroundColor=[UIColor clearColor];
    accountBtn.frame = CGRectMake(10,428,300,40);
    [accountBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [accountBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [accountBtn setTitle:@"结算" forState:UIControlStateNormal];
    [accountBtn setTitle:@"结算" forState:UIControlStateHighlighted];
    [accountBtn addTarget:self action:@selector(accountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountBtn];
}

#pragma mark 按钮响应事件

//是否同意涨薪宝协议
- (void)agreeBtnClick:(id)sender
{
    isAgree=!isAgree;
    
    if (isAgree) {
        
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"kuagd.png"] forState:UIControlStateNormal];
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"kuagd.png"] forState:UIControlStateHighlighted];
    }else
    {
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateNormal];
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateHighlighted];
    }
}

//进入涨薪宝协议按钮
- (void)protocolBtnClick:(id)sender
{
    NSLog(@"protocolBtnClick.......");
    
    ZhangXinProtocolViewController *protocolVC=[[ZhangXinProtocolViewController alloc]init];
    
    [self.navigationController pushViewController:protocolVC animated:YES];
}

//结算按钮响应

- (void)accountBtnClick:(id)sender
{
    NSLog(@"accountBtnClick........");
    
    /*
     1.是否同意涨薪宝购买协议
     
     2.是否有订阅职位
     
     3.简历是否完善
     
     */
    
    if (!isAgree) {
        
        ghostView.message=@"请先同意涨薪宝购买协议";
        
        [ghostView show];
        
        return;
    }
    
    UserDatabase *db=[UserDatabase sharedInstance];
    
    NSArray *array=[db getAllRecords];
    
    if ([array count]==0) {
        
        ghostView.message=@"请先订阅相关职位";
        [ghostView show];
        
        ReaderViewController *readVC=[[ReaderViewController alloc]init];
        [self.navigationController pushViewController:readVC animated:YES];
        
        return;
    }
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *isComplete=[userDefaults valueForKey:@"isComplete"];
    NSString *canDeliver=[userDefaults valueForKey:@"canDeliver"];
    NSLog(@"isComplete is %@",isComplete);
    
    /*
     1.isComplete是否存在，不存在说明是第一次登录，此时判断canDeliver是否为0，0表示能投递，1表示不能投递
     
     */
    
    if (isComplete) {   //第一次登录
        
        if ([isComplete isEqualToString:@"不完善"]) {
            
            jianliViewController *jianliVC=[[jianliViewController alloc]init];
            [self.navigationController pushViewController:jianliVC animated:YES];
            
            ghostView.message=@"请先完善简历";
            [ghostView show];
            return;
        }
        
    }else
    {
        if (canDeliver.integerValue==1) {
            
            jianliViewController *jianliVC=[[jianliViewController alloc]init];
            
            [self.navigationController pushViewController:jianliVC animated:YES];

            ghostView.message=@"请先完善简历";
            [ghostView show];
            
            return;
        }
        
    }
    
    NSString *state;
    
    if ([_nameStr isEqualToString:@"小宝"]) {
        
        state=@"1";
        
    }else if ([_nameStr isEqualToString:@"二宝"])
    {
        state=@"2";
        
    }else if ([_nameStr isEqualToString:@"三宝"])
    {
        state=@"3";
    }
    int now=moneyy2-moneyy;
    
    NSString *money=[NSString stringWithFormat:@"%d",now];
    if (firstBtn.isClicked) {
        
        //支付宝接口
        NSString *url=kCombineURL(KXZhiLiaoAPI, kZhifubao);
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr, @"userToken",IMEI, @"userImei",_gainStr,@"gains",state,@"state",@"1",@"text",money,@"money",_redEnvelopeID,@"redEnvelopesId",nil];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        
        ZhiFuBaoViewController *zhifuVC=[[ZhiFuBaoViewController alloc]init];
        
        zhifuVC.URL=URL;
        
        [self.navigationController pushViewController:zhifuVC animated:YES];
        
    }else
    {
        NSMutableDictionary *tDic = [[NSMutableDictionary alloc ] init];
        
        if (state) {
            [tDic setValue:state forKey:@"state"];
        }
    
        if (_gainStr) {
            [tDic setValue:_gainStr forKey:@"gains"];
        }
        
        if (money) {
            [tDic setValue:money forKey:@"money"];
        }
        
        if (_nameStr) {
            [tDic setValue:_nameStr forKey:@"BName"];
        }
        
        if (_redEnvelopeID) {
        
            [tDic setValue:_redEnvelopeID forKey:@"redEnvelopesId"];
        }
        
        [tDic setValue:@"ToZXBMainNotificationAC" forKey:@"CallNoti"];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:tDic forKey:@"WeiXinPayDic"];
        [userDefaults synchronize];
        [self weiXinPay];
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 15.0f;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indenifier=@"cellIndenifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indenifier];
    
    if (cell==nil) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenifier];
    }else
    {
        for (UIView *view in cell.contentView.subviews) {
            
            [view removeFromSuperview];
        }
    }
    
    if (indexPath.section==0) {
        
        NSString *priceStr;
        
        if ([_nameStr isEqualToString:@"小宝"]) {
            
            priceStr=@"100.00元";
            
            moneyy2=100;
            
        }else if ([_nameStr isEqualToString:@"二宝"])
        {
            priceStr=@"200.00元";
            
            moneyy2=200;
            
        }else if ([_nameStr isEqualToString:@"三宝"])
        {
            priceStr=@"300.00元";
            
            moneyy2=300;
        }
        
        cell.textLabel.textColor=[UIColor grayColor];
        cell.textLabel.font=[UIFont systemFontOfSize:14];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(iPhone_width-70,7,70,30)];
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont systemFontOfSize:14.0f];
        label.textColor=XZhiL_colour;
        label.text=priceStr;
        
        if (indexPath.row==0) {
        
            cell.textLabel.text=_nameStr;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:label];
            
        }else if (indexPath.row==1)
        {
            if (![_redEnvelopeStr isEqualToString:@"红包"]) {
                
                cell.textLabel.textColor=XZhiL_colour;
            }
            cell.textLabel.text=_redEnvelopeStr;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row==2)
        {
            cell.textLabel.text=@"订单总计";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
            int now=moneyy2-moneyy;
            NSString *moneyNow=[NSString stringWithFormat:@"%d.00元",now];
            label.text=moneyNow;
            NSLog(@"moneyNow is %d",now);
            
            [cell.contentView addSubview:label];
        }
        
    }else
    {
        if (indexPath.row==0){
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,0,80,40)];
            label.backgroundColor=[UIColor clearColor];
            label.text=@"支付方式";
            label.textColor=XZhiL_colour;
            label.font=[UIFont boldSystemFontOfSize:16];
            [cell.contentView addSubview:label];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        }else
        {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60,7,70,30)];
            label.backgroundColor=[UIColor clearColor];
            label.font=[UIFont systemFontOfSize:14.0f];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor=[UIColor grayColor];

            if (indexPath.row==1) {
                label.text=@"支付宝";
                [cell.contentView addSubview:label];
            }else
            {
                label.text=@"微信";
                [cell.contentView addSubview:label];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        if (indexPath.row==1) {
            
            HongBaoViewController *hongBaoVC=[[HongBaoViewController alloc]init];
            
            hongBaoVC.delegate=self;
            
            if ([_redEnvelopeStr isEqualToString:@"红包"]) { //如果是第一次打开，进去什么也没有
                
                RedEnvelope *en=[RedEnvelope standerDefault];
                
                en.isCanUse=YES;
                
            }else                                           //已经选择了红包的前提下，在进入就显示红包
            {
                RedEnvelope *en=[RedEnvelope standerDefault];
                
                en.isCanUse=NO;
            }
            
            [self.navigationController pushViewController:hongBaoVC animated:YES];
        }
        
    }else if (indexPath.section==1)
    {
        myButton *btn=(myButton *)[_tableView viewWithTag:101];
        
        myButton *btn2=(myButton *)[_tableView viewWithTag:102];
        
        if (indexPath.row ==1)
        {
            NSLog(@"indexPath.row........1");
            btn.isClicked=YES;
            btn2.isClicked=NO;
            
        }else if (indexPath.row ==2)
        {
            NSLog(@"indexPath.row........2");
            btn.isClicked=NO;
            btn2.isClicked=YES;
        }
        
        for (int i=101; i<=102; i++) {
            
            myButton *btn=(myButton *)[_tableView viewWithTag:i];
            
            if (btn.isClicked) {
                [btn setBackgroundImage:[UIImage imageNamed:@"dotselect.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"dotselect.png"] forState:UIControlStateHighlighted];
            }else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateHighlighted];
            
            }
            
        }
    }
}

#pragma mark 红包的代理方法

- (void)hongbaoChange
{
    _redEnvelopeStr=@"红包";
    
    moneyy=0;
    
    [_tableView reloadData];
}

- (void)hongbao
{
    RedEnvelope *envelope=[RedEnvelope standerDefault];
 
    _redEnvelopeID=envelope.envelopeID;
    
    moneyy=envelope.money;

    _redEnvelopeStr=[NSString stringWithFormat:@"已使用%d元红包",envelope.money];
    
    [_tableView reloadData];
}

#pragma mark WeiXinPay

- (void)weiXinPay
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)toZXB
{
    NSLog(@"account toZXB");
    ZhangXinBaoViewController *zhangxinVC=[[ZhangXinBaoViewController alloc]init];
    [self.navigationController pushViewController:zhangxinVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
