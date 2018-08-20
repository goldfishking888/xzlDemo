//
//  UpdateOrderViewController.m
//  JobKnow
//
//  Created by admin on 14-7-30.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "UpdateOrderViewController.h"
#import "ZhangXinBaoViewController.h"
#import "ZhiFuBaoViewController.h"
#import "HomeViewController.h"
int Pub_num;
int Pub_gains;
UIButton *Pub_checkBtn01;
UIButton *Pub_checkBtn02;
BOOL Pub_isCheck01;
BOOL Pub_isCheck02;
NSString *Pub_submit_state;
NSString *Pub_submit_state01;
NSString *Pub_submit_state02;
UITextView *Pub_tv02;
NSString *Pub_BName01;
NSString *Pub_money;
NSString *Pub_BName;

@interface UpdateOrderViewController ()

@end

@implementation UpdateOrderViewController
@synthesize Pub_dic;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    Pub_isCheck01 = NO;
    Pub_isCheck02 = NO;
    Pub_num = ios7jj;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
 
    }
    return self;
}

- (void)viewDidLoad
{
    //微信支付成功后关闭MBProgressHUD
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideHUD) name:@"HUDDismissNotification" object:nil];
    
    //微信支付成功后跳回首页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toZXB) name:@"ToZXBMainNotificationUO" object:nil];
    [super viewDidLoad];
    [self addBackBtn];
    [self addTitleLabel:@"修改订单"];
    
    UITextView *tv01 = [[UITextView alloc] initWithFrame:CGRectMake(5, 46+Pub_num, iPhone_width-40, 40)];
    tv01.font = [UIFont systemFontOfSize:14];
    tv01.textColor =RGBA(53, 176, 247, 1);
    tv01.backgroundColor = [UIColor clearColor];
    tv01.text = @"您可在当前已购服务基础上，补足差价，升级服务。";
    [self.view addSubview:tv01];
   
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 80+Pub_num, iPhone_width, 200+Pub_num) style:UITableViewStyleGrouped];
    tableView.backgroundView = nil;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces=NO;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor=[UIColor clearColor];
    buyBtn.frame = CGRectMake(10,300+Pub_num,300,40);
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [buyBtn setTitle:@"确认升级" forState:UIControlStateNormal];
    [buyBtn setTitle:@"确认升级" forState:UIControlStateHighlighted];
    [buyBtn addTarget:self action:@selector(showSheet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
}

#pragma mark UITableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *state = [NSString stringWithFormat:@"%@", [Pub_dic valueForKey:@"state"]];
    
    if ([state isEqualToString:@"1"]) {
        return 3;
    } else if ([state isEqualToString:@"2"] || [state isEqualToString:@"12"]) {
        return 2;
    } else if ([state isEqualToString:@"3"]) {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    UILabel *lbl01 = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 70,20)];
    lbl01.font =  [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
    lbl01.textColor = [UIColor blackColor];
    
    UILabel *lbl02 = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 160,20)];
    lbl02.font =  [UIFont systemFontOfSize:14];
    lbl02.textColor = [UIColor blackColor];
    
    NSString *state = [NSString stringWithFormat:@"%@", [Pub_dic valueForKey:@"state"]];
    NSString *stateName = @"";
    if([state isEqualToString:@"1"]){
        stateName = @"小宝";
    }else if([state isEqualToString:@"2"] || [state isEqualToString:@"12"]){
        stateName = @"二宝";
    }else if([state isEqualToString:@"3"] || [state isEqualToString:@"13"] || [state isEqualToString:@"23"]){
        stateName = @"三宝";
    }

    if (indexPath.row == 0) {
        lbl01.text = @"会员类型";
        lbl02.text = stateName;
        [cell.contentView addSubview: lbl01];
    } else if(indexPath.row == 1){
        Pub_checkBtn01=[UIButton buttonWithType:UIButtonTypeCustom];
        Pub_checkBtn01.backgroundColor=[UIColor clearColor];
        Pub_checkBtn01.frame=CGRectMake(30, 10, 20,20);
        [Pub_checkBtn01 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateNormal];
        [Pub_checkBtn01 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateHighlighted];
        [Pub_checkBtn01 addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:Pub_checkBtn01];
        
        if([stateName isEqualToString:@"小宝"]){
            lbl02.text = @"二宝";
            Pub_BName01 = @"二宝";
            Pub_submit_state01 = @"12";
        } else {
            lbl02.text = @"三宝";
            Pub_BName01 = @"三宝";
            Pub_submit_state01 = @"23";
        }
    } else if(indexPath.row == 2){
        Pub_checkBtn02=[UIButton buttonWithType:UIButtonTypeCustom];
        Pub_checkBtn02.backgroundColor=[UIColor clearColor];
        Pub_checkBtn02.frame=CGRectMake(30, 10, 20,20);
        [Pub_checkBtn02 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateNormal];
        [Pub_checkBtn02 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateHighlighted];
        [Pub_checkBtn02 addTarget:self action:@selector(checkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:Pub_checkBtn02];
        
        lbl01.text = @"截至日期";
        lbl02.text = @"三宝";
        Pub_submit_state02 = @"13";
    }
    
    [cell.contentView addSubview: lbl02];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        [self checkBtnClick:Pub_checkBtn01];
    } else if (indexPath.row == 2) {
        [self checkBtnClick:Pub_checkBtn02];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark 按钮响应事件
- (void)showSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择支付方式"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles: @"支付宝", @"微信支付",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        //支付宝接口
        NSString *url=kCombineURL(KXZhiLiaoAPI, kZhifubao);
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kUserTokenStr, @"userToken",IMEI, @"userImei",[NSString stringWithFormat:@"%d", Pub_gains],@"gains",@"1",@"text",Pub_submit_state,@"state",Pub_money,@"money",@"0", @"redEnvelopesId",nil];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        
        ZhiFuBaoViewController *zhifuVC=[[ZhiFuBaoViewController alloc]init];
        
        zhifuVC.URL=URL;
        
        [self.navigationController pushViewController:zhifuVC animated:YES];
        
    }else if (buttonIndex == 1) {
//        NSDictionary *tDic = [NSDictionary dictionaryWithObjectsAndKeys:Pub_submit_state,@"state",Pub_gains,@"gains",Pub_money,@"money",@"0",@"redEnvelopesId",Pub_BName,@"BName", nil];
        NSMutableDictionary *tDic = [[NSMutableDictionary alloc ] init];
        if (Pub_submit_state) {
            [tDic setValue:Pub_submit_state forKey:@"state"];
        }
        if (Pub_gains) {
            [tDic setValue:[NSString stringWithFormat:@"%d", Pub_gains] forKey:@"gains"];
        }
        if (Pub_money) {
          // [tDic setValue:Pub_money forKey:@"money"];
        }
        if (Pub_BName) {
            [tDic setValue:Pub_BName forKey:@"BName"];
        }
        
        [tDic setValue:@"ToZXBMainNotificationUO" forKey:@"CallNoti"];
           // [tDic setValue:@"0" forKey:@"redEnvelopesId"];
       
        NSUserDefaults *na = [NSUserDefaults standardUserDefaults];
        [na setObject:tDic forKey:@"WeiXinPayDic"];
        [na synchronize];
        [self weiXinPay];
    }
    
}
- (void)checkBtnClick:(id)sender
{
    NSString *gainsStr = [NSString stringWithFormat:@"%@",[Pub_dic valueForKey:@"gains"] ];
    Pub_gains = [gainsStr integerValue];
    if (sender == Pub_checkBtn01 && !Pub_isCheck01) {
        Pub_isCheck01 = !Pub_isCheck01;
        if (Pub_isCheck01) {
            Pub_isCheck02 = NO;
        }
    } else if (sender == Pub_checkBtn02 && !Pub_isCheck02) {
        Pub_isCheck02 = !Pub_isCheck02;
        if (Pub_isCheck02) {
            Pub_isCheck01 = NO;
        }
    }
    if(Pub_isCheck01){
        Pub_money = @"100";
        Pub_BName = Pub_BName01;
        Pub_submit_state = Pub_submit_state01;
        Pub_gains += 3;
        [Pub_checkBtn01 setBackgroundImage:[UIImage imageNamed:@"kuagd.png"] forState:UIControlStateNormal];
        [Pub_checkBtn01 setBackgroundImage:[UIImage imageNamed:@"kuagd.png"] forState:UIControlStateHighlighted];
    }else{
        [Pub_checkBtn01 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateNormal];
        [Pub_checkBtn01 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateHighlighted];
    }
    if(Pub_isCheck02){
        Pub_money = @"200";
        Pub_BName = @"三宝";
        Pub_submit_state = Pub_submit_state02;
        Pub_gains += 6;
        [Pub_checkBtn02 setBackgroundImage:[UIImage imageNamed:@"kuagd.png"] forState:UIControlStateNormal];
        [Pub_checkBtn02 setBackgroundImage:[UIImage imageNamed:@"kuagd.png"] forState:UIControlStateHighlighted];
    }else{
        [Pub_checkBtn02 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateNormal];
        [Pub_checkBtn02 setBackgroundImage:[UIImage imageNamed:@"kuagk.png"] forState:UIControlStateHighlighted];
    }
    
    [Pub_tv02 removeFromSuperview];
    Pub_tv02 = [[UITextView alloc] initWithFrame:CGRectMake(5, 240+Pub_num, iPhone_width-40, 40)];
    Pub_tv02.font = [UIFont  systemFontOfSize:14];
    Pub_tv02.textColor = RGBA(53, 176, 247, 1);
    Pub_tv02.backgroundColor = [UIColor clearColor];
    Pub_tv02.text = [NSString stringWithFormat:
    @" 您需要补足%@元，即可把涨幅不低于%d%%的%@领回家 ",Pub_money,Pub_gains,Pub_BName];
    [self.view addSubview:Pub_tv02];
}
- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)toZXB
{
    NSLog(@"updateorder toZXB");
    ZhangXinBaoViewController *zhangxinVC=[[ZhangXinBaoViewController alloc]init];
    [self.navigationController pushViewController:zhangxinVC animated:YES];
}

- (void)weiXinPay
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

@end
