//
//  ReaderViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-2-28.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "Company.h"
#import "GRReadModel.h"
#import "myButton.h"

#import "OtherLogin.h"
#import "CityInfo.h"
#import "UserDatabase.h"
#import "DetailView.h"

#import "HomeViewController.h"
#import "SearchViewController.h"
#import "ReaderViewController.h"
#import "JobSeeViewController.h"
#import "ScanningViewController.h"
#import "JobSourceViewController.h"
#import "GRSelectIndustryViewController.h"
#import "CompanyResultViewController.h"

#import "GRSelectSalaryViewController.h"


@interface ReaderViewController (){

    __block ASIHTTPRequest *_request;
    
}
@end

@implementation ReaderViewController

-(void)initData
{
    num=ios7jj;
    
    db=[UserDatabase sharedInstance];
    
    userDefaults=[NSUserDefaults  standardUserDefaults];
    
    save=[SaveJob standardDefault];
    
    cityInfo=[CityInfo standerDefault];
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    
    ghostView.position=OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor =XZhiL_colour2;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self){
        
    }
    
    return self;
}

#pragma mark viewDidLoad方法实现

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addBackBtnGR];

    [self addTitleLabelGR:@"职位订阅"];
    
    [self initData];

    rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height-64)];
    rootScrollView.backgroundColor=[UIColor clearColor];
    rootScrollView.bounces = NO;
    rootScrollView.delegate = self;
    rootScrollView.pagingEnabled =YES;
    rootScrollView.showsHorizontalScrollIndicator = NO;
    rootScrollView.showsVerticalScrollIndicator=NO;
    rootScrollView.contentSize = CGSizeMake(iPhone_width, iPhone_height-64);
    [self.view addSubview:rootScrollView];

    _detailView = nil;
    //添加详细订阅界面
    if (_detailView==nil) {
        _detailView=[[DetailView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-64)];
        _detailView.delegate=self;
        [rootScrollView addSubview:_detailView];
    }
    
   
    NSString *download=[userDefaults valueForKey:@"download"];
    
    //在登录的时候,判断订阅器数据是否下载成功
    if (download.integerValue==0){
//          [self netWorkConnection];
    }

    
    /*以下两个通知的作用是修改detailView中scrollView的高度*/
    
    //在订阅器界面的时候使用
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scanningViewChange:) name:@"toReaderView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scanningViewChange:) name:@"toReaderView2" object:nil];
}

- (void)dealloc{
    if (_request) {
        [_request clearDelegatesAndCancel];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位订阅"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位订阅"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark 搜索按钮响应事件
- (void)searchBtnClick
{
    /*目前还没有用到*/
    
    //进入SearchViewController之前首先清空一下SaveJob中的数据
    
    [save clearTheCache];
    
    [_detailView.tableView reloadData];
    
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark 城市按钮响应事件

#pragma mark -GRSelectSalaryDelegate薪资选择
-(void)onSelectSalary{
    [_detailView.tableView reloadData];
}

#pragma mark- GRSelectIndustryViewDelegate代理方法实现

-(void)onConfrimSelectIndustry
{
    NSLog(@"positonViewChange is OK!");
    [_detailView.tableView reloadData];
}

-(void)workDetailChange
{
    NSLog(@"[save jobStr] in workDetailChange and ReaderVC is %@", [save jobStr]);
    
    NSLog(@"workDetailChange is OK!");
    
    [_detailView.tableView reloadData];
}

#pragma mark JobNameViewController代理方法的实现

-(void)JobNameViewChange
{
    [_detailView.tableView reloadData];
}


/**通知中心响应方法，当详细订阅器删除或添加的时候，相应改变View的大小**/
- (void)scanningViewChange:(NSNotification *)notification
{
    NSDictionary *resultDic=[notification userInfo];
    
    NSNumber *number=[resultDic valueForKey:@"height"];
    
    NSInteger tableViewHeight=[number integerValue];
    
    NSLog(@"tableViewHeight is %d",tableViewHeight);
    
    dingyueListArray=(NSMutableArray *)[GRBookerModel findAll];
    
    _detailView.scrollView.contentSize=CGSizeMake(iPhone_width,369 +tableViewHeight);
    _detailView.readTV.frame=CGRectMake(0,369,iPhone_width,tableViewHeight);
    
    if ([dingyueListArray count]==0) {
        _detailView.readTV.alterBtn.alpha=0;
    }else{
        _detailView.readTV.alterBtn.alpha=1;
    }
}

#pragma mark allCityVC代理实现

- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName
{
    NSLog(@"cityName is %@",cityName);
    [_detailView.tableView reloadData];
}

- (void)sendWithSelect:(jobRead *)select Option:(NSString *)option
{
    NSLog(@"代理被实现了1。。。。。。%@",select.name);
    NSLog(@"代理被实现了2。。。。。。%@",select.code);
    NSLog(@"option in 代理。。。。。%@",option);
    
    
    //根据option判断是哪一个页面返回
    switch ([self optionWithStr:option]) {
        case JobSalary:
            [save.positionArr replaceObjectAtIndex:3 withObject:select];
            break;
        case JobNature:
            [save.positionArr replaceObjectAtIndex:4 withObject:select];
            break;
        default:
            break;
    }
    
    [_detailView.tableView reloadData];
}

- (JobItem)optionWithStr:(NSString *)name
{
    if ([name isEqualToString:@"地区"]) {
        return JobArea;
    }else if([name isEqualToString:@"行业"])
    {
        return JobAllWork;
    }else if([name isEqualToString:@"职位"])
    {
        return JobAllJob;
    }else if([name isEqualToString:@"待遇"])
    {
        return JobSalary;
    }else if([name isEqualToString:@"职位类型"])
    {
        return JobNature;
    }else
    {
        return jobNone;
    }
}

#pragma mark DetailView代理方法实现

- (void)detailViewChange:(NSString *)str andBOOL:(BOOL)isEmpty
{
    if ([str isEqualToString:@"1"]) {
        
        allCityViewController *allCityVC=[[allCityViewController alloc]init];
        allCityVC.delegate=self;
        CityInfo *cityInfo=[CityInfo standerDefault];
        allCityVC.city_selected = cityInfo.cityName;
        [self.navigationController pushViewController:allCityVC animated:YES];
        
    }else if([str isEqualToString:@"2"])
    {
        GRSelectIndustryViewController *industryVC = [[GRSelectIndustryViewController alloc]init];
        industryVC.delegate=self;
        [self.navigationController pushViewController:industryVC animated:YES];
    }else if([str isEqualToString:@"0"])
    {
        ScanningViewController *scanVC=[[ScanningViewController alloc]init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }else
    {
        GRSelectSalaryViewController *salary = [[GRSelectSalaryViewController alloc] init];
//        SelectDetailViewController *selectVC = [[SelectDetailViewController alloc]init];
        salary.delegate=self;
//        [salary setItemStr:str];
        [self.navigationController pushViewController:salary animated:YES];
    }
}

- (void)detailViewChange2:(GRBookerModel *)model
{
    
    NSLog(@"detailViewChange2代理实现了。。。。");
    
    NSLog(@"model.cityStr is %@",model.bookLocationName);
    
    NSArray *cityArray=[db getAllRecords2:model.bookLocationName];
    
    NSLog(@"cityArray is %@",cityArray);
    
    City *city;
    
    if ([cityArray count]==0) {  //如果array为0，说明还没有加载数据，默认青岛
        
    }else
    {
        city=[cityArray objectAtIndex:0];
        
        NSLog(@"city.sourceStr is %@",city.sourceStr);
        
        cityInfo.cityName=model.bookLocationName;
        cityInfo.cityCode=model.bookLocationCode;
        cityInfo.source =city.sourceStr;
    }
    
    JobSeeViewController *jobSeeVC=[[JobSeeViewController alloc]init];
    jobSeeVC.enterItem= jobReadEnterRead;
    jobSeeVC.model=model;
    [self.navigationController pushViewController:jobSeeVC animated:YES];
    
    NSLog(@"DetailView代理方法实现了");
}



//如果登录时订阅器数据下载失败
//- (void)netWorkConnection
//{
//    [db deleteRecordAll];
//    
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
//    _request =[ASIHTTPRequest requestWithURL:URL];
//    
//    [_request setTimeOutSeconds:60];
//    
//    [_request setCompletionBlock:^(){
//    
//        NSLog(@"职位下载成功。。。。。。。");
//        
//        NSMutableArray *resultArray=[NSJSONSerialization JSONObjectWithData:_request.responseData options:NSJSONReadingMutableContainers error:nil];
//        
//        NSString *data = [[NSString alloc] initWithData:_request.responseData encoding:NSUTF8StringEncoding];
//        
////        if ([data isEqualToString:@"please login"]) {
////            OtherLogin *other = [OtherLogin standerDefault];
////            [other otherAreaLogin];
////        }
//        
//        //查看数据库中取出的数据，然后将所有订阅的城市找出来。
//        //将订阅城市找出来之后，再得到每个订阅器相应的详细订阅器的个数。
//        //将得到的数据存储在bookCityDic中，这样就可以。
//        
//        /**首次登录应该首先将数据下载后存放到数据库中**/
//        for (int i=0;i<[resultArray count];i++){
//            
//            GRBookerModel *model=[[GRBookerModel alloc]init];
//            NSDictionary *resultDic=[resultArray objectAtIndex:i];
//            model.bookId=[resultDic valueForKey:@"bookId"];
//            model.bookPostName=[resultDic valueForKey:@"bookPostName"];
//            
//            //除了详细订阅之外，其他订阅方式是没有bookIndustryName的
//            if ([resultDic valueForKey:@"bookIndustryName"]){
//                
//                NSString *industry=[resultDic valueForKey:@"bookIndustryName"];
//                
//                if ([industry isEqualToString:@"所有行业"]) {
//                    industry=@"不限";
//                }
//                
//                model.industry=industry;
//                
//            }else{
//                model.industry=@"";
//            }
//            
//            model.flag=[resultDic valueForKey:@"flag"];
//            model.cityStr=[resultDic valueForKey:@"bookLocationName"];
//            model.cityCodeStr=[resultDic valueForKey:@"bookLocation"];
//            model.todayData=[resultDic valueForKey:@"bookTodayData"];
//            model.totalData=[resultDic valueForKey:@"bookTotalData"];
//            
//            if ([resultDic valueForKey:@"bookKeyword"]) {
//                model.keyWord=[resultDic valueForKey:@"bookKeyword"];
//            }else
//            {
//                model.keyWord=@"";
//            }
//            
//            [db addOneRecord:model];
//        }
//        
//        /***查询当前账号已经订阅了哪几个城市***/
//        NSArray *bookCityArray=[db getAllCityRecords];
//        
//        NSMutableDictionary *bookCityDic=[[NSMutableDictionary alloc]init];
//        
//        for (int i=0;i<[bookCityArray count];i++) {
//            GRBookerModel *model =[bookCityArray objectAtIndex:i];
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
//            GRBookerModel *model=[detailReaderArray objectAtIndex:i];
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
//        
//        NSDictionary *dic=[userDefaults valueForKey:@"bookCity"];
//        NSLog(@"bookCityDic3 is %@",dic);
//        
//        
//        //当订阅器下载完成之后，应该将download中的值由0变为1
//        [userDefaults setObject:@"1" forKey:@"download"];
//        
//        [userDefaults synchronize];
//        
//            
//        [self.detailView.readTV reloadData];
//    }];
//    
//    [_request setFailedBlock:^(){
//        NSLog(@"下载失败。。。。。。");
//    }];
//    
//    [_request startAsynchronous];
//}

- (void)cityBtnClick
{
    allCityViewController *allCityVC=[[allCityViewController alloc]init];
    allCityVC.delegate=self;
    CityInfo *cityInfo=[CityInfo standerDefault];
    allCityVC.city_selected = cityInfo.cityName;
    [self.navigationController pushViewController:allCityVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
