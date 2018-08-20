//
//  HR_ResumeList.m
//  JobKnow
//
//  Created by Suny on 15/8/3.
//  Copyright (c) 2015年 lxw. All rights reserved.
//
//简历库列表
#import "HR_ResumeList.h"
#import "HRReumeModel.h"
#import "HRJobSortModel.h"
#import "MJRefresh.h"
#import "PCResumeTutorViewController.h"

@interface HR_ResumeList ()

@end

@implementation HR_ResumeList

-(void)initData
{
    all=0;//累计新增
    
    today=0;//今日新增
    
    currentPage=1;//搜索页数
    
    pageCount = 1;//总页数
    
    currentPage_other = 1;//其他当前页
    
    pageCount_other = 1; //其他总页数
    
    num=ios7jj;

    height_HeaderView = 55+30;//PC简历教程头部高度

    
    dataArray=[[NSMutableArray alloc]init];//简历数据源
    
    dataArray_jobSort =[[NSMutableArray alloc]init];//jobSort数据源
    
    selectArray = [[NSMutableArray alloc]init];//存储选择的positionModel职位的数组
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{
    if(resumeCount >= resumeCount_limit){
        ghostView.message=@"当前简历数已达上限";
        [ghostView show];;
        return;
    }
    HR_ResumeAdd *add = [[HR_ResumeAdd alloc] init];
    add.resumeListVC = self;
    [self.navigationController pushViewController:add animated:YES];
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
                //右按钮 加号去掉
//            
//                if (IOS7) {
//                    btn.frame = CGRectMake(iPhone_width-40,24,35,35);
//                }else
//                {
//                    btn.frame = CGRectMake(iPhone_width-40,10,35,35);
//                }
//                
//                [btn setImage:[UIImage imageNamed:@"hrcircle_resume_right"] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"hrcircle_resume_right"] forState:UIControlStateHighlighted];
//                [btn  addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];                
            }
            [self.view addSubview:btn];
        }
    }
    
    [self initTableView];
    
    if ([[HR_ResumeShareTool defaultTool] haveData]) {
        dataArray = [HR_ResumeShareTool defaultTool].array_Resume;
        dataArray_jobSort = [HR_ResumeShareTool defaultTool].array_JobSort;
        resumeCount = [HR_ResumeShareTool defaultTool].resumeCount ;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NOTI_ReloadResumeList object:nil];
    
}
-(void)reloadData{
    dataArray = [HR_ResumeShareTool defaultTool].array_Resume;
    resumeCount = [HR_ResumeShareTool defaultTool].resumeCount ;
    [_tableView reloadData];
}

-(void)initTableView{
    _tableView = [[UITableView alloc] init];
    if (IOS7) {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    }else
    {
        [self.tableView setFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
        
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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

-(void)requestData{
    [self requestDataWithPage:1];
}

#pragma mark 网络连接方法
-(void)requestDataWithPage:(int)page
{

    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
//http://www.xzhiliao.com/api/getResumeList?version=3.2.1&userToken=c593b643ade242f632259405de1b34d2&userImei=868433027181654
    NSString *urlStr=kCombineURL(KWWWXZhiLiaoAPI,HRResumeList);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:kAppVersion,@"version",IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",@"20",@"count",nil];
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
            
            
            return ;
        }
        if(errorNumber.integerValue == 0){
            NSLog(@"请求成功");
            NSMutableDictionary * resultDic = resultDics[@"data"];
            resumeLink = [resultDic objectForKey:@"resumeLink"];
            NSMutableArray *array = [resultDic objectForKey:@"resumeList"];
            if (currentPage == 1) {
                [dataArray removeAllObjects];
                [dataArray_jobSort removeAllObjects];
                [[HR_ResumeShareTool defaultTool] clearData];
            }
            
            int b = [[resultDic objectForKey:@"resumeCount"] intValue];
            resumeCount = b;
            resumeCount_limit = [[resultDic objectForKey:@"hrResumeLimit"] integerValue];
            pageCount = b/20+1;
            
            if ([array count]==0 && currentPage==1) {
                ghostView.message=@"暂无数据!";
                [ghostView show];
                [_tableView reloadData];
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
            [HR_ResumeShareTool defaultTool].resumeCount = resumeCount;
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
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",@"20",@"count",jobSortId,@"jobSortId",nil];
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
            
//            ghostView.message=@"请重新登录";
//            [ghostView show];
            
            
            return ;
        }
        if(errorNumber.integerValue == 0){
            NSLog(@"请求成功");
            resumeLink = [resultDic objectForKey:@"resumeLink"];
            NSMutableArray *array=[resultDic objectForKey:@"resumeList"];
            if (currentPage_other == 1) {
                [dataArray removeAllObjects];
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

#pragma mark readBtn响应事件(就是右上角的三个点)
-(void)readBtnClick:(id)sender
{
    if(!resumeView)
        return;
    
    UIImageView *imageView=(UIImageView *)[self.view viewWithTag:10000];
    
    [imageView removeFromSuperview];
    
    UILabel *lab=(UILabel *)[self.view viewWithTag:10001];
    
    [lab removeFromSuperview];
    
    NSLog(@"订阅器界面被点击");
    if (resumeView.alpha==0) {
        
        [UIView animateWithDuration:0.2 animations:^{
            resumeView.alpha=1;
            [resumeView.myTableView reloadData];
        }];
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            resumeView.alpha=0;
            [resumeView.myTableView reloadData];
        }];
    }
}

#pragma mark-UserActions
-(void)closeHeader{
    height_HeaderView = 0;
    [_tableView reloadData];
}

-(void)closeHeaderForever{
    height_HeaderView = 0;
    [_tableView reloadData];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"DialogStatus"];
    NSMutableDictionary *dicm = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicm setValue:@"0" forKey:@"resume_manage_tutorial"];
    [[NSUserDefaults standardUserDefaults] setObject:dicm forKey:@"DialogStatus"];
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,FuncUpDialogStates);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"1",@"type",nil];
  
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            
            return ;
        }
        if(errorStr.integerValue == 200){
            NSLog(@"获取窗口状态成功");
            
        }else{
            
            return;
        }
        
    }];
    [request setFailedBlock:^{
    }];
    [request startAsynchronous];

}

-(void)jumpToPCResumeInstruction{
//    height_HeaderView = 0;
    [_tableView reloadData];
    PCResumeTutorViewController *vc = [[PCResumeTutorViewController alloc] init];
    vc.webTitle = @"简历库管理";
    vc.urlString = [NSString stringWithFormat:@"%@%@userToken=%@&userImei=%@",KXZhiLiaoAPI,PCResumeTutor,kUserTokenStr,IMEI];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  UITableView代理方法
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  height_HeaderView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 55)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 55)];
    [image setImage:[UIImage imageNamed:@"resume_manage_dialog"]];
    [viewHeader addSubview:image];
    image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapJump = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpToPCResumeInstruction)];
    [image addGestureRecognizer:tapJump];
    
    UIView *view_back = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, height_HeaderView)];
    [view_back setBackgroundColor:[UIColor colorWithHex:0xf6f6f6 alpha:1]];
    [view_back addSubview:viewHeader];
    
    label_ResumeCount = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, iPhone_width, 20)];
    [label_ResumeCount setFont:[UIFont systemFontOfSize:13]];
    [label_ResumeCount setTextColor:color_lightgray];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"简历：%d",resumeCount]];
    
    int l_count = (int)[[NSString stringWithFormat:@"%d",resumeCount] length];//获取职位个数的长度
    NSString *rawStr = [str string];
    
    NSRange range01 = [rawStr rangeOfString:@"简历："];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(range01.location+range01.length, l_count)];

    label_ResumeCount.attributedText = str;
    
    [view_back addSubview:label_ResumeCount];

    return view_back;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row =[indexPath row];
    static NSString *CellIdentifier = @"Cell7";
    HR_ResumeListCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HR_ResumeListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    cell.indexPath = indexPath;
    [cell setModel:[dataArray objectAtIndex:row]];
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HR_ResumeDetail *detail = [[HR_ResumeDetail alloc] init];
//    detail.resumeModelFromList = [dataArray objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:detail animated:YES];
    WebViewController *web = [[WebViewController alloc]init];
    HRReumeModel *model = [dataArray objectAtIndex:indexPath.row];
    //http://www.xzhiliao.com/api/hr_api/recommend_jianli/hrview?rid=280007322627&version=3.2.1&userToken=71c517f9c9735244281335a7ad7bdcd9&userImei=868433027181654
    //11.24日
    //xzl_1124+rid md5一下 参数名token
    NSString *token = [NSString stringWithFormat:@"xzl_1124%@",model.rid];
    token = [NSString md5:token];

    web.urlStr = [NSString stringWithFormat:@"%@%@rid=%@&version=%@&userToken=%@&userImei=%@&token=%@",KWWWXZhiLiaoAPI,HRResumeReview,model.rid,kAppVersion,kUserTokenStr,IMEI,token];
//    NSString *urlString = [NSString stringWithFormat:@"%@?rid=%@",resumeLink,model.rid];
//    web.urlStr = [NSString stringWithFormat:@"%@&version=%@",urlString,[XZLUtil currentVersion]];
    web.floog = @"简历预览";
    web.isFromResumeList = YES;
    web.isHRSelf = YES;
    web.resumeModel = model;
    [self.navigationController pushViewController:web animated:YES];

}

- (NSString *) createRandomValue
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:[NSDate date]],
            [NSNumber numberWithInt:rand()]];
}

#pragma mark- HR_ResumeDeleteDelegate
-(void)deleteResumeWithModel:(HRReumeModel *)model{
    
    resumeCount -= 1;
    dataArray = [HR_ResumeShareTool defaultTool].array_Resume;
    [_tableView reloadData];

}

#pragma mark- HR_ResumeListCellDelegate
- (void)addResumePrice:(HRReumeModel *)resumeModel IndexPath:(NSIndexPath *)indexPath{
    HR_ResumePriceEdit *priceList = [[HR_ResumePriceEdit alloc] init];
    priceList.isFromResumeList = YES;
    priceList.resumeModel = resumeModel;
    priceList.indexPath = indexPath;
    priceList.delegate = self;
    [self.navigationController pushViewController:priceList animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
