//
//  JobSeeViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-4.
//  Copyright (c) 2013年 lxw. All rights reserved.
//
//  新增职位

#import "JobSeeViewController.h"
#import "Config.h"
#import "myButton.h"
#import "JobInfo.h"
#import "CityInfo.h"
#import "cnvUILabel.h"
#import "ReadTableView.h"
#import "ReaderViewController.h"
#import "JobSourceViewController.h"
#import "JobReaderDetailViewController.h"
#import "collectViewController.h"
#import "OtherLogin.h"
#import "ZhangXinBaoViewController.h"
@interface JobSeeViewController ()

@end

@implementation JobSeeViewController
@synthesize page;
@synthesize enterItem=_enterItem,model=_model;

-(void)initData
{
    all=0;//累计新增
    
    today=0;//今日新增
    
    page=1;//搜索页数
    
    positionCount=0; //投递时选中的职位数量
    
    count=0;
    
    num=ios7jj;
    
    detail = NO;//判断是否是明细状态
    
    db=[UserDatabase sharedInstance];
    
    jobString=[[NSString alloc]init];
    
    dataArray=[[NSMutableArray alloc]init];//数据源
    
    selectArray = [[NSMutableArray alloc]init];//存储选择的positionModel职位的数组
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
    _searchItem=normalSearch;//是筛选还是正常的搜索结果
    
    
    //如果没有创建时间，就在此创建
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *lastTime=[userDefaults valueForKey:@"zhangxinTime"];
    
    if (!lastTime) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yy-MM-dd HH-mm-ss"];
        NSString *currentTime=[dateFormatter stringFromDate:[NSDate date]];
        [userDefaults setObject:currentTime forKey:@"zhangxinTime"];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.tableView reloadData];
//    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位查看"];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位查看"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self addBackBtn];
    
    //titleLabelx和titleLabely是用来显示标题的label
    titleLabelx = [[UILabel alloc]initWithFrame:CGRectMake(40,10+self.num, 220, 25)] ;
    [titleLabelx setTextAlignment:NSTextAlignmentLeft];
    [titleLabelx setBackgroundColor:[UIColor clearColor]];
    [titleLabelx setTextColor:RGBA(209, 120, 4, 1)];
    [titleLabelx setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:titleLabelx];
    
    titleLabely = [[UILabel alloc]initWithFrame:CGRectMake(39,9+self.num, 220, 25)] ;
    [titleLabely setTextAlignment:NSTextAlignmentLeft];
    [titleLabely setBackgroundColor:[UIColor clearColor]];
    [titleLabely setTextColor:[UIColor whiteColor]];
    [titleLabely setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:titleLabely];
    
    if (_enterItem ==jobReadEnterHome){
        [self addTitleStr];
    }
    
    UIButton *readButton=[UIButton buttonWithType:UIButtonTypeCustom];
    readButton.backgroundColor=[UIColor clearColor];
    readButton.frame=CGRectMake(iPhone_width-45,0,45,num+44);
    [readButton  addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readButton];
    
    myButton *readBtn=[myButton buttonWithType:UIButtonTypeCustom];
    if (IOS7) {
        readBtn.frame = CGRectMake(iPhone_width-40,28,25,25);
    }else
    {
        readBtn.frame = CGRectMake(iPhone_width-40,10,25,25);
    }
    
    [readBtn setBackgroundImage:[UIImage imageNamed:@"reader.png"] forState:UIControlStateNormal];
    [readBtn setBackgroundImage:[UIImage imageNamed:@"reader.png"] forState:UIControlStateHighlighted];
    [readBtn  addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBtn];
    
    //设置all和today，最终得到all的值和today的值
    [self setTodayAndTotal];
    
    //所有今日新增，累计新增
    _totalLabel = [[RTLabel alloc]init];
    _totalLabel.frame = CGRectMake(5,50+num, iPhone_width- 90, 20);
    _totalLabel.font = [UIFont systemFontOfSize:12];
    _totalLabel.backgroundColor = [UIColor clearColor];
    [self setReadCount:today total:all];
    [self.view addSubview:_totalLabel];
    
    //本条今日新增，累计新增
    _todayLabel = [[RTLabel alloc] initWithFrame: CGRectMake(5,67+num,iPhone_width- 90, 20)];
    _todayLabel.backgroundColor = [UIColor clearColor];
    _todayLabel.font = [UIFont systemFontOfSize:12];
    [self setOneLabelCount:_model.todayData.integerValue total:_model.totalData.integerValue];//设置当前订阅器条数
    [self.view addSubview:_todayLabel];
    
    //职位来源标签
    
    NSArray *cityArray=[db getAllRecords2:_model.cityStr];
    
    NSLog(@"cityAarray is %@",cityArray);
    
    City *city;
    
    if (cityArray&&[cityArray count]>0) {
        city=[cityArray objectAtIndex:0];
    }
    
    cityLabel = [[RTLabel alloc] initWithFrame:CGRectMake(iPhone_width-100,60+num, 90, 40)];
    [cityLabel setTextColor:[UIColor darkGrayColor]];
    [cityLabel setFont:[UIFont systemFontOfSize:13.0f]];
    cityLabel.text = [[NSString alloc] initWithFormat:@"职位来源<u color=blue>%@</u>个",city.sourceStr];
    [self.view addSubview:cityLabel];
    
    //来源按钮
    UIButton *sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sourceBtn.frame = CGRectMake(0,44+num,iPhone_width,20);
    [sourceBtn addTarget:self action:@selector(jobSource:) forControlEvents:UIControlEventTouchUpInside];
    [sourceBtn setBackgroundColor:[UIColor clearColor]];
    [sourceBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.view addSubview:sourceBtn];
    
    //底部背景条
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:55/255.0 green:55/255.0 blue:66/255.0 alpha:1];
    if(IOS7){
        bottomView.frame = CGRectMake(0,iPhone_height - 45,iPhone_width,45);
    }else
    {
        bottomView.frame = CGRectMake(0,iPhone_height -65,iPhone_width,45);
    }
    
    /****************************屏幕下方的按钮*****************************************/
    
    //返回首页的button，改成明细和列表按钮
    UIImage *detailImage=[UIImage imageNamed:@"mingxi.png"];
    UIImageView *detailImageView=[[UIImageView alloc]initWithImage:detailImage];
    detailImageView.frame=CGRectMake(5,-2,50,50);
    detailImageView.tag=101;
    
    myButton* detailBtn2 = [myButton buttonWithType:UIButtonTypeCustom];
    detailBtn2.frame = CGRectMake(0,2,80,45);
    detailBtn2.backgroundColor=[UIColor clearColor];
    [detailBtn2 addTarget:self action:@selector(detailVC:) forControlEvents:UIControlEventTouchUpInside];
    [detailBtn2 addSubview:detailImageView];
    [bottomView addSubview:detailBtn2];
    
    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(18.5,25,28, 28)];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font = [UIFont fontWithName:Zhiti size:10];
    detailLab.text = @"明细";
    [bottomView addSubview:detailLab];
    
    //收藏2
    shoucangBtn = [myButton buttonWithType:UIButtonTypeCustom];
    shoucangBtn.frame = CGRectMake(iPhone_width/2-32,2,iPhone_width/5,45);
    [shoucangBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
    [bottomView addSubview:shoucangBtn];
    UIButton *shoucangBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    shoucangBtn2.frame = CGRectMake(iPhone_width/2-30,2,80,45);
    [shoucangBtn2 addTarget:self action:@selector(shoucangBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shoucangBtn2];
    
    labels = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width/2-11,25, 28, 28)];
    labels.backgroundColor = [UIColor clearColor];
    labels.textColor = [UIColor grayColor];
    labels.font = [UIFont fontWithName:Zhiti size:10];
    labels.text = @"收藏";
    [bottomView addSubview:labels];
    
    //投递
    deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deliveryBtn.alpha=0;
    deliveryBtn.frame = CGRectMake(128,2,iPhone_width/5, 45);
    [deliveryBtn setBackgroundImage:[UIImage imageNamed:@"post_n.png"] forState:UIControlStateNormal];
    [deliveryBtn setBackgroundImage:[UIImage imageNamed:@"post_l.png"] forState:UIControlStateHighlighted];
    [deliveryBtn addTarget:self action:@selector(postResumeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:deliveryBtn];
    
    deliveryLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width/2-11,25, 28, 28)];
    deliveryLab.alpha=0;
    deliveryLab.backgroundColor = [UIColor clearColor];
    deliveryLab.textColor = [UIColor grayColor];
    deliveryLab.font = [UIFont fontWithName:Zhiti size:10];
    deliveryLab.text = @"投递";
    [bottomView addSubview:deliveryLab];
    
    NSLog(@"_model.flag.integerValue is %d",_model.flag.integerValue);
    
    if (_model.flag.integerValue==5) { //如果是
        
        shoucangBtn.alpha=0;
        [shoucangBtn removeFromSuperview];
        labels.alpha=0;
        [labels removeFromSuperview];
        [deliveryBtn removeFromSuperview];
    }
    
    //选择职位的数量
    postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.alpha = 0;
    postBtn.frame = CGRectMake(160,2,18,18);
    [postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateNormal];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateHighlighted];
    [postBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:8]];
    [bottomView addSubview:postBtn];
    
    //筛选
    _selectBtn = [myButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(iPhone_width -62,2,iPhone_width/5,45);
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"shaixuan.png"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_selectBtn];
    UIButton *selectBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn2.backgroundColor=[UIColor clearColor];
    selectBtn2.frame = CGRectMake(iPhone_width -70,0,60,45);
    [selectBtn2 addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:selectBtn2];
    
    UILabel *labels1 = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width - 40,25, 28, 28)];
    labels1.backgroundColor = [UIColor clearColor];
    labels1.textColor = [UIColor grayColor];
    labels1.font = [UIFont fontWithName:Zhiti size:10];
    labels1.text = @"筛选";
    [bottomView addSubview:labels1];
    
    //_tableView是显示职位信息的view
    
    if (IOS7) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45) style:UITableViewStyleGrouped];
    }else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65) style:UITableViewStylePlain];
        
        if ([dataArray count]==0){
            _tableView.frame=CGRectMake(0, 84+num, iPhone_width,0);
        }
        
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

   
    if (!_enterItem ==jobReadEnterHome)
    {
        //1.根据之前传过来的model修改标题
        [self combineString];
        
        NSLog(@"测试2.。。。。。。。。。");
        //2.刷新bookView中的对号选择
        for (int i=0;i<[bookView.dataArray count];i++) {
            
            JobModel *subModel=[bookView.dataArray objectAtIndex:i];
            
            if ([subModel.bookID isEqualToString:_model.bookID]) {
                NSNumber *number=[NSNumber numberWithInt:i];
                [[NSUserDefaults standardUserDefaults]setObject: number forKey:@"selected"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                break;
            }
            
            [bookView.myTableView reloadData];
        }
        
    }
    
    NSLog(@"bookView in JobSee 已经创建完成了。。。");
    
    [self  createHeaderView];
    [self performSelector:@selector(setFooterView) withObject:nil afterDelay:0.0f];
    
    [self.view addSubview:bottomView];
    
    bookView=[[ReadView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height)];
    bookView.delegate=self;
    [self.view addSubview:bookView];
    
    [self setNetConnection];
}

#pragma mark 屏幕下方的按钮响应事件
//明细按钮响应事件
-(void)detailVC:(id)sender
{
    NSLog(@"detail执行到了。。。。。。。");
    
    myButton *btn=(myButton *)sender;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    detail=!detail;
    
    if (!detail){
        imageView.image=[UIImage imageNamed:@"mingxi.png"];
    }else
    {
        imageView.image=[UIImage imageNamed:@"mingxi2.png"];
    }
    
    [_tableView reloadData];
    
    [self createHeaderView];
    
    [self setFooterView];
}

//投递按钮响应事件
-(void)postResumeBtn:(id)sender
{
    NSLog(@"postResumeBtn is Clicked!");
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *canDeliver=[userDefaults valueForKey:@"canDeliver"];
    
    NSString *isComplete=[userDefaults valueForKey:@"isComplete"];
    
    /*
     1.isComplete是否存在，不存在说明是第一次登录，此时判断canDeliver是否为0，0表示能投递，1表示不能投递
     */
    
    if (isComplete||canDeliver.integerValue==0){
        
    }else
    {
        ghostView.message=@"请先完善简历";
        [ghostView show];
        return;
    }
    
    if ([selectArray count]==0){
        ghostView.message=@"请先选择职位再投递";
        [ghostView show];
        return;
    }
    
//    if ([selectArray count]>=3) {
//        
//        NSString *titleStr=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,确认投递吗?",[selectArray count],[selectArray count]];
//        
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        
//        alertView.tag=10000;
//        
//        [alertView show];
//        
//    }else
    {
        
        NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
        
        NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewJobDeliver);
        
        NSString *companyID=[self  getCompanyID:selectArray];
        
        NSLog(@"companyID in postResumeBtn is %@",companyID);
        
        NSString *jobID=[self getJobID:selectArray];
        
        NSLog(@"jobID in postResumeBtn is %@",jobID);
        
//        NSString *cityCode=[self getCityCode:selectArray];//修改逻辑，列表传citycode,单个传workareacode
        NSString *cityCode;
        PositionModel *positionmodel=[selectArray objectAtIndex:0];
        if (selectArray.count>1) {
            cityCode =[NSString stringWithFormat:@"%@",positionmodel.cityCode];
        }else{
            cityCode =[NSString stringWithFormat:@"%@",positionmodel.workAreaCode];
        }
        
        NSLog(@"cityCode in postResumeBtn is %@",cityCode);
        
        NSString *nameStr=[userDefaults valueForKey:@"personName"];
        NSString *telephoneStr=[userDefaults valueForKey:@"user_tel"];
        NSString *workYearStr=[userDefaults valueForKey:@"mWorkYear"];
        
        NSLog(@"userName is %@\nworkYear is %@\ntelphone is %@",nameStr,telephoneStr,workYearStr);
        
        NSString *contentAllStr=@"";
        
        for (int i=0;i<[selectArray count];i++) {
            
            PositionModel *model=[selectArray objectAtIndex:i];
            
            NSString *contentStr=[NSString stringWithFormat:@"简历:%@,应聘职位:%@工作经验:%@,联系电话:%@。",nameStr,model.jobName,workYearStr,telephoneStr];
            
            
            contentAllStr=[contentAllStr stringByAppendingString:contentStr];
            
            if (i!=[selectArray count]-1) {
                
                contentAllStr =[contentAllStr stringByAppendingString:@"-"];
            }
        }
        
        positionCount=[selectArray count];
        
        NSLog(@"contentAllStr is %@",contentAllStr);
        
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",companyID,@"companyId",jobID,@"jobId",cityCode, @"localcity",contentAllStr,@"content",nil];
        
        
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        
        [request setCompletionBlock :^{
            
            [loadView hide:YES];
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"resultDic is %@",resultDic);
            
            NSString *errorStr=[resultDic valueForKey:@"error"];
            
            if (errorStr&&errorStr.integerValue==0) {
                
                ghostView.message=@"投递成功";
                [ghostView show];
                
            }
//            else if(errorStr.integerValue==1)
//            {
//                NSString *num2=[resultDic valueForKey:@"moneys"];
//                
//                NSString *title=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,您目前有%@个才币,不够支付哦,快去赚才币吧",positionCount,positionCount,num2];
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                alert.tag=101;
//                [alert show];
//                
//            }
            else
            {
                ghostView.message=@"投递失败";
                [ghostView show];
            }
            
            [self setPositionChoice];
        }];
        
        [request setFailedBlock :^{
            
            [loadView hide:YES];
            
            ghostView.message=@"投递失败";
            [ghostView show];
            [self setPositionChoice];
        }];
        
        [request startAsynchronous];
    }
}

//收藏按钮点击事件
-(void)shoucangBtn:(id)sender
{
    NSLog(@"收藏按钮被点击了。。。");
    
    collectViewController *collectVC=[[collectViewController alloc]init];
    [self.navigationController pushViewController:collectVC animated:YES];
}

//筛选按钮响应事件
-(void)selectBtnClick:(id)sender
{
    SaveJob *save=[SaveJob standardDefault];
    
    [save choiceArrInit];
    
    SelectConditionViewController *selectConditionVC = [[SelectConditionViewController alloc]init];
    selectConditionVC.delegate= self;
    [self.navigationController pushViewController:selectConditionVC animated:YES];
}

#pragma mark readBtn响应事件(就是右上角的三个点)
-(void)readBtnClick:(id)sender
{
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:10000];
    
    [imageView removeFromSuperview];
    
    UILabel *lab=(UILabel *)[self.view viewWithTag:10001];
    
    [lab removeFromSuperview];
    
    NSLog(@"订阅器界面被点击");
    if (bookView.alpha==0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            bookView.alpha=1;
            [bookView.myTableView reloadData];
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            bookView.alpha=0;
            [bookView.myTableView reloadData];
        }];
    }
}

#pragma mark 网络连接方法
-(void)setNetConnection
{
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    NSLog(@"model.flag in setNetConnection is %@",_model.flag);
    NSLog(@"model.bookID in setNetConnection is %@",_model.bookID);
    NSLog(@"model.cityCodeStr in setNetConnection is %@",_model.cityCodeStr);
    
    page=1;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    net = [[NetWorkConnection alloc] init];
    
    net.delegate = self;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewPositionList);
    
    _searchItem=normalSearch;
    
    //新加参数 verification=md5(location+bookid+xzhiliaoApiJobList)
    NSString *verification = [NSString md5:[NSString stringWithFormat:@"%@%@%@",_model.cityCodeStr,_model.bookID,@"xzhiliaoApiJobList"]];
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID,@"bookId",_model.flag,@"flag",_model.cityCodeStr,@"location",pageStr,@"page",verification,@"verification",nil];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
//    [net requestCache:urlStr param:paramDic];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        //NSLog(@"resultDic in JobSeeVC is %@",resultDic);
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];//得到总共有多少职位
        
        //筛选
        if (_searchItem==choiceSearch) {
            [self setOneLabelCount:allCount.integerValue total:0];
        }
        
        UIView *view=[self.view viewWithTag:10000];
        [view removeFromSuperview];
        
        UIView *view2=[self.view viewWithTag:10001];
        [view2 removeFromSuperview];
        
        UIView *view3=[self.view viewWithTag:1001];
        [view3 removeFromSuperview];
        
        if(resultArray){
            
            if([resultArray count]==0){
                
                [dataArray removeAllObjects];
                
                [_tableView reloadData];
                //添加图片
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                if(_searchItem ==choiceSearch)
                {
                    lab.text=@"抱歉,本类暂无数据,请您换个试试吧";//筛选结果
                }else
                {
                    lab.text=@"抱歉,该订阅器暂无数据,换个试试吧";//正常搜索的结果
                }
                
                [self.view addSubview:lab];
                
            }
            
        }else
        {
            [self downloadFail];
            
            return;
        }
        
        for(int i=0;i<[resultArray count];i++){
            NSDictionary *dic=[resultArray objectAtIndex:i];
            PositionModel *positionmodel=[[PositionModel alloc]initWithDictionary:dic];

            [dataArray addObject:positionmodel];
        }
        
        NSLog(@"dataArray is %@",dataArray);
        
        if ([dataArray count]!=0){
            
            if (IOS7) {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45);
            }else
            {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65);
            }
        }
        
        [_tableView reloadData];
        
        _reloading = NO;
        
        if (isHeader){
            UIView *view=[self.view viewWithTag:1001];
            [view removeFromSuperview];
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            
        }else
        {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        
        if ([resultArray count]<20||allCount.integerValue==[dataArray count]) {
            
            [self removeFooterView];
            
        }else
        {
            [self setFooterView];
        }

        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [self downloadFail];
        
    }];
    [request startAsynchronous];
    
}


#pragma mark ReadView代理方法
-(void)readViewChange:(JobModel *)model1
{
    NSLog(@"JobSeeVC的代理被执行到了。。。。");
    
    _searchItem=normalSearch;
    
    _model=model1;
    
    [self setReadEnterItem];
    
    page=1;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    NSLog(@"countStr in readViewChange and JobSeeVC is %@",pageStr);
    
    NSLog(@"model.cityStr in readViewChange and JobSeeVC is %@",_model.cityStr);
    
    NSArray *cityArray=[db getAllRecords2:_model.cityStr];
    
    City *city;
    
    if ([cityArray count]!=0) {
        city=[cityArray objectAtIndex:0];
    }
    
    NSLog(@"city.sourceStr is %@",city.sourceStr);
    
    CityInfo *cityInfo=[CityInfo standerDefault];
    cityInfo.cityName=_model.cityStr;
    cityInfo.cityCode=_model.cityCodeStr;
    cityInfo.source =city.sourceStr;
    [self combineString];
    [self setOneLabelCount:_model.todayData.integerValue total:_model.totalData.integerValue];

    
    if (_model.flag.integerValue==5) {
        shoucangBtn.alpha=0;
        labels.alpha=0;
    }else
    {
        shoucangBtn.alpha=1;
        labels.alpha=1;
    }
    
    net.delegate = self;
    
    //新加参数 verification=md5(location+bookid+xzhiliaoApiJobList)
    NSString *verification = [NSString md5:[NSString stringWithFormat:@"%@%@%@",_model.cityCodeStr,_model.bookID,@"xzhiliaoApiJobList"]];
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewPositionList);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID, @"bookId",_model.flag,@"flag",_model.cityCodeStr,@"location",pageStr,@"page",verification,@"verification",nil];
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [net requestCache:urlStr param:paramDic];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        //NSLog(@"resultDic in JobSeeVC is %@",resultDic);
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];//得到总共有多少职位
        
        //筛选
        if (_searchItem==choiceSearch) {
            [self setOneLabelCount:allCount.integerValue total:0];
        }
        
        UIView *view=[self.view viewWithTag:10000];
        [view removeFromSuperview];
        
        UIView *view2=[self.view viewWithTag:10001];
        [view2 removeFromSuperview];
        
        UIView *view3=[self.view viewWithTag:1001];
        [view3 removeFromSuperview];
        
        if(resultArray){
            
            if([resultArray count]==0){
                
                [dataArray removeAllObjects];
                
                [_tableView reloadData];
                //添加图片
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                if(_searchItem ==choiceSearch)
                {
                    lab.text=@"抱歉,本类暂无数据,请您换个试试吧";//筛选结果
                }else
                {
                    lab.text=@"抱歉,该订阅器暂无数据,换个试试吧";//正常搜索的结果
                }
                
                [self.view addSubview:lab];
                return;
                
            }
            
        }else
        {
            [self downloadFail];
            
            return;
        }
        
        if (resultDic.count>0) {
            [dataArray removeAllObjects];
        }
        for(int i=0;i<[resultArray count];i++){
            
            PositionModel *positionmodel=[[PositionModel alloc]init];
            NSDictionary *dic=[resultArray objectAtIndex:i];
            positionmodel.isRead=[dic valueForKey:@"isRead"];
            positionmodel.isfavorites=[dic valueForKey:@"isfavorites"];
            positionmodel.counts=[dic valueForKey:@"counts"];
            positionmodel.favorites=[dic valueForKey:@"favorites"];
            positionmodel.postId=[dic  valueForKey:@"postId"];
            positionmodel.workAreaCode=[dic valueForKey:@"workAreaCode"];
            positionmodel.companyAddress=[dic valueForKey:@"companyAddress"];
            positionmodel.companyId=[dic valueForKey:@"companyId"];
            positionmodel.companyName=[dic valueForKey:@"companyName"];
            positionmodel.companyTel=[dic valueForKey:@"companyTel"];
            positionmodel.companyWeb=[dic  valueForKey:@"companyWeb"];
            positionmodel.age=[dic valueForKey:@"age"];
            positionmodel.degree=[dic valueForKey:@"degree"];
            positionmodel.email=[dic valueForKey:@"email"];
            positionmodel.jobName=[dic valueForKey:@"jobName"];
            positionmodel.linkMan=[dic valueForKey:@"linkMan"];
            positionmodel.pubDate=[dic valueForKey:@"pubDate"];
            positionmodel.required=[dic valueForKey:@"required"];
            positionmodel.salary=[dic valueForKey:@"salary"];
            positionmodel.workArea=[dic valueForKey:@"workArea"];
            positionmodel.workExperience=[dic valueForKey:@"workExperience"];
            positionmodel.stopTime=[dic valueForKey:@"stopTime"];
            
            [dataArray addObject:positionmodel];
        }
        
        NSLog(@"dataArray is %@",dataArray);
        
        if ([dataArray count]!=0){
            
            if (IOS7) {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45);
            }else
            {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65);
            }
        }
        
        [_tableView reloadData];
        
        _reloading = NO;
        
        if (isHeader){
            UIView *view=[self.view viewWithTag:1001];
            [view removeFromSuperview];
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            
        }else
        {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        
        if ([resultArray count]<20||allCount.integerValue==[dataArray count]) {
            
            [self removeFooterView];
            
        }else
        {
            [self setFooterView];
        }
        
        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [self downloadFail];
        
    }];
    [request startAsynchronous];

}

#pragma mark 创建EGORefreshHeaderView和EGORefreshFooterView
-(void)createHeaderView
{
    if (_refreshHeaderView&&[_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView=[[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f,0.0f-_tableView.bounds.size.height,_tableView.frame.size.width,_tableView.bounds.size.height)];
    _refreshHeaderView.delegate=self;
    [_tableView  addSubview:_refreshHeaderView];
    
    if (_refreshHeaderView) {
        [_refreshHeaderView refreshLastUpdatedDate:NO];
    }
}

-(void)setFooterView
{
    CGFloat height=MAX(_tableView.contentSize.height,_tableView.bounds.size.height);
    
    if (_refreshFooterView &&[_refreshFooterView superview]) {
        
        _refreshFooterView.frame=CGRectMake(0.0f,height,_tableView.frame.size.width,_tableView.bounds.size.height);
    }else
    {
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         _tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [_tableView addSubview:_refreshFooterView];
    }
    
    if(_refreshFooterView) {
        
        NSInteger allCounts=allCount.integerValue;
        
        NSInteger pageNumber;
        
        if (allCounts%20==0)
        {
            pageNumber =allCounts/20;
        }else
        {
            pageNumber =allCounts/20+1;
        }
        
        if (allCounts==0) {
            
            pageNumber=1;
        }
        
        NSLog(@"pageNumber is %d",pageNumber);
        
        NSString *allCountStr=[NSString stringWithFormat:@"%d/%d页",page,pageNumber];
        
        [_refreshFooterView refreshLastUpdatedDate:allCountStr];
    }
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

#pragma mark UIScrollViewDelegate代理方法
//刷新显示界面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

//刷新数据入口
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
	
	if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
	[self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
	return _reloading;
}

- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view{
    
	return [NSDate date];
}

//刷新delegate
#pragma mark 上拉刷新和下拉刷新调用方法

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    if (aRefreshPos == EGORefreshHeader) {
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
        view.tag=1001;
        view.backgroundColor=[UIColor clearColor];
        [self.view addSubview:view];
        [self performSelector:@selector(refreshView) withObject:self afterDelay:2];
        
    }else if(aRefreshPos == EGORefreshFooter){
        [self performSelector:@selector(getNextPageView) withObject:self afterDelay:2];
    }
}

//上拉刷新调用的方法
-(void)refreshView{
    
    isHeader=YES;
    
    page=1;
    
    NSDictionary *paramDic;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    NSLog(@"pageStr in JobSeeVC and refreshView is %@",pageStr);
    
    net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    
    //新加参数 verification=md5(location+bookid+xzhiliaoApiJobList)
    NSString *verification = [NSString md5:[NSString stringWithFormat:@"%@%@%@",_model.cityCodeStr,_model.bookID,@"xzhiliaoApiJobList"]];
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewPositionList);
    
    if (_searchItem ==normalSearch) {
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID, @"bookId",_model.flag, @"flag",_model.cityCodeStr,@"location",pageStr,@"page",verification,@"verification",nil];
    }else
    {
        
        SaveJob *save=[SaveJob standardDefault];
        jobRead *publishDate = [save.choiceArr objectAtIndex:0];
        jobRead *workYears = [save.choiceArr objectAtIndex:1];
        jobRead *education = [save.choiceArr objectAtIndex:2];
        jobRead *salary = [save.choiceArr objectAtIndex:3];
        jobRead *jobType = [save.choiceArr objectAtIndex:4];
        jobRead *companyType = [save.choiceArr objectAtIndex:5];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID, @"bookId",_model.flag, @"flag",_model.cityCodeStr,@"location",pageStr,@"page",workYears.code,@"searchWorkExperience",publishDate.code,@"searchPublished",education.code,@"searchEducational",companyType.code,@"searchNature",jobType.code,@"searchType",salary.code,@"searchTreatment",@"1",@"screen",verification,@"verification", nil];
    }
    
//    [net requestCache:urlStr param:paramDic];
    NSLog(@"上拉刷新方法被调用了。。。。。。。");
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        [dataArray removeAllObjects];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        //NSLog(@"resultDic in JobSeeVC is %@",resultDic);
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];//得到总共有多少职位
        
        //筛选
        if (_searchItem==choiceSearch) {
            [self setOneLabelCount:allCount.integerValue total:0];
        }
        
        UIView *view=[self.view viewWithTag:10000];
        [view removeFromSuperview];
        
        UIView *view2=[self.view viewWithTag:10001];
        [view2 removeFromSuperview];
        
        UIView *view3=[self.view viewWithTag:1001];
        [view3 removeFromSuperview];
        
        if(resultArray){
            
            if([resultArray count]==0){
                
                [dataArray removeAllObjects];
                
                [_tableView reloadData];
                //添加图片
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                if(_searchItem ==choiceSearch)
                {
                    lab.text=@"抱歉,本类暂无数据,请您换个试试吧";//筛选结果
                }else
                {
                    lab.text=@"抱歉,该订阅器暂无数据,换个试试吧";//正常搜索的结果
                }
                
                [self.view addSubview:lab];
                
            }
            
        }else
        {
            [self downloadFail];
            
            return;
        }
        
        for(int i=0;i<[resultArray count];i++){
            
            PositionModel *positionmodel=[[PositionModel alloc]init];
            NSDictionary *dic=[resultArray objectAtIndex:i];
            positionmodel.isRead=[dic valueForKey:@"isRead"];
            positionmodel.isfavorites=[dic valueForKey:@"isfavorites"];
            positionmodel.counts=[dic valueForKey:@"counts"];
            positionmodel.favorites=[dic valueForKey:@"favorites"];
            positionmodel.postId=[dic  valueForKey:@"postId"];
            positionmodel.workAreaCode=[dic valueForKey:@"workAreaCode"];
            positionmodel.companyAddress=[dic valueForKey:@"companyAddress"];
            positionmodel.companyId=[dic valueForKey:@"companyId"];
            positionmodel.companyName=[dic valueForKey:@"companyName"];
            positionmodel.companyTel=[dic valueForKey:@"companyTel"];
            positionmodel.companyWeb=[dic  valueForKey:@"companyWeb"];
            positionmodel.age=[dic valueForKey:@"age"];
            positionmodel.degree=[dic valueForKey:@"degree"];
            positionmodel.email=[dic valueForKey:@"email"];
            positionmodel.jobName=[dic valueForKey:@"jobName"];
            positionmodel.linkMan=[dic valueForKey:@"linkMan"];
            positionmodel.pubDate=[dic valueForKey:@"pubDate"];
            positionmodel.required=[dic valueForKey:@"required"];
            positionmodel.salary=[dic valueForKey:@"salary"];
            positionmodel.workArea=[dic valueForKey:@"workArea"];
            positionmodel.workExperience=[dic valueForKey:@"workExperience"];
            positionmodel.stopTime=[dic valueForKey:@"stopTime"];
            
            [dataArray addObject:positionmodel];
        }
        
        NSLog(@"dataArray is %@",dataArray);
        
        if ([dataArray count]!=0){
            
            if (IOS7) {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45);
            }else
            {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65);
            }
        }
        
        [_tableView reloadData];
        
        _reloading = NO;
        
        if (isHeader){
            UIView *view=[self.view viewWithTag:1001];
            [view removeFromSuperview];
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            
        }else
        {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        
        if ([resultArray count]<20||allCount.integerValue==[dataArray count]) {
            
            [self removeFooterView];
            
        }else
        {
            [self setFooterView];
        }
        
        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [self downloadFail];
        
    }];
    [request startAsynchronous];
}

//下拉刷新加载调用的方法
-(void)getNextPageView{
    
    isHeader=NO;
    
    NSDictionary*paramDic;
    
    ++page;
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    NSLog(@"pageStr in JobSeeVC and getNextPageView is %@",pageStr);
    
    net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    
    //新加参数 verification=md5(location+bookid+xzhiliaoApiJobList)
    NSString *verification = [NSString md5:[NSString stringWithFormat:@"%@%@%@",_model.cityCodeStr,_model.bookID,@"xzhiliaoApiJobList"]];
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewPositionList);
    
    if (_searchItem ==normalSearch) {
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID, @"bookId",_model.flag, @"flag",_model.cityCodeStr,@"location",pageStr,@"page",verification,@"verification",nil];
    }else
    {
        
        NSLog(@"下拉刷新执行到了。。。。。。。。。");
        SaveJob *save=[SaveJob standardDefault];
        jobRead *publishDate = [save.choiceArr objectAtIndex:0];
        jobRead *workYears = [save.choiceArr objectAtIndex:1];
        jobRead *education = [save.choiceArr objectAtIndex:2];
        jobRead *salary = [save.choiceArr objectAtIndex:3];
        jobRead *jobType = [save.choiceArr objectAtIndex:4];
        jobRead *companyType = [save.choiceArr objectAtIndex:5];
        paramDic = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID, @"bookId",_model.flag, @"flag",_model.cityCodeStr,@"location",pageStr,@"page",workYears.code,@"searchWorkExperience",publishDate.code,@"searchPublished",education.code,@"searchEducational",companyType.code,@"searchNature",jobType.code,@"searchType",salary.code,@"searchTreatment",@"1",@"screen",verification,@"verification", nil];
    }
    
//    [net requestCache:urlStr param:paramDic];
    NSLog(@"下拉刷新方法被调用了。。。。。。。");
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        //NSLog(@"resultDic in JobSeeVC is %@",resultDic);
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];//得到总共有多少职位
        
        //筛选
        if (_searchItem==choiceSearch) {
            [self setOneLabelCount:allCount.integerValue total:0];
        }
        
        UIView *view=[self.view viewWithTag:10000];
        [view removeFromSuperview];
        
        UIView *view2=[self.view viewWithTag:10001];
        [view2 removeFromSuperview];
        
        UIView *view3=[self.view viewWithTag:1001];
        [view3 removeFromSuperview];
        
        if(resultArray){
            
            if([resultArray count]==0){
                
                [dataArray removeAllObjects];
                
                [_tableView reloadData];
                //添加图片
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                if(_searchItem ==choiceSearch)
                {
                    lab.text=@"抱歉,本类暂无数据,请您换个试试吧";//筛选结果
                }else
                {
                    lab.text=@"抱歉,该订阅器暂无数据,换个试试吧";//正常搜索的结果
                }
                
                [self.view addSubview:lab];
                
            }
            
        }else
        {
            [self downloadFail];
            
            return;
        }
        
        for(int i=0;i<[resultArray count];i++){
            
            PositionModel *positionmodel=[[PositionModel alloc]init];
            NSDictionary *dic=[resultArray objectAtIndex:i];
            positionmodel.isRead=[dic valueForKey:@"isRead"];
            positionmodel.isfavorites=[dic valueForKey:@"isfavorites"];
            positionmodel.counts=[dic valueForKey:@"counts"];
            positionmodel.favorites=[dic valueForKey:@"favorites"];
            positionmodel.postId=[dic  valueForKey:@"postId"];
            positionmodel.workAreaCode=[dic valueForKey:@"workAreaCode"];
            positionmodel.companyAddress=[dic valueForKey:@"companyAddress"];
            positionmodel.companyId=[dic valueForKey:@"companyId"];
            positionmodel.companyName=[dic valueForKey:@"companyName"];
            positionmodel.companyTel=[dic valueForKey:@"companyTel"];
            positionmodel.companyWeb=[dic  valueForKey:@"companyWeb"];
            positionmodel.age=[dic valueForKey:@"age"];
            positionmodel.degree=[dic valueForKey:@"degree"];
            positionmodel.email=[dic valueForKey:@"email"];
            positionmodel.jobName=[dic valueForKey:@"jobName"];
            positionmodel.linkMan=[dic valueForKey:@"linkMan"];
            positionmodel.pubDate=[dic valueForKey:@"pubDate"];
            positionmodel.required=[dic valueForKey:@"required"];
            positionmodel.salary=[dic valueForKey:@"salary"];
            positionmodel.workArea=[dic valueForKey:@"workArea"];
            positionmodel.workExperience=[dic valueForKey:@"workExperience"];
            positionmodel.stopTime=[dic valueForKey:@"stopTime"];
            
            [dataArray addObject:positionmodel];
        }
        
        NSLog(@"dataArray is %@",dataArray);
        
        if ([dataArray count]!=0){
            
            if (IOS7) {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45);
            }else
            {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65);
            }
        }
        
        [_tableView reloadData];
        
        _reloading = NO;
        
        if (isHeader){
            UIView *view=[self.view viewWithTag:1001];
            [view removeFromSuperview];
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            
        }else
        {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        
        if ([resultArray count]<20||allCount.integerValue==[dataArray count]) {
            
            [self removeFooterView];
            
        }else
        {
            [self setFooterView];
        }
        
        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [self downloadFail];
        
    }];
    [request startAsynchronous];
}

- (void)setReadCount:(NSInteger)today1 total:(NSInteger)all1
{
    NSString *title1 = [[NSString alloc] initWithFormat:@"所有:今日新增<font color='#f76806'>%d</font>条，累计<font color='#f76806'>%d</font>条",today1,all1];
    _totalLabel.text=title1;
}

//设置当前订阅器的条数
- (void)setOneLabelCount:(NSInteger)today2 total:(NSInteger)all2
{
    
    if (_searchItem==choiceSearch) {
        
        NSString *title=[[NSString alloc]initWithFormat:@"本条:符合筛选数据<font color='#f76806'>%d</font>条",today2];
        
        _todayLabel.text=title;
        
    }else
    {
        NSString *title = [[NSString alloc] initWithFormat:@"本条:今日新增<font color='#f76806'>%d</font>条，累计<font color='#f76806'>%d</font>条",today2,all2];
        _todayLabel.text=title;
    }
    
    CityInfo *cityInfo=[CityInfo standerDefault];
    cityLabel.text = [[NSString alloc] initWithFormat:@"职位来源<u color=blue>%@</u>个",cityInfo.source];
}

#pragma mark SendReques代理实现
-(void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"resultDic in JobSeeVC is %@",resultDic);
    
    NSString *receStr=[[NSString alloc] initWithData:receData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"receStr in ReceiveDataFin is %@",receStr);
    
    if ([receStr isEqualToString:@"please login"]) {
        
        OtherLogin *other = [OtherLogin standerDefault];
        [other otherAreaLogin];
        return;
    }
    
    NSArray *resultArray=[resultDic valueForKey:@"data"];
    
    allCount=[resultDic valueForKey:@"allCounts"];//得到总共有多少职位
    
    //筛选
    if (_searchItem==choiceSearch) {
        [self setOneLabelCount:allCount.integerValue total:0];
    }
    
    UIView *view=[self.view viewWithTag:10000];
    [view removeFromSuperview];
    
    UIView *view2=[self.view viewWithTag:10001];
    [view2 removeFromSuperview];
    
    UIView *view3=[self.view viewWithTag:1001];
    [view3 removeFromSuperview];
    
    if(resultArray){
        
        if([resultArray count]==0){
            
            [dataArray removeAllObjects];
            
            [_tableView reloadData];
            //添加图片
            UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
            
            image.tag=10000;
            
            image.frame=CGRectMake(110,230,100,100);
            
            [self.view addSubview:image];
            
            UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
            
            lab.tag=10001;
            
            lab.backgroundColor=[UIColor clearColor];
            
            lab.font=[UIFont systemFontOfSize:14];
            
            lab.textColor=[UIColor orangeColor];
            
            if(_searchItem ==choiceSearch)
            {
                lab.text=@"抱歉,本类暂无数据,请您换个试试吧";//筛选结果
            }else
            {
                lab.text=@"抱歉,该订阅器暂无数据,换个试试吧";//正常搜索的结果
            }
            
            [self.view addSubview:lab];
            
        }

    }else
    {
        [self downloadFail];
        
        return;
    }
    
    for(int i=0;i<[resultArray count];i++){
    
        PositionModel *positionmodel=[[PositionModel alloc]init];
        NSDictionary *dic=[resultArray objectAtIndex:i];
        positionmodel.isRead=[dic valueForKey:@"isRead"];
        positionmodel.isfavorites=[dic valueForKey:@"isfavorites"];
        positionmodel.counts=[dic valueForKey:@"counts"];
        positionmodel.favorites=[dic valueForKey:@"favorites"];
        positionmodel.postId=[dic  valueForKey:@"postId"];
        positionmodel.workAreaCode=[dic valueForKey:@"workAreaCode"];
        positionmodel.companyAddress=[dic valueForKey:@"companyAddress"];
        positionmodel.companyId=[dic valueForKey:@"companyId"];
        positionmodel.companyName=[dic valueForKey:@"companyName"];
        positionmodel.companyTel=[dic valueForKey:@"companyTel"];
        positionmodel.companyWeb=[dic  valueForKey:@"companyWeb"];
        positionmodel.age=[dic valueForKey:@"age"];
        positionmodel.degree=[dic valueForKey:@"degree"];
        positionmodel.email=[dic valueForKey:@"email"];
        positionmodel.jobName=[dic valueForKey:@"jobName"];
        positionmodel.linkMan=[dic valueForKey:@"linkMan"];
        positionmodel.pubDate=[dic valueForKey:@"pubDate"];
        positionmodel.required=[dic valueForKey:@"required"];
        positionmodel.salary=[dic valueForKey:@"salary"];
        positionmodel.workArea=[dic valueForKey:@"workArea"];
        positionmodel.workExperience=[dic valueForKey:@"workExperience"];
        positionmodel.stopTime=[dic valueForKey:@"stopTime"];
        
        [dataArray addObject:positionmodel];
    }
    
    NSLog(@"dataArray is %@",dataArray);
    
    if ([dataArray count]!=0){
        
        if (IOS7) {
            _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45);
        }else
        {
            _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65);
        }
    }
    
    [_tableView reloadData];
    
    _reloading = NO;
    
    if (isHeader){
        UIView *view=[self.view viewWithTag:1001];
        [view removeFromSuperview];
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
    }else
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if ([resultArray count]<20||allCount.integerValue==[dataArray count]) {
        
        [self removeFooterView];
        
    }else
    {
        [self setFooterView];
    }
}

-(void)receiveRequestFail:(NSError *)error
{
    [self downloadFail];
}

#pragma mark  UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        NSArray *views = [cell.contentView subviews];
        
        for (UIView *v in views) {
            [v removeFromSuperview];
        }
    }
    
    //职位名称
    UILabel *jobNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 180,20)];
    jobNameLab.backgroundColor = [UIColor clearColor];
    jobNameLab.textColor = RGBA(40, 100, 210, 1);
    jobNameLab.font = [UIFont boldSystemFontOfSize:14];
    
    //公司名称
    UILabel *companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(40, 25, 170,20)];
    companyNameLab.backgroundColor =[UIColor clearColor];
    companyNameLab.textColor = [UIColor darkGrayColor];
    companyNameLab.font = [UIFont systemFontOfSize:12];
    
    if (_enterItem==jobReadEnterJianzhi) {
        jobNameLab.frame=CGRectMake(10,5,200,20);
        companyNameLab.frame=CGRectMake(10,25,190,20);
    }
    
    //职位薪水
    UILabel *salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(213, 25, 80, 20)];
    salaryLab.backgroundColor = [UIColor clearColor];
    salaryLab.font = [UIFont systemFontOfSize:12];
    salaryLab.textColor=RGBA(255, 115, 4, 1);
    salaryLab.textAlignment = NSTextAlignmentRight;
    
    //发布日期
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(223, 5, 70, 20)];
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.font = [UIFont systemFontOfSize:12];
    
    
    if (_enterItem==jobReadEnterJianzhi) {
        salaryLab.frame=CGRectMake(208, 25, 80, 20);
        dateLab.frame=CGRectMake(218, 5, 70, 20);
    }
    
    //从数据源中取出数据
    PositionModel *position = [dataArray objectAtIndex:indexPath.row];
    
    jobNameLab.text=position.jobName;
    companyNameLab.text=position.companyName;
    salaryLab.text=position.salary;
    dateLab.text=position.pubDate;
    
    //调整button上标题的位置
    
    if (_enterItem!=jobReadEnterJianzhi) {
        
        collectBtn = [myButton buttonWithType:UIButtonTypeCustom];
        
        collectBtn.tag = indexPath.row;
        
        collectBtn.frame = CGRectMake(0,0,100,50);
        
        UIImageView* collectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,10,30,30)];
        
        collectImageView.tag=101;
        
        [collectBtn addSubview:collectImageView];
        
        if ([selectArray containsObject:position]) {
            
            collectImageView.image=[UIImage imageNamed:@"selectedjob.png"];
            
        }else
        {
            collectImageView.image=[UIImage imageNamed:@"noselectjob.png"];
        }
        
        [collectBtn addTarget:self action:@selector(collectionJob:)
             forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:collectBtn];
    }
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    
    jiantou.frame = CGRectMake(300, 15, 15, 15);
    
    if (position.isRead.integerValue==0) {
        
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"]
                           forState:UIControlStateNormal];
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"]
                           forState:UIControlStateHighlighted];
        
    }else
    {
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                           forState:UIControlStateNormal];
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                           forState:UIControlStateHighlighted];
    }
    [cell.contentView addSubview:jiantou];
    [cell.contentView addSubview:jobNameLab];
    [cell.contentView addSubview:companyNameLab];
    [cell.contentView addSubview:salaryLab];
    [cell.contentView addSubview:dateLab];
    
    if (!detail){   //处于简单状态下时
        
    }else
    {
        //处于详细状态时CGRectMake(0,0,100,50);
        collectBtn.frame = CGRectMake(0,0,100,100);
        UIImageView* imageView;
        NSArray *array = [collectBtn subviews];
        for (UIView* item  in array) {
            if ([item isKindOfClass:[UIImageView class]]) {
                imageView=(UIImageView *)item;
                break;
            }
        }
//        UIImageView* imageView=(UIImageView *)[collectBtn viewWithTag:101];
        
        imageView.frame=CGRectMake(5,35,30,30);
        
        jiantou.frame = CGRectMake(300,45,15, 15);
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,45,260,10)];
        detailLabel.backgroundColor=[UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        NSString *detailStr=[NSString stringWithFormat:@"%@|%@",position.degree,position.workExperience];
        NSLog(@"detailStr in JobSeeVC is %@",detailStr);
        detailLabel.text=detailStr;
        [cell.contentView addSubview:detailLabel];
        
        UILabel *requireLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,52,260,40)];
        requireLabel.numberOfLines=0;
        requireLabel.backgroundColor=[UIColor clearColor];
        requireLabel.textColor = [UIColor darkGrayColor];
        requireLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *requireStr=[NSString stringWithFormat:@"%@",position.required];
        NSLog(@"requireStr in JobSeeVC is %@",requireStr);
        requireLabel.text=requireStr;
        [cell.contentView addSubview:requireLabel];
        
        if (_enterItem==jobReadEnterJianzhi) {
            detailLabel.frame=CGRectMake(10,45,260,10);
            requireLabel.frame=CGRectMake(10,52,260,40);
        }
    }
    
    BOOL isIOS7=IOS7;
    
    if (!isIOS7) {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!detail) {
        return 50;
    }
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *la=[[UILabel alloc]initWithFrame:CGRectMake(0,0,iPhone_width,10)];
    la.backgroundColor=[UIColor grayColor];
    
    return la;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    count++;
    
    if (count>=3) {
        
        count=0;
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yy-MM-dd HH-mm-ss"];
        NSString *currentTime=[dateFormatter stringFromDate:[NSDate date]];
       
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        
        NSString *lastTime=[userDefaults valueForKey:@"zhangxinTime"];
        
        NSDate * dateA = [dateFormatter dateFromString:currentTime];

        NSDate * dateB = [dateFormatter dateFromString:lastTime];
    
        NSTimeInterval timeInterval = [dateA timeIntervalSinceDate:dateB];
    
        
        if (timeInterval/3600/24>=7) {
            
            NSDictionary *dic=[userDefaults valueForKey:@"ZXBStateDic"];
            
            NSString *error=[dic valueForKey:@"error"];
            
            if (error&&error.integerValue==1) {
                
            //判断用户是否购买涨薪宝，提示一下
    
//            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"小同学，告诉你一个涨薪的秘密，快去开启涨薪宝吧！" delegate:self cancelButtonTitle:@"暂不开启" otherButtonTitles:@"开启涨薪宝", nil];
                

                UIAlertView *zhangxinAlertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"小同学，告诉你一个涨薪的秘密，快去开启涨薪宝吧！" delegate:self cancelButtonTitle:@"暂不开启" otherButtonTitles:@"开启涨薪宝", nil];
                
                zhangxinAlertView.tag=456;
    
                [zhangxinAlertView show];
                
            }
            
            [userDefaults setObject:currentTime forKey:@"zhangxinTime"];
            
            [userDefaults synchronize];
        }
        
    }
    
    for (PositionModel *item in dataArray) {
        NSString *temp = item.required;
        //替换全角符号为半角
        temp =  [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
        temp =  [temp stringByReplacingOccurrencesOfString:@"　" withString:@""];
        temp =  [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；" withString:@";"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；" withString:@";"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：" withString:@":"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：" withString:@":"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"，" withString:@","];
        temp =  [temp stringByReplacingOccurrencesOfString:@"，" withString:@","];
        temp =  [temp stringByReplacingOccurrencesOfString:@"。" withString:@"。"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"－" withString:@"-"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"＋" withString:@"+"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"！" withString:@"!"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"？" withString:@"?"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"、" withString:@"、"];
        
        //避免错误换行
        for (int i =1; i<=10; i++) {
            temp =  [temp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d:",i] withString:[NSString stringWithFormat:@"%d.",i]];
        }
        for (int i =1; i<=10; i++) {
            temp =  [temp stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%d、",i] withString:[NSString stringWithFormat:@"%d.",i]];
        }

        
        temp =  [temp stringByReplacingOccurrencesOfString:@";\n" withString:@";"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；\n" withString:@"；"];
        temp =  [temp stringByReplacingOccurrencesOfString:@":\n" withString:@":"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：\n" withString:@"："];
        temp =  [temp stringByReplacingOccurrencesOfString:@"。\n" withString:@"。"];

        
        temp =  [temp stringByReplacingOccurrencesOfString:@";" withString:@";\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"；" withString:@"；\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@":" withString:@":\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"：" withString:@"：\n"];
        temp =  [temp stringByReplacingOccurrencesOfString:@"。" withString:@"。\n"];
        
        if (temp.length == 0 ||!temp) {
            ;
        }else{
            NSString *temp_n = [temp substringFromIndex:temp.length-1];
            if ([temp_n isEqualToString:@"\n"]) {
                temp = [temp substringToIndex:temp.length-1];
            }
            
            item.required = temp;
        }
        
    }
    
    JobReaderDetailViewController * jobDetailVC = [[JobReaderDetailViewController alloc] init];
    jobDetailVC.dataArray=dataArray;
    jobDetailVC.index=indexPath.row;
    jobDetailVC.tag=_enterItem;
    
    PositionModel *model=[dataArray objectAtIndex:indexPath.row];
    
    jobDetailVC.cityCode=model.workAreaCode;
    
    NSLog(@"_model.flag.integerValue is %d",_model.flag.integerValue);
    
    if (_model.flag.integerValue==5) {
        jobDetailVC.isJianzhi=YES;
    }else
    {
        jobDetailVC.isJianzhi=NO;
    }
    [self.navigationController pushViewController:jobDetailVC animated:YES];
}

//返回上一页
-(void)backUp:(id)sender
{
    NSArray *array=self.navigationController.viewControllers;
    
    NSLog(@"array in backUpVC is %@",array);
    
    if ([array count]==4) {
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//职位来源
-(void)jobSource:(id)sender
{
    JobSourceViewController *jobSourse = [[JobSourceViewController alloc]init];
    [self.navigationController pushViewController:jobSourse animated:YES];
}

#pragma mark collectionJob响应
-(void)collectionJob:(id)sender
{
    NSLog(@"选择按钮被点击了。。。。");
    
    myButton *btn=(myButton *)sender;
    btn.isClicked=!btn.isClicked;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    PositionModel *model=[dataArray objectAtIndex:btn.tag];
    
    if ([selectArray containsObject:model]){
        [selectArray removeObject:model];
        
        imageView.image=[UIImage imageNamed:@"noselectjob.png"];
    }else
    {
        if ([selectArray count]>=10) {
            
            ghostView.message=@"一次最多可以投递10个职位";
            [ghostView show];
            return;
        }
        
        [selectArray addObject:model];
        imageView.image=[UIImage imageNamed:@"selectedjob.png"];
    }
    
    if ([selectArray count]!=0) {
        deliveryBtn.alpha=1;
        deliveryLab.alpha=1;
        postBtn.alpha=1;
        shoucangBtn.alpha=0;
        labels.alpha=0;
        
    }else
    {
        deliveryBtn.alpha=0;
        deliveryLab.alpha=0;
        postBtn.alpha=0;
        shoucangBtn.alpha=1;
        labels.alpha=1;
    }
    
    NSString *count=[NSString stringWithFormat:@"%d",[selectArray count]];
    
    [postBtn setTitle:count forState:UIControlStateNormal];
}

-(NSString *)messageContent
{
    ResumeOperation *resume = [ResumeOperation defaultResume];
    NSString *resumeId = [resume.resumeDictionary valueForKey:@"jlBianhao"];
    NSString *pn = [[NSUserDefaults standardUserDefaults] valueForKey:@"personName"];
    NSString *wy = [resume.resumeDictionary valueForKey:@"myWorkYear"];
    NSString *tel = [resume.resumeDictionary valueForKey:@"myTel"];
    NSMutableString *messageString = [[NSMutableString alloc] init];
    
    [messageString appendFormat:@"您好，我是%@，",pn];
    NSString *degree = [resume.resumeDictionary valueForKey:@"degree"];
    
    for (NSInteger i = 0; i<selectArray.count; i++) {
        JobInfo *info = [selectArray objectAtIndex:i];
        [messageString appendFormat:@"应聘：%@，",info.jobName];
        if (degree.length > 0) {
            [messageString appendFormat:@"我的学历是：%@，",degree];
        }
        NSString *str = [NSString stringWithFormat:@"工作年限 ：%@，我的联系电话是：%@，简历详情： [aa href=http://www.xzhiliao.com/admin/resume?rid=%@]http://www.xzhiliao.com/admin/resume?rid=%@[/aa]",wy,tel,resumeId,resumeId];
        
        if (i == 0) {
            [messageString appendString:str];
        }else
        {
            [messageString appendFormat:@"*%@",str];
        }
    }
    
    return messageString;
}


#pragma mark 标题显示
-(void)addTitleStr
{
    if ([[db getAllRecords:@"0"] count]!=0){
        _model=[[db getAllRecords:@"0"] objectAtIndex:0];
        _enterItem=jobReadEnterRead;
    }else if([[db getAllRecords:@"1"] count]!=0)
    {
        _model=[[db getAllRecords:@"1"] objectAtIndex:0];
        
        _enterItem=jobReadEnterCompany;
    }else if([[db getAllRecords:@"2"] count]!=0)
    {
        _model=[[db getAllRecords:@"2"] objectAtIndex:0];
        
        _enterItem=jobReadEnterFast;
    }else if([[db getAllRecords:@"5"] count]!=0)
    {
        _model=[[db getAllRecords:@"5"] objectAtIndex:0];
        
        _enterItem=jobReadEnterJianzhi;
    }
    [self combineString];
    [self addTitleLabel:jobString];
}

//连接字符串
-(void)combineString
{
    NSLog(@"测试0.。。。。。。。。。。。。");
    
    jobString=@"";
    
    if ([_model.flag isEqualToString:@"0"]) {
        
        NSLog(@"测试1.。。。。。。。。。。。。");
        
        if (_model.keyWord && _model.keyWord.length > 0) {
            jobString=[jobString stringByAppendingString:_model.keyWord];
            jobString=[jobString stringByAppendingFormat:@"+"];
        }
        if (_model.cityStr && _model.cityStr.length > 0) {
            jobString=[jobString stringByAppendingString:_model.cityStr];
            jobString=[jobString stringByAppendingFormat:@"+"];
        }
        if (_model.industry && _model.industry.length > 0) {
            jobString=[jobString stringByAppendingString:_model.industry];
            jobString=[jobString stringByAppendingFormat:@"+"];
        }
        if (_model.positionName && _model.positionName.length > 0) {
            jobString=[jobString stringByAppendingString:_model.positionName];
        }
        
    }else
    {
        NSLog(@"测试2.。。。。。。。。。。。。");
        if (_model.cityStr && _model.cityStr.length > 0) {
            jobString=[jobString stringByAppendingString:_model.cityStr];
            jobString=[jobString stringByAppendingFormat:@"+"];
        }
        if (_model.positionName && _model.positionName.length > 0) {
            jobString=[jobString stringByAppendingString:_model.positionName];
        }
    }
    
    if ([jobString length]>13) {
        jobString=[jobString substringToIndex:13];
        jobString =[jobString stringByAppendingString:@"···"];
    }
    
    [self addTitleLabel:jobString];
}

-(void)addTitleLabel:(NSString*)title{
    NSLog(@"title in JobSeeVC  and addTitleLabel is %@",title);
    titleLabelx.text=title;
    titleLabely.text=title;
}

#pragma mark SelectConditionVC(筛选)代理的实现
-(void)finishSelect
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _searchItem =choiceSearch;
    
    //新加参数 verification=md5(location+bookid+xzhiliaoApiJobList)
    NSString *verification = [NSString md5:[NSString stringWithFormat:@"%@%@%@",_model.cityCodeStr,_model.bookID,@"xzhiliaoApiJobList"]];

    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewPositionList);
    
    SaveJob *save=[SaveJob standardDefault];
    jobRead *publishDate = [save.choiceArr objectAtIndex:0];
    jobRead *workYears = [save.choiceArr objectAtIndex:1];
    jobRead *education = [save.choiceArr objectAtIndex:2];
    jobRead *salary = [save.choiceArr objectAtIndex:3];
    jobRead *jobType = [save.choiceArr objectAtIndex:4];
    jobRead *companyType = [save.choiceArr objectAtIndex:5];
    
    page=1;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_model.bookID, @"bookId",_model.flag, @"flag",_model.cityCodeStr,@"location",pageStr,@"page",workYears.code,@"searchWorkExperience",publishDate.code,@"searchPublished",education.code,@"searchEducational",companyType.code,@"searchNature",jobType.code,@"searchType",salary.code,@"searchTreatment",@"1",@"screen",verification,@"verification", nil];
    
    [save choiceArrInit];
    
//    [net requestCache:urlStr param:paramDic];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        //NSLog(@"resultDic in JobSeeVC is %@",resultDic);
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        allCount=[resultDic valueForKey:@"allCounts"];//得到总共有多少职位
        
        //筛选
        if (_searchItem==choiceSearch) {
            [self setOneLabelCount:allCount.integerValue total:0];
        }
        
        UIView *view=[self.view viewWithTag:10000];
        [view removeFromSuperview];
        
        UIView *view2=[self.view viewWithTag:10001];
        [view2 removeFromSuperview];
        
        UIView *view3=[self.view viewWithTag:1001];
        [view3 removeFromSuperview];
        
        if(resultArray){
            
            if([resultArray count]==0){
                
                [dataArray removeAllObjects];
                
                [_tableView reloadData];
                //添加图片
                UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noface.png"]];
                
                image.tag=10000;
                
                image.frame=CGRectMake(110,230,100,100);
                
                [self.view addSubview:image];
                
                UILabel *lab=[[UILabel alloc]initWithFrame:CGRectMake(50,340,300,50)];
                
                lab.tag=10001;
                
                lab.backgroundColor=[UIColor clearColor];
                
                lab.font=[UIFont systemFontOfSize:14];
                
                lab.textColor=[UIColor orangeColor];
                
                if(_searchItem ==choiceSearch)
                {
                    lab.text=@"抱歉,本类暂无数据,请您换个试试吧";//筛选结果
                }else
                {
                    lab.text=@"抱歉,该订阅器暂无数据,换个试试吧";//正常搜索的结果
                }
                
                [self.view addSubview:lab];
                
            }
            
        }else
        {
            [self downloadFail];
            
            return;
        }
        
        for(int i=0;i<[resultArray count];i++){
            
            PositionModel *positionmodel=[[PositionModel alloc]init];
            NSDictionary *dic=[resultArray objectAtIndex:i];
            positionmodel.isRead=[dic valueForKey:@"isRead"];
            positionmodel.isfavorites=[dic valueForKey:@"isfavorites"];
            positionmodel.counts=[dic valueForKey:@"counts"];
            positionmodel.favorites=[dic valueForKey:@"favorites"];
            positionmodel.postId=[dic  valueForKey:@"postId"];
            positionmodel.workAreaCode=[dic valueForKey:@"workAreaCode"];
            positionmodel.companyAddress=[dic valueForKey:@"companyAddress"];
            positionmodel.companyId=[dic valueForKey:@"companyId"];
            positionmodel.companyName=[dic valueForKey:@"companyName"];
            positionmodel.companyTel=[dic valueForKey:@"companyTel"];
            positionmodel.companyWeb=[dic  valueForKey:@"companyWeb"];
            positionmodel.age=[dic valueForKey:@"age"];
            positionmodel.degree=[dic valueForKey:@"degree"];
            positionmodel.email=[dic valueForKey:@"email"];
            positionmodel.jobName=[dic valueForKey:@"jobName"];
            positionmodel.linkMan=[dic valueForKey:@"linkMan"];
            positionmodel.pubDate=[dic valueForKey:@"pubDate"];
            positionmodel.required=[dic valueForKey:@"required"];
            positionmodel.salary=[dic valueForKey:@"salary"];
            positionmodel.workArea=[dic valueForKey:@"workArea"];
            positionmodel.workExperience=[dic valueForKey:@"workExperience"];
            positionmodel.stopTime=[dic valueForKey:@"stopTime"];
            
            [dataArray addObject:positionmodel];
        }
        
        NSLog(@"dataArray is %@",dataArray);
        
        if ([dataArray count]!=0){
            
            if (IOS7) {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-45);
            }else
            {
                _tableView.frame=CGRectMake(0, 84+num, iPhone_width, iPhone_height-84-num-65);
            }
        }
        
        [_tableView reloadData];
        
        _reloading = NO;
        
        if (isHeader){
            UIView *view=[self.view viewWithTag:1001];
            [view removeFromSuperview];
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
            
        }else
        {
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        }
        
        if ([resultArray count]<20||allCount.integerValue==[dataArray count]) {
            
            [self removeFooterView];
            
        }else
        {
            [self setFooterView];
        }
        
        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [self downloadFail];
        
    }];
    [request startAsynchronous];
}

#pragma mark all和today
-(void)setTodayAndTotal
{
    all=0;
    today=0;
    
    NSArray *todayArray=[db getAllRecords];
    for (int i=0;i<[todayArray count];i++) {
        JobModel *lmodel=[todayArray objectAtIndex:i];
        today=today+lmodel.todayData.integerValue;
    }
    
    for (int i=0;i<[todayArray count];i++) {
        JobModel *lmodel=[todayArray objectAtIndex:i];
        all=all+lmodel.totalData.integerValue;
    }
}

#pragma mark  职位投递时用的方法
//得到公司ID字符串
-(NSString *)getCompanyID:(NSMutableArray *)array
{
    NSString *str=[[NSString alloc]init];
    
    for (int i=0;i<[array count];i++) {
        
        PositionModel *model=[array objectAtIndex:i];
        
        if(i==[array count]-1)
        {
            str =[str stringByAppendingString:(model.companyId?:@"")];
            
        }else
        {
            str =[str stringByAppendingString:(model.companyId?:@"")];
            str=[str stringByAppendingString:@"-"];
        }
    }
    return str;
}


//得到职位ID字符串
-(NSString*)getJobID:(NSMutableArray *)array
{
    NSString *str=[[NSString alloc]init];
    
    for (int i=0;i<[array count];i++)
    {
        PositionModel *positionmodel=[array objectAtIndex:i];
        
        
        if (i!=[array count]-1) {
            NSString *subStr=[NSString stringWithFormat:@"%@",positionmodel.postId];
            str=[str stringByAppendingString:subStr];
            str=[str stringByAppendingString:@"-"];
        }else
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",positionmodel.postId];
            str=[str stringByAppendingString:subStr];
        }
    }
    
    return str;
}

//得到工作城市代码字符串
-(NSString*)getCityCode:(NSMutableArray *)array
{
    NSString *str=[[NSString alloc]init];
    
    for (int i=0;i<[array count];i++) {
        
        PositionModel *model=[array objectAtIndex:i];
        
        if(i==[array count]-1)
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",model.workAreaCode];
            str =[str stringByAppendingString:subStr];
        }else
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",model.workAreaCode];
            str =[str stringByAppendingString:subStr];
            str=[str stringByAppendingString:@"-"];
        }
    }
    return str;
}

#pragma mark UIAlertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        
        if (buttonIndex==1){
            NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
            
            NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kNewJobDeliver);
            
            NSString *companyID=[self  getCompanyID:selectArray];
            
            NSLog(@"companyID in postResumeBtn is %@",companyID);
            
            NSString *jobID=[self getJobID:selectArray];
            
            NSLog(@"jobID in postResumeBtn is %@",jobID);
            
            NSString *cityCode=[self getCityCode:selectArray];
            NSLog(@"cityCode in postResumeBtn is %@",cityCode);
            
            NSString *nameStr=[userDefaults valueForKey:@"personName"];
            NSString *telephoneStr=[userDefaults valueForKey:@"user_tel"];
            NSString *workYearStr=[userDefaults valueForKey:@"mWorkYear"];
            
            NSLog(@"userName is %@\nworkYear is %@\ntelphone is %@",nameStr,telephoneStr,workYearStr);
            
            NSString *contentAllStr=@"";
            
            for (int i=0;i<[selectArray count];i++) {
                
                PositionModel *model=[selectArray objectAtIndex:i];
                
                NSString *contentStr=[NSString stringWithFormat:@"简历:%@,应聘职位:%@工作经验:%@,联系电话:%@。",nameStr,model.jobName,workYearStr,telephoneStr];
                
                
                contentAllStr=[contentAllStr stringByAppendingString:contentStr];
                
                if (i!=[selectArray count]-1) {
                    
                    contentAllStr =[contentAllStr stringByAppendingString:@"-"];
                }
            }
            
            positionCount=[selectArray count];
            
            NSLog(@"contentAllStr is %@",contentAllStr);
            
            NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",companyID,@"companyId",jobID,@"jobId",cityCode, @"localcity",contentAllStr,@"content",nil];
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
            
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
            
            [request setTimeOutSeconds:30];
            
            [request setCompletionBlock :^{
                
                [loadView hide:YES];
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
                
                NSLog(@"resultDic is %@",resultDic);
                
                NSString *errorStr=[resultDic valueForKey:@"error"];
                
                if (errorStr&&errorStr.integerValue==0) {
                    
                    ghostView.message=@"投递成功";
                    [ghostView show];
                    
                }
//                else if(errorStr.integerValue==1)
//                {
//                    
//                    NSString *num2=[resultDic valueForKey:@"moneys"];
//                    
//                    NSString *title=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,您目前有%@个才币,不够支付哦,快去赚才币吧",positionCount,positionCount,num2];
//                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                    alert.tag=101;
//                    [alert show];
//                    
//                }
                else
                {
                    ghostView.message=@"投递失败";
                    [ghostView show];
                }
                
                [self setPositionChoice];
            }];
            
            [request setFailedBlock:^(){
                
                [loadView hide:YES];
                ghostView.message=@"投递失败";
                [ghostView show];
                [self setPositionChoice];
            }];
            
            [request startAsynchronous];
            
        }
    }
    
    if (alertView.tag==456) {
     
        if (buttonIndex==1) {
            
            ZhangXinBaoViewController *zhangxinVC=[[ZhangXinBaoViewController alloc]init];
            
            [self.navigationController pushViewController:zhangxinVC animated:YES];
        }
    }
}

//jobReaderDetailViewController代理方法
-(void)jobReaderDetailVC
{
    [_tableView reloadData];
}

-(void)setReadEnterItem
{
    if (_model.flag.integerValue==0) {
        _enterItem=jobReadEnterRead;
    }else if (_model.flag.integerValue==1)
    {
        _enterItem=jobReadEnterCompany;
    }else if (_model.flag.integerValue==2)
    {
        _enterItem=jobReadEnterFast;
    }else if (_model.flag.integerValue==5)
    {
        _enterItem=jobReadEnterJianzhi;
    }else
    {
        _enterItem=jobReadEnterHome;
    }
}

#pragma mark 下载失败时调用的方法
-(void)downloadFail
{
    
    [loadView hide:YES];
    
    ghostView.message=@"请求失败";
    
    [ghostView show];
    
    [_tableView reloadData];
    
    UIView *view=[self.view viewWithTag:1001];
    [view removeFromSuperview];
    
    if (isHeader){
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
    }else
    {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

-(void)setPositionChoice
{
    if ([selectArray count]!=0) {
        [selectArray removeAllObjects];
        [_tableView reloadData];
        [postBtn setTitle:@"" forState:UIControlStateNormal];
        postBtn.alpha=0;
        deliveryBtn.alpha=0;
        shoucangBtn.alpha=1;
        labels.alpha=1;
        deliveryLab.alpha=0;
    }else
    {
        
        [_tableView reloadData];
        [postBtn setTitle:@"" forState:UIControlStateNormal];
        
        postBtn.alpha=0;
        deliveryBtn.alpha=0;
        shoucangBtn.alpha=1;
        labels.alpha=1;
        deliveryLab.alpha=0;
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
