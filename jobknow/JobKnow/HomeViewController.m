//
//  HomeViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-2-28.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "AppDelegate.h"
#import "Config.h"
#import "FlatButton.h"
#import "FlatButton+AddImage.h"
#import "CityInfo.h"
#import "JobModel.h"
#import "UserDatabase.h"
#import "HomeViewController.h"

#import "OtherLogin.h"

#import "ReaderViewController.h"
#import "JobFairViewController.h"       //全城招聘会
#import "JobSeeViewController.h"

#import "MoreViewController.h"
#import "JobSourceViewController.h"     //职位大数据
#import "AboutWeViewController.h"       //关于我们
#import "jianliViewController.h"
#import "allCityViewController.h"

#import "NewReadView.h"
#import "ASIHTTPRequest/ASINetworkQueue.h"

#import "ZhangXinBaoViewController.h"
#import "MessageListViewController.h"

//#import "HrHomeVC.h"
#import "HR_HomeViewController.h"

#import "WebViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)initData
{
    num =ios7jj;
    
    cityStr=[[NSString alloc]init];

    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    db=[UserDatabase sharedInstance];
    
    userDefaults =[NSUserDefaults standardUserDefaults];
    
    self.view.backgroundColor=XZhiL_colour2;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)addHomeTitleLabel:(NSString*)title secTitle:(NSString *)str{
    
    titleLabel_1= [[UILabel alloc]initWithFrame:CGRectMake(77, 9+self.num, 120, 25)] ;
    [titleLabel_1 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel_1 setBackgroundColor:[UIColor clearColor]];
    [titleLabel_1 setTextColor:[UIColor whiteColor]];
    [titleLabel_1 setFont:[UIFont fontWithName:Zhiti size: 17]];
    [titleLabel_1 setText:title];
    [self.view addSubview:titleLabel_1];
    
    if (str.length==2) {
        titleLabel_2  = [[UILabel alloc]initWithFrame:CGRectMake(168, 9+self.num, 50, 25)] ;
    }else{
        
        titleLabel_2  = [[UILabel alloc]initWithFrame:CGRectMake(168, 9+self.num, 65, 25)] ;
    }
    
    [titleLabel_2 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel_2 setBackgroundColor:[UIColor clearColor]];
    [titleLabel_2 setTextColor:[UIColor whiteColor]];
    [titleLabel_2 setFont:[UIFont fontWithName:Zhiti size: 15]];
    [titleLabel_2 setText:str];
    titleLabel_2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel_2];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
     
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"首页"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"首页"];
}

- (void)dealloc{
    if (_netWorkQueue) {
        _netWorkQueue.delegate = nil;
        [_netWorkQueue cancelAllOperations];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configHeadView];
    
    [self initData];
    
    //搜索和订阅按钮
    FlatButton *searchAndReadBtn = [[FlatButton alloc] initWithFrame:CGRectMake(10,70+num,147.5,185) withBackgroundColor:RGBA(12, 190, 186, 1)];
    if (iPhone_5Screen){
        searchAndReadBtn.frame = CGRectMake(10,80+num,147.5,215);
    }
    searchAndReadBtn.tag = 100;
    [searchAndReadBtn addText:@"订阅·搜索" AndImage:[UIImage imageNamed:@"homeImage1.png"]
                      AndRect:CGRectMake(7,5,100,30) AndRect2:CGRectMake(42,60,60,60)];
    [searchAndReadBtn addTarget:self action:@selector(pushToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchAndReadBtn];

    //新增职位按钮
    FlatButton *newPositionBtn = [[FlatButton alloc] initWithFrame:CGRectMake(162.5,70+num,147.5,90) withBackgroundColor:RGBA(132, 208, 24, 1)];
    if (iPhone_5Screen){
        newPositionBtn.frame = CGRectMake(162.5,80+num,147.5,105);
    }
    newPositionBtn.tag =101;
    [newPositionBtn addText:@"新增职位" AndImage:[UIImage imageNamed:@"homeImage2.png"] AndRect:CGRectMake(7,5,100,30) AndRect2:CGRectMake(43,30,60,60)];
    [newPositionBtn addTarget:self action:@selector(pushToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newPositionBtn];
    
    //入职奖金按钮
    FlatButton *zhangxinBtn = [[FlatButton alloc] initWithFrame:CGRectMake(162.5,165+num,147.5,90) withBackgroundColor:RGBA(255, 163, 29, 1)];
    if (iPhone_5Screen) {
       zhangxinBtn.frame = CGRectMake(162.5,190+num,147.5,105);
    }
    zhangxinBtn.tag = 102;
    [zhangxinBtn addText:@"人才增值收益权" AndImage:[UIImage imageNamed:@"homeImage8.png"] AndRect:CGRectMake(7,5,120,30) AndRect2:CGRectMake(40,30,60,60)];
    [zhangxinBtn addTarget:self action:@selector(pushToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhangxinBtn];
    
    //简历中心按钮
    FlatButton *resumeCenterBtn = [[FlatButton alloc] initWithFrame:CGRectMake(10,200+60+num,300,90) withBackgroundColor:RGBA(53, 170, 231, 1)];
    if (iPhone_5Screen) {
        resumeCenterBtn.frame = CGRectMake(10,220+80+num,300,105);
    }
    resumeCenterBtn.tag = 103;
    [resumeCenterBtn addText:@"简历中心" AndImage:[UIImage imageNamed:@"homeImage4.png"] AndRect:CGRectMake(7,5,100,30) AndRect2:CGRectMake(117,15,60,60)];
    [resumeCenterBtn addTarget:self action:@selector(pushToLogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:resumeCenterBtn];
    
    //才币按钮
//    FlatButton *caibiBtn = [[FlatButton alloc] initWithFrame:CGRectMake(10,185+80+90+num,96.66,80) withBackgroundColor:RGBA(243, 182, 19, 1)];
//    if (iPhone_5Screen) {
//       caibiBtn.frame = CGRectMake(10, 240+65+105+num, 96.666, 80);
//    }
//    caibiBtn.tag=104;
//    [caibiBtn addText:@"赚才币" AndImage:[UIImage imageNamed:@"homeImage3.png"] AndRect:CGRectMake(25,3
//                                                                                                ,100,30) AndRect2:CGRectMake(16,20,55,55)];
//    [caibiBtn addTarget:self action:@selector(pushToLogin:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:caibiBtn];
    
    //申请私信按钮
    FlatButton *messageBtn = [[FlatButton alloc] initWithFrame:CGRectMake(10,185+80+90+num,147.5,80) withBackgroundColor:RGBA(252, 83, 102, 1)];
    if (iPhone_5Screen) {
        messageBtn.frame = CGRectMake(10,240+65+105+num,147.5,80);
    }
    messageBtn.tag = 105;
    [messageBtn addText:@"申请·私信" AndImage:[UIImage imageNamed:@"homeImage6.png"] AndRect:CGRectMake(7,3,100,30) AndRect2:CGRectMake(45,17,60,60)];
    [messageBtn addTarget:self action:@selector(pushToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBtn];
    
    //职位大数据按钮
    FlatButton *bigDataBtn = [[FlatButton alloc] initWithFrame:CGRectMake(147.5+15,185+80+90+num,147.5,80) withBackgroundColor:RGBA(103, 140, 225, 1)];
    if (iPhone_5Screen) {
        bigDataBtn.frame = CGRectMake(147.5+15,240+65+105+num,147.5,80);
    }
    bigDataBtn.tag=106;
    [bigDataBtn addText:@"职位大数据" AndImage:[UIImage imageNamed:@"homeImage7.png"] AndRect:CGRectMake(7,3,100,30) AndRect2:CGRectMake(40,17,60,60)];
    [bigDataBtn addTarget:self action:@selector(pushToNOLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bigDataBtn];
    
    cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    cityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    cityBtn.frame = CGRectMake(105, 6+num, 115, 31);
    [cityBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cityBtn addTarget:self action:@selector(selectCity:) forControlEvents:UIControlEventTouchUpInside];
    
//    CityInfo *cityInfo = [CityInfo standerDefault];
//    cityInfo.cityName = @"青岛";
//    cityInfo.cityCode = @"2012";
//    cityInfo.com_num=@"65044";
//    cityInfo.source=@"51";
//    cityInfo.sourceAll=@"11,8,4,18,10";
    
    
//    if(cityInfo.cityName.length>3){
//        
//        cityStr = [cityInfo.cityName substringToIndex:3];
//        
//        cityBtn.frame = CGRectMake(105, 6+num, 120, 31);
//        
//    }else{
//        
//        cityStr=cityInfo.cityName;
//    }
    
    if(![userDefaults valueForKey:@"DingweiCity"]){
        [self startLocation];//开始定位当前城市
    }
    
    if (![[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"LoginNew"]] isEqualToString:@"0"]) {
        cityStr = @"未登录";
        cityBtn.frame = CGRectMake(105, 6+num, 120, 31);
    }else{
        XZLLocaRead *read = [[XZLLocaRead alloc] init];
        cityStr = [userDefaults objectForKey:@"DingweiCity"];
        CityInfo *cityInfo = [CityInfo standerDefault];
        cityInfo.cityName = cityStr;
        cityInfo.cityCode = [read getCodeNameStr:cityStr];
        cityInfo.com_num=@"65044";
        cityInfo.source=@"51";
        cityInfo.sourceAll=@"11,8,4,18,10";

        if(cityStr.length>3){
            cityStr = [cityStr substringToIndex:3];
            cityBtn.frame = CGRectMake(105, 6+num, 120, 31);
        }
    }
//
    [self.view addSubview:cityBtn];
    
    [self addHomeTitleLabel:@"小职了·" secTitle:cityStr];   //设置显示城市的位置和文字
    
    //更多按钮
    UIButton *moreBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(282,11+num, 20, 20);
    [moreBtn addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setBackgroundImage:[UIImage imageNamed:@"NaviBar_Icon_Setting.png"] forState:UIControlStateNormal];
    [self.view addSubview:moreBtn];
    
    UIButton *moreBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn2.frame = CGRectMake(iPhone_width-70,0,70,44+num);
    moreBtn2.backgroundColor=[UIColor clearColor];
    [moreBtn2 addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn2];
    
    //小职了按钮
    UIButton *iconBtn  =[UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn.frame = CGRectMake(15,5+num,20,33);
    [iconBtn addTarget:self action:@selector(comeBack:) forControlEvents:UIControlEventTouchUpInside];
    [iconBtn setBackgroundImage:[UIImage imageNamed:@"icon-title02.png"] forState:UIControlStateNormal];
    [self.view addSubview:iconBtn];
    
    UIButton *iconBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    iconBtn2.frame = CGRectMake(0,0,70,44+num);
    iconBtn2.backgroundColor=[UIColor clearColor];
    [iconBtn2 addTarget:self action:@selector(comeBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:iconBtn2];
    
    positionBigDataBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    positionBigDataBtn.alpha=0;
    positionBigDataBtn.userInteractionEnabled=NO;
    [bigDataBtn addSubview:positionBigDataBtn];
    
    readCountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    readCountBtn.alpha=0;
    readCountBtn.userInteractionEnabled=NO;
    [newPositionBtn addSubview:readCountBtn];
    
    sixinCountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sixinCountBtn.alpha=1;
    sixinCountBtn.userInteractionEnabled=NO;
    [messageBtn addSubview:sixinCountBtn];
    [self setSiXinCount];
    
    //得到所有详细订阅器
    [self performSelector:@selector(jiancegengxin:) withObject:self afterDelay:40];
    
    //接受来自登录界面的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadReader) name:@"toHomeVCFromLoginVC" object:nil];
    
    //每日新增职位提醒界面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addReaderView) name:@"toHomeVCFromApp" object:nil];
    
    //添加重设私信未读数响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetSiXinCount:) name:@"ResetSiXinCount" object:nil];
    
    //添加重设私信未读数响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetJobSeeCount:) name:@"ResetJobSeeCount" object:nil];
    
    NSArray *array=[db getAllRecords];
    
    NSInteger countNum=0;
    
    for (int i=0;i<[array count];i++) {
        JobModel *model=[array objectAtIndex:i];
        countNum=countNum+model.todayData.integerValue;
    }
    
    NSString *countStr=[NSString stringWithFormat:@"%d",countNum];
    
    [self setJobSee:countStr];

}

#pragma mark 通知中心响应方法

-(void)resetJobSeeCount:(NSNotification *)noti{
    [self setJobSee:@"0"];
}

-(void)resetSiXinCount:(NSNotification *)noti{
    
    NSString *logout = [NSString stringWithFormat:@"%@",[noti.userInfo valueForKey:@"logout"]];
    if ([logout isEqualToString:@"logout"]) {
        
        sixinCountBtn.alpha=0;
        
    }else{
        
        [self setSiXinCount];
    }
}


//响应来自通知中心的方法,只有在登录成功之后才会调用该方法
- (void)downloadReader
{
    if (![userDefaults valueForKey:@"DingweiCity"]) {
        NSLog(@"downloadReader:当前无定位城市，暂不获取");
        return;
    }
    [userDefaults setObject:@"0" forKey:@"download"];
    
    [userDefaults synchronize];
    
    /*
     1.首先清空一下数据库，清除xzhiljob表中的所有数据
     2.判断网络，如果有网络再下载，否则
     */
    
    [db deleteRecordAll];
    
//    if (!_netWorkQueue) {
//       _netWorkQueue=[[ASINetworkQueue alloc]init];
//    }
//    
//    [_netWorkQueue cancelAllOperations];
//    _netWorkQueue.delegate=self;
//    _netWorkQueue.maxConcurrentOperationCount=4;
//    [_netWorkQueue setShouldCancelAllRequestsOnFailure:NO];
//
//    [_netWorkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
//    [_netWorkQueue setRequestDidFailSelector:@selector(requestFailed:)];
//    [_netWorkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
    
    //下载职位数据接口
//    NSString *url=kCombineURL(KXZhiLiaoAPI,kBookerShow);
//    
//    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
//                            
//                            IMEI,@"userImei",kUserTokenStr,@"userToken",
//                            
//                            @"3",@"flag",nil];
//
//    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
//    
//    ASIHTTPRequest *request1=[ASIHTTPRequest requestWithURL:URL];
//    [request1 setTimeOutSeconds:100];
//    request1.tag=1;
//    [_netWorkQueue addOperation:request1];
    [self downloadBooker];
    
    
    NSString *deviceToken=[userDefaults valueForKey:@"deviceToken"];
    NSLog(@"deviceToken is %@",deviceToken);
    
    //将deviceToken接口传送给服务器
//    NSString *url2 = kCombineURL(KXZhiLiaoAPI, kIosToken);
//    NSDictionary *paramDic2 = [NSDictionary dictionaryWithObjectsAndKeys:deviceToken,@"pushToken",IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
//    
//    NSURL *URL2=[NetWorkConnection dictionaryBecomeUrl:paramDic2 urlString:url2];
//    
//    ASIHTTPRequest *request2=[ASIHTTPRequest requestWithURL:URL2];
//    [request2 setTimeOutSeconds:15];
//    request2.tag=2;
//    [_netWorkQueue addOperation:request2];
    
    [self uploadDeviceTooken];
    
    //得到职位大数据的每日新增职位
//    NSString *url3=kCombineURL(KXZhiLiaoAPI, kNewGetNew);
//    CityInfo *cityInfo=[CityInfo standerDefault];
//    NSDictionary *paramDic3=[NSDictionary dictionaryWithObjectsAndKeys:cityInfo.cityCode,@"localcity", nil];
//    NSURL *URL3=[NetWorkConnection dictionaryBecomeUrl:paramDic3 urlString:url3];
//    ASIHTTPRequest *request3=[ASIHTTPRequest requestWithURL:URL3];
//    [request3 setTimeOutSeconds:15];
//    request3.tag=3;
//    [_netWorkQueue addOperation:request3];
//    
//    [_netWorkQueue go];
    [self getPositionBigData];
}

-(void)downloadBooker{
    [db deleteRecordAll];
    
    NSString *url=kCombineURL(KXZhiLiaoAPI,kBookerShow);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            
                            IMEI,@"userImei",kUserTokenStr,@"userToken",
                            
                            @"3",@"flag",nil];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    
    ASIHTTPRequest *_request=[ASIHTTPRequest requestWithURL:URL];
    
    [_request setTimeOutSeconds:60];
    
    [_request setCompletionBlock:^(){
        
        NSLog(@"职位下载成功。。。。。。。");
        
        NSMutableArray *resultArray=[NSJSONSerialization JSONObjectWithData:_request.responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSString *data = [[NSString alloc] initWithData:_request.responseData encoding:NSUTF8StringEncoding];
        
        if ([data isEqualToString:@"please login"]) {
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
        }
        
        //查看数据库中取出的数据，然后将所有订阅的城市找出来。
        //将订阅城市找出来之后，再得到每个订阅器相应的详细订阅器的个数。
        //将得到的数据存储在bookCityDic中，这样就可以。
        
        /**首次登录应该首先将数据下载后存放到数据库中**/
        for (int i=0;i<[resultArray count];i++){
            
            JobModel *model=[[JobModel alloc]init];
            NSDictionary *resultDic=[resultArray objectAtIndex:i];
            model.bookID=[resultDic valueForKey:@"bookId"];
            model.positionName=[resultDic valueForKey:@"bookPostName"];
            
            //除了详细订阅之外，其他订阅方式是没有bookIndustryName的
            if ([resultDic valueForKey:@"bookIndustryName"]){
                
                NSString *industry=[resultDic valueForKey:@"bookIndustryName"];
                
                if ([industry isEqualToString:@"所有行业"]) {
                    industry=@"不限";
                }
                
                model.industry=industry;
                
            }else{
                model.industry=@"";
            }
            
            model.flag=[resultDic valueForKey:@"flag"];
            model.cityStr=[resultDic valueForKey:@"bookLocationName"];
            model.cityCodeStr=[resultDic valueForKey:@"bookLocation"];
            model.todayData=[resultDic valueForKey:@"bookTodayData"];
            model.totalData=[resultDic valueForKey:@"bookTotalData"];
            
            if ([resultDic valueForKey:@"bookKeyword"]) {
                model.keyWord=[resultDic valueForKey:@"bookKeyword"];
            }else
            {
                model.keyWord=@"";
            }
            
            [db addOneRecord:model];
        }
        
        /***查询当前账号已经订阅了哪几个城市***/
        NSArray *bookCityArray=[db getAllCityRecords];
        
        NSMutableDictionary *bookCityDic=[[NSMutableDictionary alloc]init];
        
        for (int i=0;i<[bookCityArray count];i++) {
            JobModel *model =[bookCityArray objectAtIndex:i];
            NSString *bookCity=model.cityStr;
            NSNumber *number=[NSNumber numberWithInteger:0];
            [bookCityDic setObject:number forKey:bookCity];
        }
        
        [userDefaults setObject:bookCityDic forKey:@"bookCity"];
        [userDefaults synchronize];
        
        //bookCityDic主要有两个作用，键是记录订阅了哪个城市，值用来记录每个城市详细订阅的个数
        NSLog(@"bookCityDic is %@",bookCityDic);
        
        //detailReaderArray是存放详细订阅器。
        NSArray *detailReaderArray=[db getAllRecords:@"0"];
        
        //得到一个所有订阅城市的数组
        NSArray *allBookCityArray=[bookCityDic allKeys];
        
        for (int i=0;i<[detailReaderArray count];i++)
        {
            JobModel *model=[detailReaderArray objectAtIndex:i];
            
            for (int j=0; j<[allBookCityArray count];j++) {
                
                NSString *bookCityStr=[allBookCityArray objectAtIndex:j];
                if([model.cityStr isEqualToString:bookCityStr]) {
                    
                    // 从字典中取出这个键对应的值，在值上相应的加一
                    NSNumber *number=[bookCityDic  valueForKey:bookCityStr];
                    NSInteger count=[number integerValue]+1;
                    NSNumber *number2=[NSNumber numberWithInteger:count];
                    [bookCityDic setObject:number2 forKey:bookCityStr];
                }
            }
        }
        
        //主要是改变bookCityDic的值
        [userDefaults setObject:bookCityDic forKey:@"bookCity"];
        [userDefaults synchronize];
        NSLog(@"bookCityDic2 is %@",bookCityDic);
        
        
        NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
        NSLog(@"bookCityDic3 is %@",dic);
        
        
        //当订阅器下载完成之后，应该将download中的值由0变为1
        [userDefaults setObject:@"1" forKey:@"download"];
        
        [userDefaults synchronize];
        
        //kuaijieNum用来记录当前快捷订阅的订阅器个数
        NSArray *kuaijieArray=[db getAllRecords:@"2"];
        NSInteger count=[kuaijieArray count];
        NSLog(@"kuaijie count is %d",count);
        NSNumber *number=[NSNumber numberWithInteger:count];
        [userDefaults setObject:number forKey:@"kuaijieNum"];
        
        //jianzhiNum用来记录当前兼职订阅的订阅器个数
        NSArray *jianzhiArray=[db getAllRecords:@"5"];
        NSInteger count2=[jianzhiArray count];
        NSLog(@"jianzhi count is %d",count2);
        NSNumber *number2=[NSNumber numberWithInteger:count2];
        [userDefaults setObject:number2 forKey:@"jianzhiNum"];
        [userDefaults synchronize];
    }];
    
    [_request setFailedBlock:^(){
        NSLog(@"下载失败。。。。。。");
    }];
    
    [_request startAsynchronous];
}

-(void)uploadDeviceTooken{
    NSString *deviceToken=[userDefaults valueForKey:@"deviceToken"];
    NSLog(@"deviceToken is %@",deviceToken);
    
    //将deviceToken接口传送给服务器
    NSString *url = kCombineURL(KXZhiLiaoAPI, kIosToken);
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:deviceToken,@"pushToken",IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    
    ASIHTTPRequest *_request=[ASIHTTPRequest requestWithURL:URL];
    
    [_request setTimeOutSeconds:60];
    
    [_request setCompletionBlock:^(){
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:_request.responseData options:kNilOptions error:nil];
        NSString *errorStr=[resultDic valueForKey:@"error"];
        
        if (errorStr&&errorStr.integerValue==0) {
            NSLog(@"deviceToken传送成功");
        }
        
    }];
    
    [_request setFailedBlock:^(){
        NSLog(@"上传deviceToken失败。。。。。。");
    }];
    
    [_request startAsynchronous];
}

-(void)getPositionBigData{
    NSString *url=kCombineURL(KXZhiLiaoAPI, kNewGetNew);
    CityInfo *cityInfo=[CityInfo standerDefault];
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:cityInfo.cityCode,@"localcity", nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];

    
    ASIHTTPRequest *_request=[ASIHTTPRequest requestWithURL:URL];
    
    [_request setTimeOutSeconds:60];
    
    [_request setCompletionBlock:^(){
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:_request.responseData options:kNilOptions error:nil];
        NSString *todayCount=[NSString stringWithFormat:@"%@",[resultDic valueForKey:@"todayCount"]];
        
        NSLog(@"todayCount is %@",todayCount);
        
        [self setBigData:todayCount];
        
    }];
    
    [_request setFailedBlock:^(){
        NSLog(@"获取职位大数据失败。。。。。。");
    }];
    
    [_request startAsynchronous];
}




#pragma netWorkQueue方法的实现

//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSData *receData=[request responseData];
//    
//    NSError *error;
//    
//    if (request.tag==1) {
//        
//        NSLog(@"职位下载成功。。。。。。。");
//        
//        NSMutableArray *resultArray=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:&error];
//        
//        NSString *data = [[NSString alloc] initWithData:receData encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"data is %@",data);
//        
//        if ([data isEqualToString:@"please login"]) {
//            OtherLogin *other = [OtherLogin standerDefault];
//            [other otherAreaLogin];
//            return;
//        }
//        
//        //查看数据库中取出的数据，然后将所有订阅的城市找出来。
//        //将订阅城市找出来之后，再得到每个订阅器相应的详细订阅器的个数。
//        //将得到的数据存储在bookCityDic中，这样就可以。
//        
//        [db deleteRecordAll];
//        
//        /**首次登录应该首先将数据下载后存放到数据库中**/
//        
//        for (int i=0;i<[resultArray count];i++){
//            
//            JobModel *model=[[JobModel alloc]init];
//            
//            NSDictionary *resultDic=[resultArray objectAtIndex:i];
//            
//            model.bookID=[resultDic valueForKey:@"bookId"];
//            
//            //除了详细订阅之外，其他订阅方式是没有bookIndustryName的
//            
//            if ([resultDic valueForKey:@"bookPostName"]){
//                
//                NSString *positionNameStr=[resultDic valueForKey:@"bookPostName"];
//                
//                if ([positionNameStr isEqualToString:@""]) {
//                    positionNameStr=@"不限";
//                }
//                
//                model.positionName=positionNameStr;
//                
//            }else{
//                
//                model.positionName=@"不限";
//            }
//            
//            //除了详细订阅之外，其他订阅方式是没有bookIndustryName的
//            if ([resultDic valueForKey:@"bookIndustryName"]){
//                
//                NSString *industry=[resultDic valueForKey:@"bookIndustryName"];
//                
//                if ([industry isEqualToString:@"所有行业"]||[industry isEqualToString:@""]) {
//                    industry=@"不限";
//                }
//                
//                model.industry=industry;
//                
//            }else{
//                model.industry=@"不限";
//            }
//            
//            model.flag=[resultDic valueForKey:@"flag"];
//            model.cityStr=[resultDic valueForKey:@"bookLocationName"];
//            model.cityCodeStr=[resultDic valueForKey:@"bookLocation"];
//            model.todayData=[resultDic valueForKey:@"bookTodayData"];
//            model.totalData=[resultDic valueForKey:@"bookTotalData"];
//            
//            if ([resultDic valueForKey:@"bookKeyword"]) {
//             
//                model.keyWord=[resultDic valueForKey:@"bookKeyword"];
//            }else
//            {
//                model.keyWord=@"";
//            }
//            
//            [db addOneRecord:model];
//        }
//        
//        NSArray *array=[db getAllRecords];
//        
//        NSInteger countNum=0;
//        
//        for (int i=0;i<[array count];i++) {
//            
//            JobModel *model=[array objectAtIndex:i];
//            
//            countNum=countNum+model.todayData.integerValue;
//        }
//        
//        NSString *countStr=[NSString stringWithFormat:@"%d",countNum];
//        
//        [self setJobSee:countStr];
//        
//        /***查询当前账号已经订阅了哪几个城市***/
//        NSArray *bookCityArray=[db getAllCityRecords];
//        
//        NSMutableDictionary *bookCityDic=[[NSMutableDictionary alloc]init];
//        
//        for (int i=0;i<[bookCityArray count];i++) {
//            JobModel *model =[bookCityArray objectAtIndex:i];
//            NSString *bookCity=model.cityStr;
//            NSNumber *number=[NSNumber numberWithInteger:0];
//            [bookCityDic setObject:number forKey:bookCity];
//        }
//        
//        [userDefaults setObject:bookCityDic forKey:@"bookCity"];
//        [userDefaults synchronize];
//        
//        //bookCityDic主要有两个作用，键是记录订阅了哪个城市，值用来记录每个城市详细订阅的个数
//        NSLog(@"bookCityDic is %@",bookCityDic);
//        
//        //detailReaderArray是存放详细订阅器。
//        NSArray *detailReaderArray=[db getAllRecords:@"0"];
//        
//        //得到一个所有订阅城市的数组
//        NSArray *allBookCityArray=[bookCityDic allKeys];
//        
//        for (int i=0;i<[detailReaderArray count];i++)
//        {
//            JobModel *model=[detailReaderArray objectAtIndex:i];
//            
//            for (int j=0; j<[allBookCityArray count];j++) {
//                
//                NSString *bookCityStr=[allBookCityArray objectAtIndex:j];
//                if([model.cityStr isEqualToString:bookCityStr]) {
//                    
//                    // 从字典中取出这个键对应的值，在值上相应的加一
//                    NSNumber *number=[bookCityDic  valueForKey:bookCityStr];
//                    NSInteger count=[number integerValue]+1;
//                    NSNumber *number2=[NSNumber numberWithInteger:count];
//                    [bookCityDic setObject:number2 forKey:bookCityStr];
//                }
//            }
//        }
//        
//        //主要是改变bookCityDic的值
//        [userDefaults setObject:bookCityDic forKey:@"bookCity"];
//        [userDefaults synchronize];
//        NSLog(@"bookCityDic2 is %@",bookCityDic);
//        
//        NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
//        NSLog(@"bookCityDic3 is %@",dic);
//    
//        //当订阅器下载完成之后，应该将download中的值由0变为1
//        [userDefaults setObject:@"1" forKey:@"download"];
//        [userDefaults synchronize];
//        
//        //kuaijieNum用来记录当前快捷订阅的订阅器个数
//        NSArray *kuaijieArray=[db getAllRecords:@"2"];
//        NSInteger count=[kuaijieArray count];
//        NSLog(@"kuaijie count is %d",count);
//        NSNumber *number=[NSNumber numberWithInteger:count];
//        [userDefaults setObject:number forKey:@"kuaijieNum"];
//        
//        //jianzhiNum用来记录当前兼职订阅的订阅器个数
//        NSArray *jianzhiArray=[db getAllRecords:@"5"];
//        NSInteger count2=[jianzhiArray count];
//        NSLog(@"jianzhi count is %d",count2);
//        NSNumber *number2=[NSNumber numberWithInteger:count2];
//        [userDefaults setObject:number2 forKey:@"jianzhiNum"];
//        [userDefaults synchronize];
//        
//    }else if (request.tag==2)
//    {
//        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:&error];
//        
//        NSString *errorStr=[resultDic valueForKey:@"error"];
//        
//        if (errorStr&&errorStr.integerValue==0) {
//            NSLog(@"deviceToken传送成功");
//        }
//    }else if (request.tag==3)
//    {
//        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:&error];
//        
//        NSString *todayCount=[resultDic valueForKey:@"todayCount"];
//        
//        NSLog(@"todayCount is %@",todayCount);
//        
//        [self  setBigData:todayCount];
//    }
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"requestFailed下载失败..........");
//    
//    NSError *error=[request error];
//    
//    if (request.tag==1) {
//        NSLog(@"error in request.tag==1 %@",[error localizedDescription]);
//    }else if (request.tag==2)
//    {
//        NSLog(@"error in request.tag==2 %@",[error localizedDescription]);
//    }
//    
//}
//
//-(void)queueFinished:(ASIHTTPRequest *)request
//{
//    NSLog(@"queueFinished下载完成。。。。。。。");
//}

#pragma mark 出现订阅器界面
-(void)addReaderView
{
    NewReadView *v=(NewReadView *)[self.view viewWithTag:10000];
    
    [v removeFromSuperview];
    
    NewReadView *readView=[[NewReadView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,self.view.frame.size.height)];
    readView.tag=10000;
    readView.delegate=self;
    [self.view addSubview:readView];
    
    NSLog(@"出现显示职位的界面");
}


//检测是否有最新版本
- (void)jiancegengxin:(id)sender
{
    MoreViewController *more = [[MoreViewController alloc] init];
    [more upDatebb01:NO];
}

#pragma mark viewAppear代理方法实现

- (void)viewWillAppear:(BOOL)animated
{
    //获取审核更新状态
    [[NSNotificationCenter defaultCenter]postNotificationName:@"AppStoreCheck" object:@1];

    if (![[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"LoginNew"]] isEqualToString:@"0"]) {
        cityStr = @"未登录";
        cityBtn.frame = CGRectMake(105, 6+num, 120, 31);
        titleLabel_2.text = cityStr;
        return;
    }else{
        XZLLocaRead *read = [[XZLLocaRead alloc] init];
        cityStr = [userDefaults objectForKey:@"DingweiCity"];
        CityInfo *cityInfo = [CityInfo standerDefault];
        cityInfo.cityName = cityStr;
        cityInfo.cityCode = [read getCodeNameStr:cityStr];
        cityInfo.com_num=@"65044";
        cityInfo.source=@"51";
        cityInfo.sourceAll=@"11,8,4,18,10";
        
        if(cityStr.length>3){
            cityStr = [cityStr substringToIndex:3];
            cityBtn.frame = CGRectMake(105, 6+num, 120, 31);
        }
    }


    titleLabel_2.text = cityStr;
    
//    NSArray *array=[db getAllRecords];
//    
//    NSInteger countNum=0;
//    
//    for (int i=0;i<[array count];i++) {
//        JobModel *model=[array objectAtIndex:i];
//        countNum=countNum+model.todayData.integerValue;
//    }
//    
//    NSString *countStr=[NSString stringWithFormat:@"%d",countNum];
//    
//    [self setJobSee:countStr];
    
    //NSLog(@"viewWillAppear  in HomeVC............");
}

- (NSInteger)widthWithString:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize size = [str sizeWithFont:font];
    return size.width;
}

- (void)selectCity:(id)sender
{
    if (![[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"LoginNew"]] isEqualToString:@"0"]) {
        return;
    }
    
    allCityViewController *allCity = [[allCityViewController alloc]init];
    allCity.delegate=self;
    allCity.fromWhereStr=@"HomeVC";
    [self.navigationController pushViewController:allCity animated:YES];
}

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName
{
    cityStr = cityName;
    [mUserDefaults setValue:cityName forKey:@"DingweiCity"];
    
    NSString *url=kCombineURL(KXZhiLiaoAPI, kNewGetNew);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:cityCode,@"localcity", nil];
    
//    NetWorkConnection *net=[[NetWorkConnection alloc]init];
//    net.delegate=self;
//    
//    [net requestCache:url param:paramDic];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        //        NSLog(@"简历列表下载成功");
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        
        NSString *todayCount=[resultDic valueForKey:@"todayCount"];
        
        NSLog(@"todayCount is %@",todayCount);
        
        [self  setBigData:todayCount];
    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
        ghostView.message=@"网络请求失败";
        [ghostView show];
        
    }];
    [request startAsynchronous];

}

-(void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *todayCount=[resultDic valueForKey:@"todayCount"];
    
    NSLog(@"todayCount is %@",todayCount);
    
    [self  setBigData:todayCount];
}

-(void)receiveRequestFail:(NSError *)error
{
    NSLog(@"receiveRequestFail失败。。。。。");
}

- (void)comeBack:(id)sender
{
    AboutWeViewController *aboutWeVC=[[AboutWeViewController alloc]init];
    [self.navigationController pushViewController:aboutWeVC animated:YES];
}

#pragma mark 按钮点击事件响应方法

- (void)pushToLogin:(id)sender
{
    /*
     1.判断一下是否正在登录状态下
     
     2.如果在登录状态下，就可以进入各界面内部，否则进入登录界面
     */
    
    UIButton *btn = (UIButton *)sender;
    
    //入职奖金不用判断是否已登录
    if (btn.tag == 102)//入职奖金
    {
        NSLog(@"进入入职奖金界面。。。。。。。。。。。。。。。。。。");
        SeniorJobListViewController *main = [[SeniorJobListViewController alloc] init];
//        SeniorJobRightViewController *right = [[SeniorJobRightViewController alloc] init];
//        ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithRightViewController:right
//                                                                          centerViewController:main];
//        [self.navigationController pushViewController:drawer animated:YES];
        [self.navigationController pushViewController:main animated:YES];
        return;
        
    }
    
    
    if ([self judgmentLogin])
    {
        if(btn.tag == 100)//搜索/订阅
        {
            
           //每次进入ReaderVC之前，都先清理一下
            SaveJob *save=[SaveJob standardDefault];
            [save clearTheCache];
            
            ReaderViewController *readVC=[[ReaderViewController alloc]init];
            [self.navigationController pushViewController:readVC animated:YES];
        }
        else if(btn.tag == 101)//职位查看
        {
            
            //点击职位查看按钮的时候先判断之前有没有订阅职位，如果没有订阅职位就先进入只为订阅界面
            NSArray *arr=[db getAllRecords];
            NSString *str=[userDefaults valueForKey:@"download"];
            
            if ([arr count]==0&&str.integerValue==1) //下载完成但是没有订阅器
            {
                ghostView.message=@"先订阅才能查看职位";
                [ghostView show];
                
                ReaderViewController *readVC=[[ReaderViewController alloc]init];
                [self.navigationController pushViewController:readVC animated:YES];

            }else if ([arr count]>0&&str.integerValue==1) //下载完成且有订阅器
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ResetJobSeeCount" object:nil];
                JobSeeViewController *jobSeeVC = [[JobSeeViewController alloc]init];
                jobSeeVC.enterItem = jobReadEnterHome;
                [self.navigationController pushViewController:jobSeeVC animated:YES];
            }else if ([arr count]==0&&str.integerValue==0)//下载失败或者正在下载中
            {
                ghostView.message=@"先订阅才能查看职位";
                [ghostView show];
                
                ReaderViewController *readVC=[[ReaderViewController alloc]init];
                [self.navigationController pushViewController:readVC animated:YES];
            }
        }
        else if (btn.tag == 102)//人才增值收益权
        {
            NSLog(@"进入人才增值收益权。。。。。。。。。。。。。。。。。。");
            WebViewController *webview = [[WebViewController alloc] init];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@userImei=%@&userToken=%@",KXZhiLiaoAPI,@"new_api/senior/senior_about?",IMEI,[userDefaults valueForKey:@"userToken"]];
            webview.urlStr = urlStr;
            [self.navigationController pushViewController:webview animated:YES];
            webview.floog = @"入职奖金";

        }
        else if (btn.tag == 103)//简历中心
        {
            jianliViewController *jianli = [[jianliViewController alloc]init];
            [self.navigationController pushViewController:jianli animated:YES];
        }else if (btn.tag == 105)//申请，私信
        {
            
            MessageListViewController *msgListVC = [[MessageListViewController alloc] init];
            msgListVC.isFromHr = NO;
            [self.navigationController pushViewController:msgListVC animated:YES];
        }
        else if (btn.tag == 106)//大数据
        {
            positionBigDataBtn.alpha=0;
            JobSourceViewController *sourceVC=[[JobSourceViewController alloc]init];
            [self.navigationController pushViewController:sourceVC animated:YES];
        }
    }
    else
    {
    }
}

//处于未登录状态下的时候只有全城招聘会模块是可以进入的

- (void)pushToNOLogin:(id)sender
{
    Net *n=[Net standerDefault];
    
    if (n.status !=NotReachable) {
    
        positionBigDataBtn.alpha=0;
        
        JobSourceViewController *sourceVC=[[JobSourceViewController alloc]init];
        
        [self.navigationController pushViewController:sourceVC animated:YES];
    }else
    {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
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

//进入更多界面
- (void)moreInfo:(id)sender
{
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

-(void)setBigData:(NSString *)titleStr
{
    
//    //设置bigbtn的alpha值
//    //字体
//    //大小，宽高
    positionBigDataBtn.alpha=1;
    
    CGFloat width = [self StringWidthWithStr:titleStr];
    
    NSLog(@"width in setBigData is %f",width);
    
    positionBigDataBtn.frame=CGRectMake(147.5-width-11,3,width+7,26);
    
    [positionBigDataBtn setTitle:titleStr forState:UIControlStateNormal];
    [positionBigDataBtn setTitle:titleStr forState:UIControlStateHighlighted];
    
    positionBigDataBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    UIImage *bubble = [UIImage imageNamed:@"readCount.png"];
    
    [positionBigDataBtn setBackgroundImage:bubble forState:UIControlStateNormal];
}

-(void)setJobSee:(NSString *)titleStr
{
    //设置bigbtn的alpha值
    //字体
    //大小，宽高
    
    NSString *loginStr=[userDefaults valueForKey:@"LoginNew"];
    
    if ([self judgmentLogin]&&titleStr.integerValue!=0) {
        readCountBtn.alpha=1;
    }else
    {
        readCountBtn.alpha=0;
    }
    
    CGFloat width = [self StringWidthWithStr:titleStr];
    
    //NSLog(@"width in setJobSee is %f",width);
    
    readCountBtn.frame=CGRectMake(147.5-width-11,3,width+7,26);
    
    [readCountBtn setTitle:titleStr forState:UIControlStateNormal];
    [readCountBtn setTitle:titleStr forState:UIControlStateHighlighted];
    
    readCountBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    UIImage *bubble = [UIImage imageNamed:@"readCount.png"];
    
    [readCountBtn setBackgroundImage:bubble forState:UIControlStateNormal];
}

-(void)setSiXinCount
{
    
    NSString *userUid = [NSString stringWithFormat:@"%@",[mUserDefaults valueForKey:@"userUid"]];
    NSDictionary *dic = [mUserDefaults valueForKey:@"SixinCount"];
    NSString * countStr = [dic valueForKey:userUid];
    if (countStr.length == 0) {
        countStr = @"0";
    }
    
    NSString *loginStr=[userDefaults valueForKey:@"LoginNew"];
    
    if (loginStr&&loginStr.integerValue==0&&countStr.integerValue!=0) {
        sixinCountBtn.alpha=1;
    }else
    {
        sixinCountBtn.alpha=0;
    }
    
    CGFloat width = [self StringWidthWithStr:countStr];
    
    
    
    sixinCountBtn.frame=CGRectMake(147.5-width-11,3,width+7,26);
    
    [sixinCountBtn setTitle:countStr forState:UIControlStateNormal];
    [sixinCountBtn setTitle:countStr forState:UIControlStateHighlighted];
    
    sixinCountBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    
    UIImage *bubble = [UIImage imageNamed:@"readCount.png"];
    
    [sixinCountBtn setBackgroundImage:bubble forState:UIControlStateNormal];
}


-(CGFloat)StringWidthWithStr:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:16];
    
    CGSize size = CGSizeMake(320, MAXFLOAT);
    
    CGSize expectedLabelSizeOne = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingMiddle];
    
    return expectedLabelSizeOne.width;
}

//NewReadView代理方法
-(void)readView:(JobModel *)model
{
    NSArray *cityArray=[db getAllRecords2:model.cityStr];
    
    NSLog(@"cityArray is %@",cityArray);
    
    City *city;
    
    if ([cityArray count]==0) {  //如果array为0，说明还没有加载数据，默认青岛
        
    }else
    {
        city=[cityArray objectAtIndex:0];
        CityInfo *cityInfo=[CityInfo standerDefault];
        cityInfo.cityName=model.cityStr;
        cityInfo.cityCode=model.cityCodeStr;
        cityInfo.source =city.sourceStr;
    }
    
    JobSeeViewController *jobSeeVC=[[JobSeeViewController alloc]init];
 
    if (model.flag.integerValue==0) {
        
        jobSeeVC.enterItem=jobReadEnterRead;
    }else if(model.flag.integerValue==1)
    {
        jobSeeVC.enterItem=jobReadEnterCompany;
    
    }else if(model.flag.integerValue==2)
    {
        jobSeeVC.enterItem=jobReadEnterFast;
    
    }else if (model.flag.integerValue==5)
    {
        jobSeeVC.enterItem=jobReadEnterJianzhi;
    }
    
    jobSeeVC.model=model;
    
    [self.navigationController pushViewController:jobSeeVC animated:YES];
}

#pragma mark - 定位
-(void)startLocation{
    //默认值
    CityInfo *cityInfo = [CityInfo standerDefault];
    cityInfo.cityName = @"青岛";
    cityInfo.cityCode = @"2012";
    [mUserDefaults setObject:@"青岛" forKey:@"DingweiCity"];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.labelText = @"正在定位当前城市...";
    
    if (![CLLocationManager locationServicesEnabled] )
    {
        ghostView.message = @"定位失败，请手动选择城市！";
        [ghostView show];
        loadView.hidden = YES;
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        ghostView.message =@"请允许使用你的地理位置！";
        [ghostView show];
        loadView.hidden = YES;
    }
    else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            //开启定位
            _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
            _locationManager.delegate=self;
            _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            _locationManager.distanceFilter=1000.0f;
            //启动位置更新
        }
        else
        {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            [_locationManager requestAlwaysAuthorization];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            //[_locationManager startUpdatingLocation];
        }
        [_locationManager startUpdatingLocation];
    }
    
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    loadView.hidden = YES;
    [_locationManager stopUpdatingLocation];
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f 纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    //_latitude = newLocation.coordinate.latitude;
    //_longitude = newLocation.coordinate.longitude;
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil &&[placemarks count] > 0) {
            for (CLPlacemark * placemark in placemarks) {
                ghostView.message = @"定位成功";
                [ghostView show];
                NSDictionary *test = [placemark addressDictionary];
                //  Country(国家)  State(省) City(城市)  SubLocality(区)
                cityStr = [test objectForKey:@"City"];
                cityStr = [cityStr substringToIndex:cityStr.length-1];
                XZLLocaRead *read = [[XZLLocaRead alloc] init];
                CityInfo *cityInfo = [CityInfo standerDefault];
                cityInfo.cityName = cityStr;
                cityInfo.cityCode = [read getCodeNameStr:cityStr];
                [mUserDefaults setObject:cityStr forKey:@"DingweiCity"];
                titleLabel_2.text = cityStr;
                if ([[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"LoginNew"]] isEqualToString:@"0"]) {
//                    [self downloadReader];
                }else{
                    titleLabel_2.text = @"未登录";
                }
                
                
            }
        }
        else if (error == nil &&
                 [placemarks count] == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}

// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    loadView.hidden = YES;
    ghostView.message = @"定位失败,默认为青岛,请检查网络并在设置中开启定位权限";
    [ghostView show];
    [mUserDefaults setObject:@"青岛" forKey:@"DingweiCity"];
    if ([[NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"LoginNew"]] isEqualToString:@"0"]) {
        [self downloadReader];
    }else{
        titleLabel_2.text = @"未登录";
    }
  
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
