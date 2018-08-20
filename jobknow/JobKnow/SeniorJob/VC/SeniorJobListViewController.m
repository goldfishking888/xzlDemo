//
//  SeniorJobListViewController.m
//  JobKnow
//
//  Created by Suny on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//
//人才增值收益权
#import "SeniorJobListViewController.h"
#import "collectViewController.h"
#import "positionModel.h"//3.3.1
#import "MJRefresh.h"
#import "HomeBannerJumpWebViewController.h"//banner 跳转
#define cell_index_space 14

#define cell_inner_space 20

@interface SeniorJobListViewController ()

@end

@implementation SeniorJobListViewController

-(void)initData
{
    all=0;//累计新增
    
    today=0;//今日新增
    
    currentPage=1;//搜索页数
    
    pageCount = 1;//总页数
    
    currentPage_other = 1;//其他当前页
    
    pageCount_other = 1; //其他总页数
    
    num=ios7jj;
    
    detail = NO;
    //    db=[UserDatabase sharedInstance];
    
    
    dataArray=[[NSMutableArray alloc]init];//简历数据源
    
    dataArray_jobSort =[[NSMutableArray alloc]init];//jobSort数据源
    
    selectArray = [[NSMutableArray alloc]init];//存储选择的positionModel职位的数组
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
}

-(void)titleBtnClick{
    NSMutableArray *cityArray = [NSMutableArray arrayWithArray:[mUserDefaults valueForKey:@"SeniorCityArray"]];
    NSMutableArray *cityArray_change = [[NSMutableArray alloc] init];
    for (NSDictionary *item in cityArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:item];
        [cityArray_change addObject:dic];
    }
    SeniorCityListViewController *cityList = [[SeniorCityListViewController alloc] init];
    cityList.dataArray = cityArray_change;
    cityList.delegate = self;
    [self.navigationController pushViewController:cityList animated:YES];
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{
    [self.drawer open];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initData];
    
    //默认不筛选 拉取全部数据
    isFilterSearch = NO;
    
    self.view.backgroundColor = XZHILBJ_colour;
    //顶部导航栏样式
    for (int i=0; i<4; i++) {
        if (i==0) {
            //图片
            UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+num)];
            titleIV.backgroundColor = RGBA(255, 115, 4, 1);
            [self.view addSubview:titleIV];
            
        }else if(i==3){
            //标题
            navTitle =[[UILabel alloc] initWithFrame:CGRectMake(50, 0+Frame_Y, 210, 44)];
            [navTitle setText:@"人才增值收益权职位-"];
            [navTitle setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleBtnClick)];
            [navTitle addGestureRecognizer:tap];
            [navTitle setTextAlignment:NSTextAlignmentCenter];
            [navTitle setBackgroundColor:[UIColor clearColor]];
            [navTitle setFont:[UIFont systemFontOfSize:18]];
            [navTitle setNumberOfLines:0];
            [navTitle setTag:999];
            [navTitle setTextColor:[UIColor whiteColor]];
            [self.view addSubview:navTitle];
        }else{
            //左右按钮
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            if (i==1) {
                //左按钮
                [btn setFrame:CGRectMake(10, Frame_Y+5, 50, 30)];
                [btn setEnabled:true];
                [btn setBackgroundColor:[UIColor clearColor]];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                [btn setTitleColor:[UIColor colorWithHex:0x2c2c2c alpha:1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(leftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //去掉右侧按钮
                //                //右按钮
                //                if (IOS7) {
                //                    btn.frame = CGRectMake(iPhone_width-40,24,30,30);
                //                }else
                //                {
                //                    btn.frame = CGRectMake(iPhone_width-40,10,30,30);
                //                }
                //
                //                [btn setImage:[UIImage imageNamed:@"ic_action_more"] forState:UIControlStateNormal];
                //                [btn setImage:[UIImage imageNamed:@"ic_action_more"] forState:UIControlStateHighlighted];
                //                [btn  addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
    }
    [self initTableView];
    
    [self initBottomView];
    
    
    if (![mUserDefaults valueForKey:@"SeniorCityArray"]) {
        cityStr = [mUserDefaults valueForKey:@"DingweiCity"];
        XZLLocaRead *read = [[XZLLocaRead alloc] init];
        cityCode = [read getCodeNameStr:cityStr];
        [navTitle setText:[NSString stringWithFormat:@"人才增值收益权职位-%@",cityStr]];
        [self requestCityData];
    }else{
        NSMutableArray *cityArray = [NSMutableArray arrayWithArray:[mUserDefaults valueForKey:@"SeniorCityArray"]];
        for (NSDictionary *item in cityArray) {
            if ([[item valueForKey:@"isSelected"] isEqualToString:@"1"]) {
                cityStr = [item valueForKey:@"city"];
                cityCode = [item valueForKey:@"code"];
            }
        }
        if(!cityStr){
            cityStr = [mUserDefaults valueForKey:@"DingweiCity"];
            XZLLocaRead *read = [[XZLLocaRead alloc] init];
            cityCode = [read getCodeNameStr:cityStr];
        }
        
        [navTitle setText:[NSString stringWithFormat:@"人才增值收益权职位-%@",cityStr]];
    }
    [self requestDataWithPage:currentPage];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:nil object:nil];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] init];
    if (IOS7) {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num-45)];
    }else
    {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num-45)];
        
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    // 下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"下拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    // 上拉刷新
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"上拉加载更多";
    _tableView.footerReleaseToRefreshText = @"松开马上加载";
    _tableView.footerRefreshingText = @"努力加载中……";
    
}

#pragma mark - 下拉刷新的方法、上拉刷新的方法
- (void)headerRefresh{
    currentPage =1;
    // 取新
    [self requestDataWithPage:currentPage];
    
}
- (void)footerRefresh{
    currentPage ++;
    // 取历史记录
    [self requestDataWithPage:currentPage];
    
}

-(void)initBottomView{
    //底部背景条
    UIView *bottomView = [[UIView alloc]init];
    bottomView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:55/255.0 green:55/255.0 blue:66/255.0 alpha:1];
    if(IOS7){
        bottomView.frame = CGRectMake(0,iPhone_height - 45,iPhone_width,45);
    }else
    {
        bottomView.frame = CGRectMake(0,iPhone_height -65,iPhone_width,45);
    }
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 1)];
    [view_line setBackgroundColor:color_view_line];
    [bottomView addSubview:view_line];
    
    
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
    
    detailLab = [[UILabel alloc]initWithFrame:CGRectMake(18.5,25,28, 28)];
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
    
    [self.view addSubview:bottomView];
    
}

#pragma mark- 请求职位列表
-(void)requestDataWithPage:(int)page
{
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    if (currentPage !=1) {
        ;
    }else{
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        loadView.userInteractionEnabled=NO;
    }
    
    NSString *urlStr=kCombineURL(KWWWXZhiLiaoAPI,SeniorJobList);
    NSDictionary *paramDic;
    if(!isFilterSearch){
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",pageStr,@"page",cityCode,@"searchLocation",kUserTokenStr,@"userToken",nil];
        
    }else{
        SaveJob *save=[SaveJob standardDefault];
        jobRead *hangye = [save.seniorChoiceArr objectAtIndex:0];
        jobRead *zhiye = [save.seniorChoiceArr objectAtIndex:1];
        jobRead *pailie = [save.seniorChoiceArr objectAtIndex:2];
        jobRead *workExp = [save.seniorChoiceArr objectAtIndex:3];
        jobRead *eduExp = [save.seniorChoiceArr objectAtIndex:4];
        jobRead *companyType = [save.seniorChoiceArr objectAtIndex:5];
        
        paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"imei",pageStr,@"page",cityCode,@"searchLocation",hangye.code,@"searchIndustry",zhiye.code,@"searchPost",pailie.code,@"searchSort",workExp.code,@"searchWorkExperience",eduExp.code,@"searchEducational",companyType.code,@"searchNature",kUserTokenStr,@"token",nil];
    }
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSError *error;
        
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        //        if(!resultDic){
        //            HRLogin *vc = [HRLogin new];
        //            vc.backType = @"BackPersonalVC";
        //            [self.navigationController pushViewController:vc animated:YES];
        //            return ;
        //        }
        if(errorStr.integerValue == 0){
            NSLog(@"请求成功");
            NSMutableDictionary * dics = [resultDic objectForKey:@"data"];
            NSMutableArray *array=[dics objectForKey:@"data"];
            if (currentPage == 1) {
                [dataArray removeAllObjects];
                [dataArray_jobSort removeAllObjects];
                seniorJob_AllCounts = [NSString stringWithFormat:@"%@",dics[@"allCounts"]];
                seniorJob_bonus = dics[@"bouns"];
            }
            
            int b = [[dics objectForKey:@"allCounts"] intValue];
            pageCount = b/20+1;
            
            if ([array count]==0 && currentPage==1) {
                ghostView.message=@"暂无数据!";
                [ghostView show];;
                [self.tableView reloadData];
                return;
            }
            
            if ([array count]==0) {
                pageCount=0;
            }
            
            
            
            for (NSDictionary *item in array) {
                PositionModel *positionmodel=[[PositionModel alloc]initWithDictionary:item];
                [dataArray addObject:positionmodel];
            }
            
            [self.tableView reloadData];
            
            
        }
        
    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
    }];
    [request startAsynchronous];
    
}

-(void)requestCityData
{
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,SeniorJobCityList);
    NSDictionary *paramDic =[NSDictionary dictionaryWithObjectsAndKeys:nil];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"请求成功");
        
        NSMutableArray *array=[resultDic objectForKey:@"city"];
        
        int b = [[resultDic objectForKey:@"count"] intValue];
        
        NSMutableArray *cityArray = [[NSMutableArray alloc] init];
        //        for (NSDictionary *item in array) {
        //            SeniorCityModel *cityInfo = [[SeniorCityModel alloc] init];
        //            cityInfo.city = [item objectForKey:@"city"];
        //            cityInfo.code = [item objectForKey:@"code"];
        //            cityInfo.letter = [item objectForKey:@"letter"];
        //            cityInfo.isSelected = NO;
        //            [cityArray addObject:cityInfo];
        //        }
        
        //        [mUserDefaults setValue:cityArray forKey:@"SeniorCityArray"];
        for (NSMutableDictionary *item in array) {
            [item setValue:@"0" forKey:@"isSelected"];
            [cityArray addObject:item];
        }
        [mUserDefaults setValue:cityArray forKey:@"SeniorCityArray"];
        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
    
}


#pragma mark- BottomButtonClicked
//明细按钮响应事件
-(void)detailVC:(id)sender
{
    
    myButton *btn=(myButton *)sender;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    detail=!detail;
    
    if (!detail){
        imageView.image=[UIImage imageNamed:@"mingxi.png"];
        detailLab.text = @"明细";
    }else
    {
        imageView.image=[UIImage imageNamed:@"mingxi2.png"];
        detailLab.text = @"列表";
    }
    
    [self.tableView reloadData];
    
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
    
    [save seniorChoiceArrInit];
    //
    SeniorJobFilterViewController *selectConditionVC = [[SeniorJobFilterViewController alloc]init];
    selectConditionVC.delegate= self;
    [self.navigationController pushViewController:selectConditionVC animated:YES];
}

#pragma mark UITableView代理方法的实现
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    //从数据源中取出数据
    PositionModel *position = [dataArray objectAtIndex:indexPath.row];
    
    //职位名称
    UILabel *jobNameLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 5, 160,20)];
    jobNameLab.backgroundColor = [UIColor clearColor];
    jobNameLab.textColor = RGBA(40, 100, 210, 1);
    jobNameLab.font = [UIFont boldSystemFontOfSize:14];
    
    //公司名称
    UILabel *companyNameLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 25, 170,20)];
    companyNameLab.backgroundColor = [UIColor clearColor];
    companyNameLab.textColor = [UIColor darkGrayColor];
    companyNameLab.font = [UIFont systemFontOfSize:12];
    
    //地区名称
    UILabel *cityLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 45, 100,20)];
    cityLab.backgroundColor = [UIColor clearColor];
    cityLab.textColor = [UIColor darkGrayColor];
    cityLab.font = [UIFont systemFontOfSize:12];
    
    //职位薪水
    UILabel *salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(165, 5, 80, 20)];
    salaryLab.backgroundColor = [UIColor clearColor];
    salaryLab.font = [UIFont systemFontOfSize:12];
    salaryLab.textColor=RGBA(255, 115, 4, 1);
    salaryLab.textAlignment = NSTextAlignmentRight;
    //效果招聘图标
    UIButton *salaryImgbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    salaryImgbtn.frame = CGRectMake(255, 7, 40, 16);
    [salaryImgbtn setBackgroundImage:[UIImage imageNamed:@"ic_senior"] forState:UIControlStateNormal];
    [salaryLab setHidden:NO];
    
    //发布日期
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(147, 45, 150, 20)];
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.font = [UIFont systemFontOfSize:12];
    
    
    jobNameLab.text=position.jobName;
    companyNameLab.text=position.companyName;
    cityLab.text = position.workArea;
    salaryLab.text= [NSString stringWithFormat:@"%@",position.newfee];//薪水正常读取
    dateLab.text= [NSString stringWithFormat:@"截止日期:%@",position.stopTime];
    
    //调整button上标题的位置
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantou.frame = CGRectMake(300, 27, 15, 15);
    
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
    [cell.contentView addSubview:cityLab];
    [cell.contentView addSubview:salaryLab];
    [cell.contentView addSubview:dateLab];
    [cell.contentView addSubview:salaryImgbtn];
    
    if (!detail){   //处于简单状态下时
        
    }else
    {
        //处于详细状态时
        
        jiantou.frame = CGRectMake(300,48,15, 15);
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell_index_space,65,260,10)];
        detailLabel.backgroundColor=[UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        
        //        NSLog(@"position.degree is %@",position.degree);
        //
        if ([position.degree isEqualToString:@""]) {
            position.degree=@"不限";
        }
        
        NSString *detailStr=[NSString stringWithFormat:@"%@|%@",position.degree,position.workExperience];
        NSLog(@"detailStr in JobSeeVC is %@",detailStr);
        detailLabel.text=detailStr;
        [cell.contentView addSubview:detailLabel];
        
        UILabel *requireLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell_index_space,72,260,40)];
        requireLabel.numberOfLines=0;
        requireLabel.backgroundColor=[UIColor clearColor];
        requireLabel.textColor = [UIColor darkGrayColor];
        requireLabel.font = [UIFont systemFontOfSize:12];
        
        NSString *requireStr=[NSString stringWithFormat:@"%@",position.required];
        NSLog(@"requireStr in JobSeeVC is %@",requireStr);
        requireLabel.text=requireStr;
        [cell.contentView addSubview:requireLabel];
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JobReaderDetailViewController * jobDetailVC = [[JobReaderDetailViewController alloc] init];
    jobDetailVC.dataArray=dataArray;
    jobDetailVC.index=indexPath.row;
    
    PositionModel *model=[dataArray objectAtIndex:indexPath.row];
    NSString * timeStr = model.required;
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    [dataArray[indexPath.row] setValue:timeStr forKey:@"required"];
    jobDetailVC.cityCode=model.cityCode;
    jobDetailVC.isNewAPI = YES;
    
    [self.navigationController pushViewController:jobDetailVC animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!detail) {
        return 70;
    }
    
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 110;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (dataArray.count==0) {
        return nil;
    }
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 110)];
    [viewHead setBackgroundColor:[UIColor whiteColor]];
    
    UIButton * imageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    imageBtn.frame = CGRectMake(0, 0, iPhone_width, 80);
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"ruzhisend"] forState:UIControlStateNormal];
    [imageBtn addTarget:self action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [viewHead addSubview:imageBtn];
    RTLabel *label_rec =  [[RTLabel alloc] initWithFrame:CGRectMake(0,90,iPhone_width ,20)];
    [label_rec setBackgroundColor:[UIColor clearColor]];
    label_rec.font = [UIFont systemFontOfSize:12];
    label_rec.backgroundColor = [UIColor clearColor];
    [label_rec setTextAlignment:RTTextAlignmentCenter];
    //改动:2、	数据标识：“奖金职位”改为“职位数”；去掉奖金总额部分；
    NSString *salaryStr=[NSString stringWithFormat:@"职位数:<font color='#f76806'>%@</font> 条",seniorJob_AllCounts];//,奖金总额:<font color='#f76806'>%@</font>元 ,seniorJob_bonus
    label_rec.text=salaryStr;
    [viewHead addSubview:label_rec];
    return viewHead;
}
-(void)imageButtonClick
{//跳到描述人才增值收益权的web页 关于入职送人才股票
    HomeBannerJumpWebViewController * homeBannerWebVC = [[HomeBannerJumpWebViewController alloc]init];
    homeBannerWebVC.urlStr = SeniorCWHHR;
    homeBannerWebVC.floog = @"关于入职获人才增值收益权";
    [self.navigationController pushViewController:homeBannerWebVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (IOS7) {
        return 0.1;
    }
    
    return 0;
}

#pragma mark- SeniorJobFilterDelegate筛选代理
- (void)finishSelect{
    
    isFilterSearch =YES;
    currentPage = 1;
    [self requestDataWithPage:currentPage];
    
}

#pragma mark- SeniorCityListDelegate筛选代理
- (void)finishSelectCityWithCityCode:(NSString *)code CityName:(NSString *)cityName{
    cityStr = cityName;
    cityCode = code;
    if (!code) {
        XZLLocaRead *read = [[XZLLocaRead alloc] init];
        cityCode = [read getCodeNameStr:cityStr];
    }
    [navTitle setText:[NSString stringWithFormat:@"人才增值收益权职位-%@",cityStr]];
    currentPage = 1;
    [self requestDataWithPage:currentPage];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
