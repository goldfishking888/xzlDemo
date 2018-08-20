//
//  SearchViewResultController.m
//  JobKnow
//
//  Created by Apple on 14-3-26.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "SearchViewResultController.h"
#import "PositionModel.h"
#import "collectViewController.h"
#import "SelectConditionViewController.h"
#import "JobReaderDetailViewController.h"
#import "ReaderViewController.h"
#import "JobSourceViewController.h"
#import "OtherLogin.h"
@interface SearchViewResultController ()

@end

@implementation SearchViewResultController

@synthesize page;
@synthesize dataArray=_dataArray;
@synthesize model=_model;

-(void)initData
{
    all = 0;
    page=1;
    today = 0;
    positionCount=0;
    
    iosHeight=ios7jj;
    detail = NO;
    db=[UserDatabase sharedInstance];
    
    jobString=[[NSString alloc]init];
    
    selectArray = [[NSMutableArray alloc]init];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZHILBJ_colour;
    
    _item=requestNormal;
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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位搜索结果"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位搜索结果"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    [self addBackBtn];
    
    //titleLabelx和titleLabely是用来显示标题的label
    titleLabelx = [[UILabel alloc]initWithFrame:CGRectMake(30,10+self.num, 220, 25)] ;
    [titleLabelx setTextAlignment:NSTextAlignmentCenter];
    [titleLabelx setBackgroundColor:[UIColor clearColor]];
    [titleLabelx setTextColor:RGBA(209, 120, 4, 1)];
    [titleLabelx setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:titleLabelx];
    
    titleLabely = [[UILabel alloc]initWithFrame:CGRectMake(29,9+self.num, 220, 25)] ;
    [titleLabely setTextAlignment:NSTextAlignmentCenter];
    [titleLabely setBackgroundColor:[UIColor clearColor]];
    [titleLabely setTextColor:[UIColor whiteColor]];
    [titleLabely setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:titleLabely];
    
    //NSLog(@"_titleStr is %@",_titleStr);
    [self addTitleLabel:_titleStr];
    
    //所有今日新增，累计新增
    _totalLabel = [[RTLabel alloc]init];
    _totalLabel.frame = CGRectMake(5,50+iosHeight, iPhone_width- 90, 20);
    _totalLabel.font = [UIFont systemFontOfSize:12];
    _totalLabel.backgroundColor = [UIColor clearColor];
    //今日新增，累计新增
    [self setTotalAndToday];
    [self.view addSubview:_totalLabel];
    
    //累计筛选出来的数量
    _allLabel = [[RTLabel alloc] initWithFrame: CGRectMake(5,67+iosHeight,iPhone_width- 90, 20)];
    _allLabel.backgroundColor = [UIColor clearColor];
    NSString *title = [[NSString alloc] initWithFormat:@"符合筛选数据<font color='#f76806'>%d</font>条",_totalStr.integerValue];
    _allLabel.text=title;
    _allLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_allLabel];
    
    
    //来源按钮
    UIButton *sourceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sourceBtn.frame = CGRectMake(0,50+iosHeight,iPhone_width,15);
    [sourceBtn addTarget:self action:@selector(jobSource:) forControlEvents:UIControlEventTouchUpInside];
    [sourceBtn setBackgroundColor:[UIColor clearColor]];
    [sourceBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.view addSubview:sourceBtn];
    
    //职位来源标签
    CityInfo *cityInfo = [CityInfo standerDefault];
    NSLog(@"cityInfo in JobSee is %@",cityInfo.source);
    cityLabel = [[RTLabel alloc] initWithFrame:CGRectMake(iPhone_width-100,60+iosHeight, 90, 40)];
    [cityLabel setTextColor:[UIColor darkGrayColor]];
    [cityLabel setFont:[UIFont systemFontOfSize:13.0f]];
    cityLabel.text = [[NSString alloc] initWithFormat:@"职位来源<u color=blue>%@</u>个",cityInfo.source];
    [self.view addSubview:cityLabel];
    
    //底部背景条
    UIView *bottomLabel = [[UIView alloc]init];

    bottomLabel.backgroundColor = [UIColor whiteColor];
    if(IOS7){
        bottomLabel.frame = CGRectMake(0,iPhone_height - 45,iPhone_width,45);
    }else
    {
        bottomLabel.frame = CGRectMake(0,iPhone_height -65,iPhone_width, 45);
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
    [bottomLabel addSubview:detailBtn2];
    
    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(18.5,25,28, 28)];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [UIColor grayColor];
    detailLab.font = [UIFont fontWithName:Zhiti size:10];
    detailLab.text = @"明细";
    [bottomLabel addSubview:detailLab];
    
    //收藏2
    shoucangBtn = [myButton buttonWithType:UIButtonTypeCustom];
    shoucangBtn.frame = CGRectMake(iPhone_width/2-32,2,iPhone_width/5,45);
    [shoucangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
    [bottomLabel addSubview:shoucangBtn];
    UIButton *shoucangBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    shoucangBtn2.frame = CGRectMake(iPhone_width/2-30,2,80,45);
    [shoucangBtn2 addTarget:self action:@selector(shoucangBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomLabel addSubview:shoucangBtn2];
    
    labels = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width/2-11,25, 28, 28)];
    labels.backgroundColor = [UIColor clearColor];
    labels.textColor = [UIColor grayColor];
    labels.font = [UIFont fontWithName:Zhiti size:10];
    labels.text = @"收藏";
    [bottomLabel addSubview:labels];
    
    //投递
    deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deliveryBtn.alpha=0;
    deliveryBtn.frame = CGRectMake(128,2,iPhone_width/5, 45);
    [deliveryBtn setBackgroundImage:[UIImage imageNamed:@"post_n@2x.png"] forState:UIControlStateNormal];
    [deliveryBtn setBackgroundImage:[UIImage imageNamed:@"post_l@2x.png"] forState:UIControlStateHighlighted];
    [deliveryBtn addTarget:self action:@selector(postResumeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomLabel addSubview:deliveryBtn];
    
    deliveryLab = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width/2-11,25, 28, 28)];
    deliveryLab.alpha=0;
    deliveryLab.backgroundColor = [UIColor clearColor];
    deliveryLab.textColor = [UIColor grayColor];
    deliveryLab.font = [UIFont fontWithName:Zhiti size:10];
    deliveryLab.text = @"投递";
    [bottomLabel addSubview:deliveryLab];
    
    //选择职位的数量
    postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.alpha = 0;
    postBtn.frame = CGRectMake(160,2,18,18);
    [postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateNormal];
    [postBtn setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateHighlighted];
    [postBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:8]];
    [bottomLabel addSubview:postBtn];
    
    //筛选
    _selectBtn = [myButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(iPhone_width -62,2,iPhone_width/5,45);
    [_selectBtn setBackgroundImage:[UIImage imageNamed:@"shaixuan.png"] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [bottomLabel addSubview:_selectBtn];
    UIButton *selectBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn2.backgroundColor=[UIColor clearColor];
    selectBtn2.frame = CGRectMake(iPhone_width -70,0,60,45);
    [selectBtn2 addTarget:self action:@selector(selectBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [bottomLabel addSubview:selectBtn2];
    
    UILabel *labels1 = [[UILabel alloc]initWithFrame:CGRectMake(iPhone_width - 40,25, 28, 28)];
    labels1.backgroundColor = [UIColor clearColor];
    labels1.textColor = [UIColor grayColor];
    labels1.font = [UIFont fontWithName:Zhiti size:10];
    labels1.text = @"筛选";
    [bottomLabel addSubview:labels1];
    
    //_tableView是显示职位信息的view
    
    if (IOS7) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84+iosHeight, iPhone_width, iPhone_height-84-iosHeight-45) style:UITableViewStyleGrouped];
    }else
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 84+iosHeight, iPhone_width, iPhone_height-84-iosHeight-65) style:UITableViewStylePlain];
    }
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    if ([_dataArray count]>=20) {
        [self  createHeaderView];
        [self performSelector:@selector(setFooterView) withObject:nil afterDelay:0.0f];
    }
    
    [self.view addSubview:bottomLabel];
    
}

#pragma mark 屏幕下方的按钮响应事件

//明细按钮响应事件
-(void)detailVC:(id)sender
{
    detail=!detail;
    
    [_tableView reloadData];
    
    [self createHeaderView];
    [self setFooterView];
}

//投递按钮响应事件
-(void)postResumeBtn:(id)sender
{
    NSLog(@"postResumeBtn is Clicked!");
    
    /*
     1.判断简历是否完善
     
     2.投递，判断是否超过3个，出现一个提示框
     
     3.点击yes投递，其他不投递
     */
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *isComplete=[userDefaults valueForKey:@"isComplete"];
    NSString *canDeliver=[userDefaults valueForKey:@"canDeliver"];
    NSLog(@"isComplete is %@",isComplete);
    
    /*
     1.isComplete是否存在，不存在说明是第一次登录，此时判断canDeliver是否为0，0表示能投递，1表示不能投递
     
     */
    
    if (isComplete) {   //第一次登录
        
        if ([isComplete isEqualToString:@"不完善"]) {
            ghostView.message=@"请先完善简历";
            [ghostView show];
            return;
        }
        
    }else
    {
        if (canDeliver.integerValue==1) {
            ghostView.message=@"请先完善简历";
            [ghostView show];
            
            return;
        }
    }
    
//    if ([selectArray count]>=3) {
//        
//        NSString *titleStr=[NSString stringWithFormat:@"主人,您选择批量投递%d个职位,需要花费%d个才币,确认投递吗?",[selectArray count],[selectArray count]];
//        
//        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:titleStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [alertView show];
//    }else
    {
        
        NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
        
        net=[[NetWorkConnection alloc]init];
        net.delegate=self;
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
        
//        [net sendRequestURLStr:urlStr ParamDic:paramDic Method:@"GET"];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            [loadView setHidden:YES];
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            NSString *errorStr=[resultDic valueForKey:@"error"];
            if (errorStr&&errorStr.integerValue==0) {
                
                ghostView.message=@"投递成功";
                [ghostView show];
            }
            else{
                ghostView.message=@"投递失败";
                [ghostView show];
            }
            if ([selectArray count]!=0) {
                [selectArray removeAllObjects];
                [_tableView reloadData];
                [postBtn setTitle:@"" forState:UIControlStateNormal];
                postBtn.alpha=0;
                deliveryBtn.alpha=0;
                shoucangBtn.alpha=1;
            }else
            {
                [_tableView reloadData];
                [postBtn setTitle:@"" forState:UIControlStateNormal];
                postBtn.alpha=0;
                deliveryBtn.alpha=0;
                shoucangBtn.alpha=1;
            }

            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            ghostView.message=@"投递失败";
            [ghostView show];
        }];
        [request startAsynchronous];
    }
}
#pragma mark 收藏
-(void)shoucangBtn:(id)sender
{
    NSLog(@"收藏按钮被点击了。。。");
    collectViewController *collectVC=[[collectViewController alloc]init];
    [self.navigationController pushViewController:collectVC animated:YES];
}

-(void)selectBtnClick2:(id)sender
{
    NSLog(@"筛选按钮被点击");
    
    SaveJob *save=[SaveJob standardDefault];
    
    [save choiceArrInit];
    
    SelectConditionViewController *selectVC = [[SelectConditionViewController alloc]init];
    selectVC.delegate= self;
    [self.navigationController pushViewController:selectVC animated:YES];
}

-(void)finishSelect
{
    NSLog(@"finishSelect代理方法执行。。。。。。。");
    
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _item=requestShuaixuan;
    
    if ([_dataArray count]!=0) {
        [_dataArray removeAllObjects];
    }
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kJobSearch);
    
    SaveJob *save=[SaveJob standardDefault];
    jobRead *publishDate = [save.choiceArr objectAtIndex:0];
    jobRead *workYears = [save.choiceArr objectAtIndex:1];
    
    jobRead *education = [save.choiceArr objectAtIndex:2];
    jobRead *salary = [save.choiceArr objectAtIndex:3];
    jobRead *jobType = [save.choiceArr objectAtIndex:4];
    jobRead *companyType = [save.choiceArr objectAtIndex:5];
    
    
    NSLog(@"publishDate.name is %@",publishDate.name);
    NSLog(@"workYears.name is %@",workYears.name);
    NSLog(@"education.name is %@",education.name);
    NSLog(@"salary.name is %@",salary.name);
    NSLog(@"jobType.name is %@",jobType.name);
    NSLog(@"companyType.name is %@",companyType.name);
    
    NSLog(@"publishDate.name is %@",publishDate.code);
    NSLog(@"workYears.name is %@",workYears.code);
    NSLog(@"education.name is %@",education.code);
    NSLog(@"salary.name is %@",salary.code);
    NSLog(@"jobType.name is %@",jobType.code);
    NSLog(@"companyType.name is %@",companyType.code);
    
    page=1;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            IMEI,@"userImei",kUserTokenStr,@"userToken",
                            @"0",@"flag",_model.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                            jobType.code,@"searchPost",_model.industryCode,@"searchIndustry",//职位类别，行业类别
                            salary.code,@"searchTreatment",_model.keyWord,@"searchKeyword",  //职位待遇，职位关键词
                            _model.jobTypeCode,@"searchType",workYears.code,@"searchWorkExperience", //职位类型，工作经验
                            publishDate.code,@"searchPublished",education.code,@"searchEducational",     //发布日期，教育经历
                            companyType.code,@"searchNature",@"0",@"searchBookId",pageStr,@"page",nil];
    
    //[save choiceArrInit];
    
    NSLog(@"此处执行到了。。。。");
    
//    NetWorkConnection *net2=[[NetWorkConnection alloc]init];
//    
//    net2.delegate=self;
//    
//    [net2 requestCache:urlStr param:paramDic];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"resultDic in SearchVC is %@",resultDic);
        
        
        [loadView hide:YES];
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        for (int i=0;i<[resultArray count];i++) {
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
            [_dataArray addObject:positionmodel];
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
        
        if ([resultArray count]<20) {
            
            [self removeFooterView];
            
            if (page!=1) {
                ghostView.message=@"主人，已为您加载所有职位!";
                [ghostView show];
            }
            
        }else
        {
            [self setFooterView];
        }

    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
        //        reloading = NO;
        [loadView hide:YES];
        NSLog(@"下载失败。。。。");

        
    }];
    [request startAsynchronous];
    
    NSLog(@"此处执行到了。。。。2");
    
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
    
    if (_refreshFooterView) {
        
        NSInteger allCounts=_totalStr.integerValue;
        NSInteger pageNumber =allCounts/20+1;
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
#pragma mark data reloading methods that must be overide by the subclass

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
    
    if ([_dataArray count]!=0) {
        [_dataArray removeAllObjects];
    }
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    NSLog(@"pageStr in JobSeeVC and refreshView is %@",pageStr);
    
    net = [[NetWorkConnection alloc] init];
    
    net.delegate = self;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kJobSearch);
    
    if (_item==requestNormal) {
        //上拉刷新
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",_model.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  _model.positionCode,@"searchPost",_model.industryCode,@"searchIndustry",//职位类别，行业类别
                  _model.salaryCode,@"searchTreatment",_model.keyWord,@"searchKeyword",  //职位待遇，职位关键词
                  _model.jobTypeCode,@"searchType",_model.experienceCode,@"searchWorkExperience", //职位类型，工作经验
                  _model.workYearCode,@"searchPublished",_model.educationCode,@"searchEducational",     //发布日期，教育经历
                  _model.natureCode,@"searchNature",@"0",@"searchBookId",@"1",@"page",nil];
    }else
    {
        
        
        SaveJob *save=[SaveJob standardDefault];
        
        jobRead *publishDate = [save.choiceArr objectAtIndex:0];
        jobRead *workYears = [save.choiceArr objectAtIndex:1];
        
        jobRead *education = [save.choiceArr objectAtIndex:2];
        jobRead *salary = [save.choiceArr objectAtIndex:3];
        jobRead *jobType = [save.choiceArr objectAtIndex:4];
        jobRead *companyType = [save.choiceArr objectAtIndex:5];
        
        page=1;
        
        NSString *pageStr=[NSString stringWithFormat:@"%d",page];
        
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",_model.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  jobType.code,@"searchPost",_model.industryCode,@"searchIndustry",//职位类别，行业类别
                  salary.code,@"searchTreatment",_model.keyWord,@"searchKeyword",  //职位待遇，职位关键词
                  _model.jobTypeCode,@"searchType",workYears.code,@"searchWorkExperience", //职位类型，工作经验
                  publishDate.code,@"searchPublished",education.code,@"searchEducational",     //发布日期，教育经历
                  companyType.code,@"searchNature",@"0",@"searchBookId",pageStr,@"page",nil];
        
        
    }
    
//    [net requestCache:urlStr param:paramDic];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"resultDic in SearchVC is %@",resultDic);
        
        
        [loadView hide:YES];
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        for (int i=0;i<[resultArray count];i++) {
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
            [_dataArray addObject:positionmodel];
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
        
        if ([resultArray count]<20) {
            
            [self removeFooterView];
            
            if (page!=1) {
                ghostView.message=@"主人，已为您加载所有职位!";
                [ghostView show];
            }
            
        }else
        {
            [self setFooterView];
        }
        
    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
        //        reloading = NO;
        [loadView hide:YES];
        NSLog(@"下载失败。。。。");
        
        
    }];
    [request startAsynchronous];

    
    NSLog(@"上拉刷新方法被调用了。。。。。。。");
}

//下拉刷新加载调用的方法
-(void)getNextPageView{
    
    
    //判断是否是上拉刷新
    
    isHeader=NO;
    
    NSDictionary*paramDic;
    
    ++page;
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    NSLog(@"pageStr in JobSeeVC and getNextPageView is %@",pageStr);
    
    net = [[NetWorkConnection alloc] init];
    net.delegate = self;
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,kJobSearch);
    
    if (_item==requestNormal) {
        
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",_model.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  _model.positionCode,@"searchPost",_model.industryCode,@"searchIndustry",//职位类别，行业类别
                  _model.salaryCode,@"searchTreatment",_model.keyWord,@"searchKeyword",  //职位待遇，职位关键词
                  _model.jobTypeCode,@"searchType",_model.experienceCode,@"searchWorkExperience", //职位类型，工作经验
                  _model.workYearCode,@"searchPublished",_model.educationCode,@"searchEducational",     //发布日期，教育经历
                  _model.natureCode,@"searchNature",@"0",@"searchBookId",pageStr,@"page",nil];
    }else
    {
        
        NSLog(@"下拉刷新的时候执行了。。。。");
        
        SaveJob *save=[SaveJob standardDefault];
        jobRead *publishDate = [save.choiceArr objectAtIndex:0];
        jobRead *workYears = [save.choiceArr objectAtIndex:1];
        
        jobRead *education = [save.choiceArr objectAtIndex:2];
        jobRead *salary = [save.choiceArr objectAtIndex:3];
        jobRead *jobType = [save.choiceArr objectAtIndex:4];
        jobRead *companyType = [save.choiceArr objectAtIndex:5];
        
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:
                  IMEI,@"userImei",kUserTokenStr,@"userToken",
                  @"0",@"flag",_model.cityCode,@"searchLocation",                   //订阅类型，订阅城市
                  jobType.code,@"searchPost",_model.industryCode,@"searchIndustry",//职位类别，行业类别
                  salary.code,@"searchTreatment",_model.keyWord,@"searchKeyword",  //职位待遇，职位关键词
                  _model.jobTypeCode,@"searchType",workYears.code,@"searchWorkExperience", //职位类型，工作经验
                  publishDate.code,@"searchPublished",education.code,@"searchEducational",     //发布日期，教育经历
                  companyType.code,@"searchNature",@"0",@"searchBookId",pageStr,@"page",nil];
    }
    
//    [net requestCache:urlStr param:paramDic];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"resultDic in SearchVC is %@",resultDic);
        
        
        [loadView hide:YES];
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        if ([receStr isEqualToString:@"please login"]) {
            
            OtherLogin *other = [OtherLogin standerDefault];
            [other otherAreaLogin];
            return;
        }
        
        NSArray *resultArray=[resultDic valueForKey:@"data"];
        
        for (int i=0;i<[resultArray count];i++) {
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
            [_dataArray addObject:positionmodel];
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
        
        if ([resultArray count]<20) {
            
            [self removeFooterView];
            
            if (page!=1) {
                ghostView.message=@"主人，已为您加载所有职位!";
                [ghostView show];
            }
            
        }else
        {
            [self setFooterView];
        }
        
    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
        //        reloading = NO;
        [loadView hide:YES];
        NSLog(@"下载失败。。。。");
        
        
    }];
    [request startAsynchronous];
}

//设置今日新增和累计新增数量
- (void)setTotalAndToday
{
    NSString *title1 = [[NSString alloc] initWithFormat:@"今日新增<font color='#f76806'>%d</font>条，累计<font color='#f76806'>%d</font>条",_todayStr.integerValue,_totalStr.integerValue];
    
    _totalLabel.text=title1;
}

#pragma mark SendReques代理实现
-(void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic in JobSeeVC is %@",resultDic);
    
    NSString *receStr=[[NSString alloc] initWithData:receData encoding:NSUTF8StringEncoding];
    
    NSLog(@"receStr in ReceiveDataFin is %@",receStr);
    
    if ([receStr isEqualToString:@"please login"]) {
        
        OtherLogin *other = [OtherLogin standerDefault];
        [other otherAreaLogin];
        return;
    }
    
    NSArray *resultArray=[resultDic valueForKey:@"data"];
    
    for (int i=0;i<[resultArray count];i++) {
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
        [_dataArray addObject:positionmodel];
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
    
    if ([resultArray count]<20) {
        
        [self removeFooterView];
        
        if (page!=1) {
            ghostView.message=@"主人，已为您加载所有职位!";
            [ghostView show];
        }
        
    }else
    {
        [self setFooterView];
    }
}

-(void)receiveRequestFail:(NSError *)error
{
    [loadView hide:YES];
    NSLog(@"下载失败。。。。");
}

-(void)requestTimeOut2
{
    [loadView hide:YES];
    NSLog(@"请求超时。。。。");
}


-(void)receiveDataFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic is %@",resultDic);
    
    NSString *errorStr=[resultDic valueForKey:@"error"];
    if (errorStr&&errorStr.integerValue==0) {
        
        ghostView.message=@"投递成功";
        [ghostView show];
        
    }

    else{
        ghostView.message=@"投递失败";
        [ghostView show];
    }
    //
    if ([selectArray count]!=0) {
        [selectArray removeAllObjects];
        [_tableView reloadData];
        [postBtn setTitle:@"" forState:UIControlStateNormal];
        postBtn.alpha=0;
        deliveryBtn.alpha=0;
        shoucangBtn.alpha=1;
    }else
    {
        [_tableView reloadData];
        [postBtn setTitle:@"" forState:UIControlStateNormal];
        postBtn.alpha=0;
        deliveryBtn.alpha=0;
        shoucangBtn.alpha=1;
    }
}

-(void)receiveDataFail:(NSError *)error
{
    ghostView.message=@"下载失败";
    [ghostView show];
}

-(void)requestTimeOut
{
    ghostView.message=@"请求超时";
    [ghostView show];
}



#pragma mark  UITableView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
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
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = [UIColor darkGrayColor];
    companyNameLab.font = [UIFont systemFontOfSize:12];
    
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
    
    //从数据源中取出数据
    PositionModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    jobNameLab.text=model.jobName;
    companyNameLab.text=model.companyName;
    salaryLab.text=model.salary;
    dateLab.text=model.pubDate;
    
    //调整button上标题的位置
    collectBtn = [myButton buttonWithType:UIButtonTypeCustom];
    
    collectBtn.tag = indexPath.row;
    
    collectBtn.frame = CGRectMake(0,0,100,50);
    
    UIImageView* collectImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5,10,30,30)];
    
    collectImageView.tag=101;
    
    [collectBtn addSubview:collectImageView];
    
    if ([selectArray containsObject:model]) {
        
        collectImageView.image=[UIImage imageNamed:@"selectedjob.png"];
        
    }else
    {
        collectImageView.image=[UIImage imageNamed:@"noselectjob.png"];
    }
    
    [collectBtn addTarget:self action:@selector(collectionJob:)
         forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:collectBtn];
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantou.frame = CGRectMake(300, 15, 15, 15);
    [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                       forState:UIControlStateNormal];
    [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                       forState:UIControlStateHighlighted];
    [cell.contentView addSubview:jiantou];
    [cell.contentView addSubview:jobNameLab];
    [cell.contentView addSubview:companyNameLab];
    [cell.contentView addSubview:salaryLab];
    [cell.contentView addSubview:dateLab];
    
    if (!detail){   //处于简单状态下时
        
    }else
    {
        //处于详细状态时
        collectBtn.frame = CGRectMake(0,0,100,100);
        UIImageView* imageView=(UIImageView *)[collectBtn viewWithTag:101];
        
        imageView.frame=CGRectMake(5,35,30,30);
        
        jiantou.frame = CGRectMake(300,45,15, 15);
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,45,260,10)];
        detailLabel.backgroundColor=[UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        NSString *detailStr=[NSString stringWithFormat:@"%@|%@",model.degree,model.workExperience];
        NSLog(@"detailStr in JobSeeVC is %@",detailStr);
        detailLabel.text=detailStr;
        [cell.contentView addSubview:detailLabel];
        
        UILabel *requireLabel=[[UILabel alloc]initWithFrame:CGRectMake(40,58,260,40)];
        requireLabel.numberOfLines=0;
        requireLabel.backgroundColor=[UIColor clearColor];
        requireLabel.textColor = [UIColor darkGrayColor];
        requireLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *requireStr=[NSString stringWithFormat:@"%@",model.required];
        NSLog(@"requireStr in JobSeeVC is %@",requireStr);
        requireLabel.text=requireStr;
        [cell.contentView addSubview:requireLabel];
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
    }
    
    return 0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JobReaderDetailViewController * jobDetailVC = [[JobReaderDetailViewController alloc] init];
    jobDetailVC.dataArray=_dataArray;
    jobDetailVC.index=indexPath.row;
    [self.navigationController pushViewController:jobDetailVC animated:YES];
}


- (void)enterReadJob:(id)sender
{
    ReaderViewController *readVC = [[ReaderViewController alloc] init];
    [self.navigationController pushViewController:readVC animated:YES];
}


//返回上一页
- (void)backUpVC:(id)sender
{
    NSArray *array=self.navigationController.viewControllers;
    
    if ([array count]==4) {
        [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//职位来源
- (void)jobSource:(id)sender
{
    JobSourceViewController *jobSourse = [[JobSourceViewController alloc]init];
    [self.navigationController pushViewController:jobSourse animated:YES];
}

#pragma mark collectionJob响应
- (void)collectionJob:(id)sender
{
    myButton *btn=(myButton *)sender;
    btn.isClicked=!btn.isClicked;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    PositionModel *model=[_dataArray objectAtIndex:btn.tag];
    
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


/*拼接参数字符串
 *cj,yes代表职位id，no，代表企业id
 */
- (NSString *)stringByCompanyOrJob:(NSArray *)jobArray cj:(BOOL)com
{
    NSMutableString *jobsId = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i<jobArray.count; i++) {
        JobInfo *info = [jobArray objectAtIndex:i];
        NSString *cjid = nil;
        if (com) {
            cjid = info.job_id;
        }else
        {
            cjid = info.pid;
        }
        
        if (i == 0) {
            [jobsId appendString:cjid];
        }else
        {
            [jobsId appendFormat:@"*%@",cjid];
        }
    }
    return jobsId;
}




- (NSString *)messageContent
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

#pragma mark 添加标题文件
-(void)addTitleLabel:(NSString*)title{
    NSLog(@"title in JobSeeVC  and addTitleLabel is %@",title);
    titleLabelx.text=title;
    titleLabely.text=title;
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
            str =[str stringByAppendingString:model.companyId];
            
        }else
        {
            str =[str stringByAppendingString:model.companyId];
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
            NSString *subStr=[NSString stringWithFormat:@"%@",model.cityCode];
            str =[str stringByAppendingString:subStr];
        }else
        {
            NSString *subStr=[NSString stringWithFormat:@"%@",model.cityCode];
            str =[str stringByAppendingString:subStr];
            str=[str stringByAppendingString:@"-"];
        }
    }
    return str;
}

#pragma mark UIAlertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag!=101) {
        
        if (buttonIndex==1) {
            
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
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
            [request setCompletionBlock:^{
                [loadView setHidden:YES];
                NSError *error;
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
                NSString *errorStr=[resultDic valueForKey:@"error"];
                if (errorStr&&errorStr.integerValue==0) {
                    
                    ghostView.message=@"投递成功";
                    [ghostView show];
                }
                else{
                    ghostView.message=@"投递失败";
                    [ghostView show];
                }
                if ([selectArray count]!=0) {
                    [selectArray removeAllObjects];
                    [_tableView reloadData];
                    [postBtn setTitle:@"" forState:UIControlStateNormal];
                    postBtn.alpha=0;
                    deliveryBtn.alpha=0;
                    shoucangBtn.alpha=1;
                }else
                {
                    [_tableView reloadData];
                    [postBtn setTitle:@"" forState:UIControlStateNormal];
                    postBtn.alpha=0;
                    deliveryBtn.alpha=0;
                    shoucangBtn.alpha=1;
                }
                
                
            }];
            [request setFailedBlock:^{
                [loadView hide:YES];
                ghostView.message=@"投递失败";
                [ghostView show];
            }];
            [request startAsynchronous];
        }
    }else
    {
        
    
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
