//
//  ZhangXinBuyViewController.m
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "ZhangXinBuyViewController.h"

#import "AccountsViewController.h"
#import "ZhangXinCell.h"
#import "myButton.h"
@interface ZhangXinBuyViewController ()

@end

@implementation ZhangXinBuyViewController

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
   
    [self addBackBtn];
    
    [self addTitleLabel:@"涨薪宝"];
    
    NSLog(@"_gainStr is %@",_gainStr);
    
    UILabel *tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,44+num+15,iPhone_width,50)];
    tipLabel.backgroundColor=[UIColor clearColor];
    tipLabel.textColor=XZhiL_colour;
    tipLabel.numberOfLines=0;
    tipLabel.textAlignment=NSTextAlignmentLeft;
    tipLabel.font=[UIFont systemFontOfSize:14.5f];
    tipLabel.text=@"根据职位大数据的结果，适合您的涨薪宝如下：";
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,44+10+num+50,iPhone_width,200) style:UITableViewStyleGrouped];
    _tableView.bounces=NO;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=XZHILBJ_colour;
    _tableView.backgroundView=nil;
    [self.view addSubview:_tableView];
    
    [self.view addSubview:tipLabel];
    
    firstBtn=[myButton buttonWithType:UIButtonTypeCustom];
    firstBtn.tag=101;
    firstBtn.isClicked=YES;
    firstBtn.backgroundColor=[UIColor clearColor];
    firstBtn.frame=CGRectMake(12,9,30,30);
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"dotselect.png"] forState:UIControlStateNormal];
    [firstBtn setBackgroundImage:[UIImage imageNamed:@"dotselect.png"] forState:UIControlStateHighlighted];
    [_tableView addSubview:firstBtn];
    
    secondBtn=[myButton buttonWithType:UIButtonTypeCustom];
    secondBtn.tag=102;
    secondBtn.frame=CGRectMake(12,53,30,30);
    secondBtn.backgroundColor=[UIColor clearColor];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateNormal];
    [secondBtn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateHighlighted];
    [_tableView addSubview:secondBtn];
    
    thirdBtn=[myButton buttonWithType:UIButtonTypeCustom];
    thirdBtn.tag=103;
    thirdBtn.frame=CGRectMake(12,98,30,30);
    thirdBtn.backgroundColor=[UIColor clearColor];
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateNormal];
    [thirdBtn setBackgroundImage:[UIImage imageNamed:@"dotnoselect.png"] forState:UIControlStateHighlighted];
    [_tableView addSubview:thirdBtn];
    
    buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.backgroundColor=[UIColor clearColor];
    buyBtn.frame = CGRectMake(10,255,300,40);
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [buyBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [buyBtn setTitle:@"购买" forState:UIControlStateNormal];
    [buyBtn setTitle:@"购买" forState:UIControlStateHighlighted];
    [buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyBtn];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indenifier=@"cellIndenifier";
    
    ZhangXinCell *cell=[tableView dequeueReusableCellWithIdentifier:indenifier];
    
    if (cell==nil) {
        
        cell=[[ZhangXinCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indenifier];
    }
 
    NSString *percentStr;
    
    if (indexPath.row==0) {
        
        percentStr=[NSString stringWithFormat:@"涨幅 <font color='#35aae7'>%@%%</font>",_gainStr];
        
        [cell  setTitleForLabel:@"小宝" andSecond:percentStr andThird:@"100元"];
        
    }else if(indexPath.row==1)
    {
        int gaint=_gainStr.integerValue+3;
        
        percentStr=[NSString stringWithFormat:@"涨幅 <font color='#35aae7'>%d%%</font>",gaint];
        
        [cell  setTitleForLabel:@"二宝" andSecond:percentStr andThird:@"200元"];
        
    }else
    {
        int gaint=_gainStr.integerValue+6;
        percentStr=[NSString stringWithFormat:@"涨幅 <font color='#35aae7'>%d%%</font>",gaint];
        [cell  setTitleForLabel:@"三宝" andSecond:percentStr andThird:@"300元"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myButton *subBtn=(myButton *)[_tableView viewWithTag:101];
    
    myButton *subBtn2=(myButton *)[_tableView viewWithTag:102];
    
    myButton *subBtn3=(myButton *)[_tableView viewWithTag:103];
    
    if (indexPath.row==0) {
        
        subBtn.isClicked=YES;
        
        subBtn2.isClicked=NO;
        
        subBtn3.isClicked=NO;
    }else if(indexPath.row==1)
    {
        subBtn.isClicked=NO;
        
        subBtn2.isClicked=YES;
        
        subBtn3.isClicked=NO;
        
    }else if (indexPath.row==2)
    {
        subBtn.isClicked=NO;
        
        subBtn2.isClicked=NO;
        
        subBtn3.isClicked=YES;
    }
    
    for (int i=101;i<=103; i++) {
        
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

#pragma mark 进入购买界面

- (void)buyBtnClick:(id)sender  //进入购买界面的按钮
{
    NSLog(@"buyBtnClick...............");
    
    for (int i=101;i<=103; i++) {
        
        myButton *btn=(myButton *)[_tableView viewWithTag:i];
        
        
        if (btn.isClicked&&btn.tag==101) {
            
            nameStr=@"小宝";
        }else if (btn.isClicked&&btn.tag==102)
        {
            nameStr=@"二宝";
            
            int gain=_gainStr.integerValue+3;
            
            _gainStr=[NSString stringWithFormat:@"%d",gain];
            
            
        }else if (btn.isClicked&&btn.tag==103)
        {
            nameStr=@"三宝";
            
            int gain=_gainStr.integerValue+6;
            
            _gainStr=[NSString stringWithFormat:@"%d",gain];
        }
    }
    
    NSLog(@"nameStr in buyBtnClick is %@",nameStr);
    
    AccountsViewController *accountVC =[[AccountsViewController alloc]init];
    accountVC.gainStr=_gainStr;
    accountVC.nameStr=nameStr;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)hideHUD
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
