//
//  HR_ResumeRecommendListViewController.m
//  JobKnow
//
//  Created by Suny on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeRecommendListViewController.h"
#import "HRReumeModel.h"
#import "HRJobSortModel.h"
#import "MJRefresh.h"

@interface HR_ResumeRecommendListViewController ()

@end

@implementation HR_ResumeRecommendListViewController

-(void)initData
{
    all=0;//累计新增
    
    today=0;//今日新增
    
    currentPage=1;//搜索页数
    
    pageCount = 1;//总页数
    
    currentPage_other = 1;//其他当前页
    
    pageCount_other = 1; //其他总页数
    
    num=ios7jj;
    
    
    //    db=[UserDatabase sharedInstance];
    
    
    
    dataArray=[[NSMutableArray alloc]init];//简历数据源
    
    dataArray_jobSort =[[NSMutableArray alloc]init];//jobSort数据源
    
    selectArray = [[NSMutableArray alloc]init];//存储选择的positionModel职位的数组
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
    
    
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

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{
//    HR_ResumeAdd *add = [[HR_ResumeAdd alloc] init];
//    add.resumeListVC = self;
//    [self.navigationController pushViewController:add animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
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
            [navTitle setText:@"简历-全部"];
            [navTitle setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readBtnClick:)];
            [navTitle addGestureRecognizer:tap];
            //            uicontroleve
            [navTitle setTextAlignment:NSTextAlignmentCenter];
            [navTitle setBackgroundColor:[UIColor clearColor]];
            [navTitle setFont:[UIFont systemFontOfSize:18]];
            [navTitle setNumberOfLines:0];
            [navTitle setTag:999];
            [navTitle setTextColor:[UIColor whiteColor]];
            [self.view addSubview:navTitle];
            
        }
        else{
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
            }
            else{
                //右按钮
                
//                if (IOS7) {
//                    btn.frame = CGRectMake(iPhone_width-40,24,35,35);
//                }else
//                {
//                    btn.frame = CGRectMake(iPhone_width-40,10,35,35);
//                }
//                
//                [btn setImage:[UIImage imageNamed:@"hrcircle_ic_action_menu"] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"hrcircle_ic_action_menu"] forState:UIControlStateHighlighted];
//                [btn  addTarget:self action:@selector(readBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
       }
    }
    
    [self initTableView];
    [self initBottomView];
    
    if ([[HR_ResumeShareTool defaultTool] haveData]) {
        dataArray = [HR_ResumeShareTool defaultTool].array_Resume;
        dataArray_jobSort = [HR_ResumeShareTool defaultTool].array_JobSort;
        if (!resumeView) {
            resumeView=[[ResumeFilterView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height) andDataArray:dataArray_jobSort];
            resumeView.delegate=self;
            [self.view addSubview:resumeView];
        }else{
            resumeView.dataArray = dataArray_jobSort;
            [resumeView.myTableView reloadData];
        }
        [self.tableView reloadData];
        [self requestDataWithPage:currentPage];
    }else{
        [self requestDataWithPage:currentPage];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:NOTI_ReloadResumeListFromWeb object:nil];
    
}

-(void)initTableView{
    _tableView = [[UITableView alloc] init];
    if (IOS7) {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num -40)];
    }else
    {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num -40)];
        
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XZHILBJ_colour;
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
    if (!isOtherPage) {
        currentPage =1;
        [self requestDataWithPage:currentPage];
    }else{
        currentPage_other = 1;
        [self requestDataWithJobId:jobSortId Page:currentPage_other];
    }
    
    
}
- (void)footerRefresh{
    if (!isOtherPage) {
        currentPage ++;
        [self requestDataWithPage:currentPage];
    }else{
        currentPage_other ++;
        [self requestDataWithJobId:jobSortId Page:currentPage_other];
    }
    
}

-(void)initBottomView{
    UIView *view_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, iPhone_height-40, iPhone_width, 40)];
    [view_bottom setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view_bottom];
    
    btn_all = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 60, 40)];
    [btn_all setImage:[UIImage imageNamed:@"hrcircle_resume_check_default"] forState:UIControlStateNormal];
    [btn_all setImage:[UIImage imageNamed:@"hrcircle_resume_checked"] forState:UIControlStateSelected];
    [btn_all setTitle:@"全选" forState:UIControlStateNormal];
    [btn_all setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_all.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn_all setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn_all setTitleEdgeInsets:UIEdgeInsetsMake(0,7, 0, 0)];
    [btn_all addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_all.tag = 1;
    [view_bottom addSubview:btn_all];
    
    btn_anonymous = [[UIButton alloc] initWithFrame:CGRectMake(95, 0, 80, 40)];
    [btn_anonymous setImage:[UIImage imageNamed:@"hrcircle_resume_check_default"] forState:UIControlStateNormal];
    [btn_anonymous setImage:[UIImage imageNamed:@"hrcircle_resume_checked"] forState:UIControlStateSelected];
    [btn_anonymous setTitle:@"匿名推荐" forState:UIControlStateNormal];
    [btn_anonymous setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_anonymous.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btn_anonymous setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn_anonymous setTitleEdgeInsets:UIEdgeInsetsMake(0,7, 0, 0)];
    [btn_anonymous addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_anonymous.tag = 2;
//    [view_bottom addSubview:btn_anonymous];
    
    UIButton *btn_rec = [[UIButton alloc] initWithFrame:CGRectMake(iPhone_width - 80, 0, 80, 40)];
    [btn_rec setBackgroundColor:XZhiL_colour];
    [btn_rec setTitle:@"推 荐" forState:UIControlStateNormal];
    [btn_rec setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_rec addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    btn_rec.tag = 3;
    [view_bottom addSubview:btn_rec];
}

-(void)requestData{
    [self requestDataWithPage:1];
}

#pragma mark 网络连接方法
-(void)requestDataWithPage:(int)page
{
    
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KWWWXZhiLiaoAPI,HRResumeList);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",@"20",@"count",_model_job.postId,@"jobId",@"1",@"type",_model_job.companyId,@"companyId",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
        NSDictionary *resultDics=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSNumber *errorNumber =[resultDics valueForKey:@"error_code"];
        
        if(!resultDics||[errorNumber isEqualToNumber:@101]){
            
//            ghostView.message=@"请重新登录";
//            [ghostView show];
            
            return ;
        }
        if(errorNumber.integerValue == 0){
            NSLog(@"请求成功");
            NSMutableDictionary * resultDic = resultDics[@"data"];
            NSMutableArray *array=[resultDic objectForKey:@"resumeList"];
            if (currentPage == 1) {
                [dataArray removeAllObjects];
                [dataArray_jobSort removeAllObjects];
                [[HR_ResumeShareTool defaultTool] clearData];
                [selectArray removeAllObjects];
                btn_all.selected = NO;
            }
            
            int b = [[resultDic objectForKey:@"resumeCount"] intValue];
            pageCount = b/20+1;
            
            if ([array count]==0 && currentPage==1) {
                ghostView.message=@"暂无可推荐简历!";
                [ghostView show];
                [self.tableView reloadData];
                return;
            }
            
            for (NSDictionary *item in array) {
                HRReumeModel *resumeModel = [[HRReumeModel alloc] initWithDictionary:item];
                [dataArray addObject:resumeModel];
            }
            
            for (NSDictionary *item in [resultDic objectForKey:@"jobSort"]) {
                HRJobSortModel *jobSortModel = [[HRJobSortModel alloc] initWithDictionary:item];
                [dataArray_jobSort addObject:jobSortModel];
            }
            
            if (!resumeView) {
                resumeView=[[ResumeFilterView alloc]initWithFrame:CGRectMake(0,44+num,iPhone_width,iPhone_height) andDataArray:dataArray_jobSort];
                resumeView.delegate=self;
                [self.view addSubview:resumeView];
            }else{
                resumeView.dataArray = dataArray_jobSort;
                [resumeView.myTableView reloadData];
            }
            
            
            [[HR_ResumeShareTool defaultTool] addArray:dataArray];
            [[HR_ResumeShareTool defaultTool] addJobArray:dataArray_jobSort];
            if ([[HR_ResumeShareTool defaultTool] haveData]) {
                NSLog(@"添加简历共享数据成功！");
            }
            
            [self.tableView reloadData];
            
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
    }];
    [request startAsynchronous];
    
}

#pragma mark 网络连接方法
-(void)requestDataWithJobId:(NSString *)jobId Page:(int)page
{
    //    Net *n=[Net standerDefault];
    
    //    if (n.status ==NotReachable) {
    //        ghostView.message=@"无网络连接,请检查您的网络!";
    //        [ghostView show];
    //        return;
    //    }
    
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KWWWXZhiLiaoAPI,HRResumeList);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",@"20",@"count",jobSortId,@"jobSortId",_model_job.postId,@"jobId",@"1",@"type",_model_job.companyId,@"companyId",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSNumber *errorNumber =[resultDic valueForKey:@"error_code"];
        
        if(!resultDic||[errorNumber isEqualToNumber:@101]){
            
            ghostView.message=@"请重新登录";
            [ghostView show];
            return ;
        }
        if(errorNumber.integerValue == 0){
            NSLog(@"请求成功");
            
            NSMutableArray *array=[resultDic objectForKey:@"resumeList"];
            if (currentPage_other == 1) {
                [dataArray removeAllObjects];
                [selectArray removeAllObjects];
                btn_all.selected = NO;
            }
            
            int b = [[resultDic objectForKey:@"resumeCount"] intValue];
            pageCount_other = b/20+1;
            
            if ([array count]==0 && currentPage_other==1) {
                ghostView.message=@"暂无数据!";
                [ghostView show];;
                [_tableView reloadData];
                return;
            }
            
            for (NSDictionary *item in array) {
                HRReumeModel *resumeModel = [[HRReumeModel alloc] initWithDictionary:item];
                [dataArray addObject:resumeModel];
            }
            
            
            [self.tableView reloadData];
            
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        
    }];
    [request startAsynchronous];
    
}

#pragma mark- HR_ResumeAddDelegate
-(void)addModelWithModel:(HRReumeModel *)model{
    if (!isOtherPage) {
        currentPage = 1;
        [self requestDataWithPage:currentPage];
    }else{
        currentPage_other = 1;
        [self requestDataWithJobId:jobSortId Page:currentPage_other];
    }
    
}

#pragma mark- ResumeFilterViewDelegate
-(void)resumeFilterViewChange:(HRJobSortModel *)model_JobSort
{
    [navTitle setText:[NSString stringWithFormat:@"简历-%@",model_JobSort.name]];
    jobSortId = model_JobSort.jobSortId;
    if (![model_JobSort.name isEqualToString:@"全部"]) {
        isOtherPage = YES;
        currentPage_other = 1;
        [self requestDataWithJobId:jobSortId Page:currentPage_other];
    }else{
        currentPage = 1;
        [self requestDataWithPage:currentPage];
    }

    
    
}

//#pragma mark readBtn响应事件(就是右上角的三个点)
//-(void)readBtnClick:(id)sender
//{
////    if(!resumeView)
////        return;
//    
//    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:10000];
//    
//    [imageView removeFromSuperview];
//    
//    UILabel *lab=(UILabel *)[self.view viewWithTag:10001];
//    
//    [lab removeFromSuperview];
//    
//    NSLog(@"订阅器界面被点击");
//    if (resumeView.alpha==0) {
//        
//        [UIView animateWithDuration:0.2 animations:^{
//            resumeView.alpha=1;
//            [resumeView.myTableView reloadData];
//        }];
//    }else
//    {
//        [UIView animateWithDuration:0.2 animations:^{
//            resumeView.alpha=0;
//            [resumeView.myTableView reloadData];
//        }];
//    }
//}
#pragma mark- 底部按钮点击
-(void)bottomButtonClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            //全选
            if (btn.selected) {
                [selectArray removeAllObjects];
                NSLog(@"取消全选 \n selectArray.cout = %d ,dataArray.cout =  %d",selectArray.count,dataArray.count);
                [self.tableView reloadData];
                btn.selected = NO;
            }else{
                [selectArray removeAllObjects];
                NSMutableArray *array = [NSMutableArray arrayWithArray:dataArray];
//                selectArray =
//                for (HRReumeModel *item in array) {
//                    if (![[NSString stringWithFormat:@"%@",item.in_7_days] isEqualToString:@"1"]) {
//                        [selectArray addObject:item];
//                    }
//                }
//                NSLog(@"全选 \n selectArray.cout = %d ,dataArray.cout =  %d",selectArray.count,dataArray.count);
//                if (selectArray.count != dataArray.count) {
//                    ghostView.message=@"您只能推荐7天内没有被其他HR抢先推荐的人才哦！";
//                    [ghostView show];
//                }
                [self.tableView reloadData];
                btn.selected = YES;
            }
        }
            break;
        case 2:
        {
            //匿名
//            btn.selected = !btn.selected;
        }
            break;
        case 3:
        {
            //推荐
            
            selectArray;
            if(!selectArray.count>0){
                ghostView.message=@"暂无简历";
                [ghostView show];
                return;
            }
//            for (HRReumeModel *item in selectArray) {
//                if ([[NSString stringWithFormat:@"%@",item.resumePrice] isEqualToString:@"0"]||[[NSString stringWithFormat:@"%@",item.resumePrice] isEqualToString:@""]||!item.resumePrice) {
//                    ghostView.message=@"请先设定简历价格";
//                    [ghostView show];
//                    return;
//
//                }else if([item.resumePrice integerValue]>50){
//                    ghostView.message=@"被推荐简历的价格须在50元之内哦，您可以到简历详情页中编辑简历价格";
//                    [ghostView setTimeout:5];
//                    [ghostView show];
//                    return;
// 
//                }
//                
//            }
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            loadView.userInteractionEnabled=NO;
            //http://www.xzhiliao.com/api/hr_api/recommend/deliver?version=3.2.1&userToken=44ba1a7e2d6e708b01f63148e8c8904e&userImei=05fc953069163de777b294de9265f2dce5dff561post参数：jobId 职位的id
            

            NSString *urlStr=kCombineURL(KWWWXZhiLiaoAPI,HRResumeRecommend);
            NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
            NSString *user_uid = [AppUD valueForKey:@"userUid"];
            NSUserDefaults *UserToken = mUserDefaults;
            NSString * pcUserId = [UserToken valueForKey:@"pcUserId"];
            [UserToken synchronize];
            NSLog(@"pcUserId 缓存到的是 is %@",pcUserId);

            NSMutableDictionary *paramDic=[NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pcUserId,@"pid",nil];
            [paramDic setValue:_model_job.companyId forKey:@"companyId"];
            [paramDic setValue:_model_job.postId forKey:@"jobId"];
            [paramDic setValue:_model_job.jobName forKey:@"jobName"];
            [paramDic setValue:_model_job.cityCode forKey:@"localcity"];
//            [paramDic setValue:_model_job.senior_type forKey:@"senior_type"];
            NSString *string = [[NSString alloc] init];
             NSString *content = [[NSString alloc] init];
            NSString *workyear = [[NSString alloc] init];
            for (HRReumeModel *item in selectArray) {
                string = [NSString stringWithFormat:@"%@,%@-%@",string,item.resumeUid,item.resumePid];
                if ([item.workYear isEqualToString:@"不限"]||[item.workYear isEqualToString:@"在读学生"]||[item.workYear isEqualToString:@"应届毕业生"]||[item.workYear isEqualToString:@"在读"]) {
                    workyear = item.workYear;
                }else if([item.workYear integerValue]<=0){
                    if ([item.workYear isEqualToString:@"-2"]) {
                        workyear = @"不限";
                    }else if ([item.workYear isEqualToString:@"-1"]){
                        workyear = @"在读学生";
                    }else if ([item.workYear isEqualToString:@"0"]){
                        workyear = @"应届毕业生";
                    }
                }else
                    workyear = [NSString stringWithFormat: @"%@年",item.workYear];

                if ([item.recommend isEqualToString:@""]||!item.recommend) {
                     content = [NSString stringWithFormat:@"%@^*简历:%@,推荐职位:%@,工作经验:%@",content,item.name,_model_job.jobName,workyear];
//                    if ([_model_job.senior_type isEqualToString:@"1"]) {
//                       
//                    }else{
//                        content = [NSString stringWithFormat:@"%@^*简历:%@,推荐职位:%@,工作经验:%@,联系电话:%@",content,item.name,_model_job.jobName,workyear,item.mobile];
//                    }
                    
                }else {
                     content = [NSString stringWithFormat:@"%@^*简历:%@,推荐职位:%@,工作经验:%@,推荐语:%@",content,item.name,_model_job.jobName,workyear,item.recommend];
//                    if ([_model_job.senior_type isEqualToString:@"1"]) {
//                        content = [NSString stringWithFormat:@"%@^*简历:%@,推荐职位:%@,工作经验:%@,推荐语:%@",content,item.name,_model_job.jobName,workyear,item.recommend];
//                    }else{
//                        content = [NSString stringWithFormat:@"%@^*简历:%@,推荐职位:%@,工作经验:%@,联系电话:%@,推荐语:%@",content,item.name,_model_job.jobName,workyear,item.mobile,item.recommend];
//                    }
                    
                }
            }
            NSString *str = [string substringToIndex:1];
            if ([str isEqualToString:@","]) {
                string = [string substringFromIndex:1];
            }
            
            NSString *str_con = [content substringToIndex:2];
            if ([str_con isEqualToString:@"^*"]) {
                content = [content substringFromIndex:2];
            }
            [paramDic setValue:string forKey:@"uidAndPid"];
            [paramDic setValue:_model_job.newfee forKey:@"money"];
            [paramDic setValue:content forKey:@"content"];
            [paramDic setValue:btn_anonymous.selected?@"0":@"1" forKey:@"isAnonymity"];
//            [paramDic setValue:_model_job.senior_type forKey:@"senior_type"];//0效果招聘,1按简历付费
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];

            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
            [request setCompletionBlock:^{
                
                [loadView hide:YES];
                
                NSError *error;
                
                NSDictionary *resultDics=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
                NSString *errorStr =[resultDics valueForKey:@"error"];
                if(errorStr.integerValue == 0){
                    NSLog(@"推荐成功");
                    ghostView.message=@"推荐成功";
                    [ghostView show];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataWhenRecommendResume" object:nil];
                    [self performSelector:@selector(popToLastViewController) withObject:nil afterDelay:1];
                    return ;
                    
                }
                
            }];
            [request setFailedBlock:^{
                [loadView hide:YES];
                ghostView.message=@"推荐完成";
                [ghostView show];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataWhenRecommendResume" object:nil];
                [self performSelector:@selector(popToLastViewController) withObject:nil afterDelay:1];
                return ;

                
            }];
            [request startAsynchronous];

            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark 登录按钮登录回调
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic in receiveDataFinish and LoginViewController is %@",resultDic);
    
    NSString *errorStr =[resultDic valueForKey:@"error"];
    
    if(request.tag == 1){
        if (resultDic&&resultDic.count!=0&&errorStr.integerValue ==0) { //如果登录成功，error的返回值保存下来
            
            NSLog(@"推荐成功");
           ghostView.message=@"推荐成功";
           [ghostView show];
           [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataWhenRecommendResume" object:nil];
           [self performSelector:@selector(popToLastViewController) withObject:nil afterDelay:1];
           return ;
        }else if (errorStr.integerValue ==1)
        {
            ghostView.message=@"您尚未注册，请先注册账号";
            [ghostView show];
            
            return;
        }else if (errorStr.integerValue ==2)
        {
            ghostView.message=@"您的密码输入错误!";
            [ghostView show];
            
            return;
        }else if (errorStr.integerValue ==3)
        {
            ghostView.message=@"登录用户非个人";
            [ghostView show];
            return;
        }else if (errorStr.integerValue ==4)
        {
            ghostView.message=@"您已下线超过24小时";
            [ghostView show];
            return;
        }
        
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [loadView hide:YES];
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"resultDic in receiveDataFinish and LoginViewController is %@",resultDic);
    
    NSString *errorStr =[resultDic valueForKey:@"error"];

    ghostView.message=@"推荐完成!";
    [ghostView show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadDataWhenRecommendResume" object:nil];
    [self performSelector:@selector(popToLastViewController) withObject:nil afterDelay:1];
}

//返回上一页
-(void)popToLastViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- HR_ResumePriceEditDelegate
- (void)afterPriceEditSucceed{
    if (!isOtherPage) {
        currentPage = 1;
        [self requestDataWithPage:currentPage];
    }else{
        currentPage_other = 1;
        [self requestDataWithJobId:jobSortId Page:currentPage_other];
    }
}

#pragma mark- HR_ResumeRecListCellDelegate
- (void)chooseBtnClickInRow:(NSIndexPath *)indexPath
{
    NSLog(@"选择按钮被点击了。。。。");
    
    UIButton *btn=(UIButton *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:21];
        NSLog(@"cell 的tag = %d",indexPath.row);
    HRReumeModel *model=[dataArray objectAtIndex:indexPath.row];
//    if ([[NSString stringWithFormat:@"%@",model.in_7_days] isEqualToString:@"1"]) {
//        ghostView.message=@"哎呀，这个人才7天内已被其他HR率先推荐过了，你可以过几天再试";
//        [ghostView show];
//        return;
//    }
    
    if ([selectArray containsObject:model]){
        [selectArray removeObject:model];
        btn.selected=NO;

    }else
    {
        [selectArray addObject:model];
        btn.selected = YES;
    }
    
    if ([selectArray count]!=0) {
        
    }else
    {
       
    }
    
    NSString *count=[NSString stringWithFormat:@"%d",[selectArray count]];
    NSLog(@"选中了 %@  个简历",count);
}
#pragma mark- HR_ResumeListCellDelegate
- (void)addResumePriceFromRec:(HRReumeModel *)resumeModel IndexPath:(NSIndexPath *)indexPath
{
    HR_ResumePriceEdit *priceList = [[HR_ResumePriceEdit alloc] init];
    priceList.isFromResumeList = YES;
    priceList.resumeModel = resumeModel;
    priceList.indexPath = indexPath;
    priceList.delegate = self;
    [self.navigationController pushViewController:priceList animated:YES];
}

#pragma mark  UITableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =[indexPath row];
   static  NSString *CellIdentifier = @"cell";
    HR_ResumeRecListCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HR_ResumeRecListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.delegate = self;
    cell.indexPath_fromList = indexPath;
    [cell setModel:[dataArray objectAtIndex:row]];
    UIButton *btn;
    for (UIView *item in cell.subviews) {
        if (item.tag == 21 &&[item isKindOfClass:[UIButton class]]) {
            btn = (UIButton *)item;
        }
    }
    
    HRReumeModel *model=[dataArray objectAtIndex:indexPath.row];
    if ([selectArray containsObject:model]){
        btn.selected=YES;
    }else
    {
        btn.selected = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HR_ResumeDetail *detail = [[HR_ResumeDetail alloc] init];
    detail.resumeModelFromList = [dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
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
