//
//  ScanningViewController.m
//  JobKnow
//
//  Created by Zuo on 13-11-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//


#import "RTLabel.h"
#import "CityInfo.h"
#import "SaveCount.h"
#import "cnvUILabel.h"
#import "LDProgressView.h"
#import "JobSeeViewController.h"
#import "ScanningViewController.h"
#import "SearchViewResultController.h"
#import "GRBookerAndCityInfo.h"
#import "GRCityInfoNumsModel.h"
#import "GRBookPositionListViewController.h"

@interface ScanningViewController ()

@end

@implementation ScanningViewController
@synthesize fromWhereStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"scanningVC"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"scanningVC"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackBtnGR];
    
    [self addTitleLabelGR:@"理才师搜索职位"];
    
    judge=NO;
    
    i=0;
    
    [GRBookerAndCityInfo standerDefault].model_cityInfo = _model_cityInfo;
    [GRBookerAndCityInfo standerDefault].model_booker = _model_booker;
    
    db=[UserDatabase sharedInstance];
    _dataArray=[[NSMutableArray alloc]init];
    
    resultDic=[[NSDictionary alloc]init];
    
    //loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:2 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,64,iPhone_width,iPhone_height)];
    scrollview.delegate=self;
    scrollview.showsVerticalScrollIndicator=YES;
    scrollview.alwaysBounceVertical=YES;
    [scrollview setBackgroundColor:[UIColor whiteColor]];
    if (IOS7){
        if (iPhone_5Screen){
            scrollview.contentSize=CGSizeMake(iPhone_width,iPhone_height+10);
        }else
        {
            scrollview.contentSize=CGSizeMake(iPhone_width,iPhone_height+100);
        }
    }
    
    [self.view addSubview:scrollview];
    
    progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20,49, self.view.frame.size.width-40, 6)];
    progressView.progress = 1;
    progressView.color=RGB(255, 163, 29);
    progressView.background = RGB(243, 243, 243);
    progressView.type = LDProgressGradient;
    [scrollview addSubview:progressView];
    
    UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(55,260,iPhone_width,60)];
    showLabel.tag=100;
    showLabel.font=[UIFont systemFontOfSize:15.6];
    showLabel.backgroundColor=[UIColor clearColor];
    showLabel.textColor=[UIColor grayColor];
    showLabel.text=@"正在为您收集职位数据...";
    [scrollview addSubview:showLabel];
    
    UIActivityIndicatorView *indicatorView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.frame=CGRectMake(165,4.5,50,50);
    [showLabel addSubview:indicatorView];
    [indicatorView startAnimating];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishRequest:) name:@"toScanningVC" object:nil];
    
    //从LDProgressView处接受的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(finishRequest:) name:@"toScanningVC2" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopLoadView) name:@"toScanningVCStop" object:nil];
    
    //6秒后用户可以返回
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(setJudge) userInfo:nil repeats:NO];
}


//响应从ReadViewController发来的通知,显示下面的新增职位,累计,去重前职位

-(void)finishRequest:(NSNotification *)noti
{

    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(drawText) userInfo:nil repeats:NO];

}

-(void)drawText
{
    
    UILabel *label=(UILabel *)[self.view viewWithTag:100];
    [label removeFromSuperview];
    
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0,283,scrollview.width,125)];
    backView.backgroundColor=[UIColor clearColor];
    [scrollview addSubview:backView];
    UIImage *imageBack = [UIImage imageNamed:@"scanning_back"] ;
    UIImageView *imageVBack = [[UIImageView alloc] initWithImage:[imageBack stretchableImageWithLeftCapWidth:imageBack.size.width/2 topCapHeight:imageBack.size.height/2]];
    [imageVBack setFrame:CGRectMake(23, 0, backView.width-23*2, 125)];
    [backView addSubview:imageVBack];
    
    NSInteger all=0;
    all = [_model_cityInfo.website integerValue]+[_model_cityInfo.fair integerValue]+[_model_cityInfo.newspaper integerValue]+[_model_cityInfo.school integerValue]+[_model_cityInfo.company integerValue];
    
    //全图片后面的字
    NSString *quanStr=[NSString stringWithFormat:@"<font color='#f76806'>100%%</font>为您搜遍%@<font color='#f76806'>%ld</font>个来源并自动去重",_model_booker.bookLocationName,(long)all];
    
    //创建显示“以下100%%覆盖%@%@个来源”的label
    RTLabel *myLabel=[[RTLabel  alloc]initWithFrame:CGRectMake((backView.width-256)/2,21,256,20)];
//    myLabel.backgroundColor=[UIColor greenColor];
//    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor=RGB(74, 74, 74);
    [myLabel setFont:[UIFont boldSystemFontOfSize:14]];
    myLabel.text=quanStr;
    [backView addSubview:myLabel];
    
    UILabel *leftNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 58, backView.width/2, 22)];
    leftNum.text = _model_booker.bookTodayData;
    leftNum.textColor = RGB(255, 163, 29);
    leftNum.font = [UIFont systemFontOfSize:20];
    leftNum.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:leftNum];
    
    UILabel *rightNum = [[UILabel alloc] initWithFrame:CGRectMake(backView.width/2, 58, backView.width/2, 22)];
    rightNum.text = _model_booker.bookTotalData;
    rightNum.textColor = RGB(255, 163, 29);
    rightNum.font = [UIFont systemFontOfSize:20];
    rightNum.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:rightNum];
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(backView.width/2-1.5, 55, 3, 52)];
    view_line.backgroundColor = RGB(239, 239, 239);
    [backView addSubview:view_line];
    
    UILabel *leftNum1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 92, backView.width/2, 15)];
    leftNum1.text = @"今日新增职位";
    leftNum1.textColor = RGB(74, 74, 74);
    leftNum1.font = [UIFont systemFontOfSize:15];
    leftNum1.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:leftNum1];
    
    UILabel *rightNum1 = [[UILabel alloc] initWithFrame:CGRectMake(backView.width/2, 92, backView.width/2, 15)];
    rightNum1.text = @"30天内新增";
    rightNum1.textColor = RGB(74, 74, 74);
    rightNum1.font = [UIFont systemFontOfSize:15];
    rightNum1.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:rightNum1];
    
    UIView *view_bottom = [[UIView alloc]initWithFrame:CGRectMake(0,backView.bottom,scrollview.width,185)];
    view_bottom.backgroundColor=RGB(247, 247, 247);
    [scrollview addSubview:view_bottom];
    
    
    //全图片
    UIImageView *dot=[[UIImageView alloc]initWithFrame:CGRectMake(21,15,20,32)];
    dot.image=[UIImage imageNamed:@"quchong"];
    [view_bottom addSubview:dot];

    
    //职位去重前的职位数
    NSString *recount=_model_booker.recount;
    NSInteger quchongInt=_model_booker.bookTotalData.integerValue+recount.integerValue;
    
    float number;
    
    if (recount&&recount.integerValue==0) {
        number=0;
    }else if ([recount integerValue]/60<0.1)
    {
        number=0.1;
    }else
    {
        number=[recount integerValue]/60;
    }
    
    RTLabel *myLabel7=[[RTLabel  alloc]initWithFrame:CGRectMake(50,15,kMainScreenWidth-50-25,70)];
    myLabel7.backgroundColor=[UIColor clearColor];
    myLabel7.text=[NSString stringWithFormat:@"今日职位去重前为<font color='#f76806'>%ld</font>个;职位去重后节省查看时间<font color='#f76806'>%.1f</font>小时",(long)quchongInt,number];
    [myLabel7 setFont:[UIFont boldSystemFontOfSize:15]];
    [view_bottom addSubview:myLabel7];

    UIButton *jobSeeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    jobSeeBtn.frame=CGRectMake(58,99,kMainScreenWidth-58*2,44);
    [jobSeeBtn setBackgroundColor:RGB(255, 163, 29)];
//    [jobSeeBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
//    [jobSeeBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    mViewBorderRadius(jobSeeBtn, 22, 1, [UIColor clearColor]);
    [jobSeeBtn setTitle:@"请查看" forState:UIControlStateNormal];
    [jobSeeBtn setTitle:@"请查看" forState:UIControlStateHighlighted];
    [jobSeeBtn addTarget:self action:@selector(jobSeeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view_bottom  addSubview:jobSeeBtn];
//
//    judge=YES;
}

/**确定按钮，进入职位查看**/
-(void)jobSeeBtnClick:(id)sender{
    __weak typeof(self) weakSelf = self;
//    GRCityInfoNumsModel *model = [GRCityInfoNumsModel yy_modelWithDictionary:dataDic];
    GRBookPositionListViewController *vc = [GRBookPositionListViewController new];
    vc.model = _model_booker;
    vc.model_cityInfo= _model_cityInfo;
    vc.array_model_booker = _array_model_booker;
    vc.isFromRegister = _isFromRegister;
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

//返回按钮
- (void)backUp:(id)sender
{
    if (judge){
        
        if ([fromWhereStr isEqualToString:@"搜索界面"]) {
            
            fromWhereStr=@"";
            
            NSLog(@"返回按钮被点击了");
            
            if ([_delegate respondsToSelector:@selector(scanningVC)]) {
                [_delegate scanningVC];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            return;
            
        }else if([fromWhereStr isEqualToString:@"已经搜索过"])
        {
            fromWhereStr=@"";
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else
        {
            fromWhereStr=@"";
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
}

/**连接4个字符串**/
-(NSString *)combineStr1:(NSString *)str andStr2:(NSString *)str2 andStr3:(NSString *)str3  andStr4:(NSString *)str4
{
    NSString *totalString=[str stringByAppendingFormat:@"+"];
    totalString=[totalString stringByAppendingString:str2];
    totalString=[totalString stringByAppendingFormat:@"+"];
    totalString=[totalString stringByAppendingString:str3];
    totalString=[totalString stringByAppendingFormat:@"+"];
    totalString=[totalString stringByAppendingString:str4];
    return totalString;
}

-(void)setJudge
{
    NSLog(@"setJudge方法执行到了。。。。。。");

    judge=YES;
}

//搜索失败的时候通知执行的方法
-(void)stopLoadView
{
    ghostView.message=@"搜索失败";
    [ghostView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
