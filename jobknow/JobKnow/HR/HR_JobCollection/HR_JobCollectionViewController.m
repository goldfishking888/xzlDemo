//
//  HR_JobCollectionViewController.m
//  JobKnow
//
//  Created by Suny on 15/8/16.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_JobCollectionViewController.h"
#import "MJRefresh.h"

#define cell_index_space 14

#define cell_inner_space 20

@interface HR_JobCollectionViewController ()

@end

@implementation HR_JobCollectionViewController

-(void)initData
{
    all=0;//累计新增
    
    today=0;//今日新增
    
    currentPage=1;//搜索页数
    
    pageCount = 1;//总页数
    
    currentPage_other = 1;//其他当前页
    
    pageCount_other = 1; //其他总页数
    
    num=ios7jj;
    
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
    [self.tableView reloadData];
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed:(id)sender{
    _detail = !_detail;
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [self.tableView reloadData];
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
            [navTitle setText:@"职位收藏"];
            [navTitle setTextAlignment:NSTextAlignmentLeft];
//            [navTitle setUserInteractionEnabled:YES];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readBtnClick:)];
//            [navTitle addGestureRecognizer:tap];
            //            uicontroleve
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
                //右按钮
                
                if (IOS7) {
                    btn.frame = CGRectMake(iPhone_width-40,24,35,35);
                }else
                {
                    btn.frame = CGRectMake(iPhone_width-40,10,35,35);
                }
    
                [btn.titleLabel setFont:[UIFont systemFontOfSize:11]];
                [btn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
//                [btn setTitle:@"明细" forState:UIControlStateNormal];
//                [btn setTitle:@"列表" forState:UIControlStateSelected];
//                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage imageNamed:@"list_1_detail"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"list_0_list"] forState:UIControlStateSelected];
                
//                [btn setImage:[UIImage imageNamed:@"hrcircle_resume_right"] forState:UIControlStateNormal];
//                [btn setImage:[UIImage imageNamed:@"hrcircle_resume_right"] forState:UIControlStateHighlighted];
                [btn  addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
    }
    
    [self initTableView];

    [self requestDataWithPage:currentPage];
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
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
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
    [self requestDataWithPage:currentPage];
    
}
- (void)footerRefresh{
    currentPage ++;
    [self requestDataWithPage:currentPage];
    
}

#pragma mark 网络连接方法
-(void)requestDataWithPage:(int)page
{
    NSString *pageStr=[NSString stringWithFormat:@"%d",page];
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRJobCollection);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",@"20",@"count",nil];
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
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            
            ghostView.message=@"暂无数据";
            [ghostView show];
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"请求成功");
            
            NSMutableArray *array=[resultDic objectForKey:@"data"];
            if (currentPage == 1) {
                [dataArray removeAllObjects];
            }
            
            int b = [[resultDic objectForKey:@"resumeCount"] intValue];
            pageCount = b/20+1;
            
            if ([array count]==0 && currentPage==1) {
                ghostView.message=@"暂无数据!";
                [ghostView show];
                [self.tableView reloadData];
                return;
            }
            
            
            for (NSDictionary *item in array) {
                HRHomeIntroduceModel *jobModel = [[HRHomeIntroduceModel alloc] initWithDictionary:item];
                [dataArray addObject:jobModel];
            }
            if (dataArray.count>0) {
                [navTitle setText:[NSString stringWithFormat:@"职位收藏%d条",dataArray.count]];
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

#pragma mark- UITableViewDelegate

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
    
    //职位名称
    UILabel *jobNameLab = [[UILabel alloc]initWithFrame:CGRectMake(cell_index_space, 5, 180,20)];
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
    
    if (_isJianzhi) {
        jobNameLab.frame=CGRectMake(10,5,200,20);
        companyNameLab.frame=CGRectMake(10,25,190,20);
    }
    
    //职位薪水
    UILabel *salaryLab = [[UILabel alloc]initWithFrame:CGRectMake(213, 5, 80, 20)];
    salaryLab.backgroundColor = [UIColor clearColor];
    salaryLab.font = [UIFont systemFontOfSize:12];
    salaryLab.textColor=RGBA(255, 115, 4, 1);
    salaryLab.textAlignment = NSTextAlignmentRight;
    
    //发布日期
    UILabel *dateLab = [[UILabel alloc]initWithFrame:CGRectMake(223, 45, 70, 20)];
    dateLab.textColor = [UIColor darkGrayColor];
    dateLab.textAlignment = NSTextAlignmentRight;
    dateLab.backgroundColor = [UIColor clearColor];
    dateLab.font = [UIFont systemFontOfSize:12];
    
    
    UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, 69, iPhone_width, 1)];
    [view_line setTag:99];
    [view_line setBackgroundColor:color_view_line];
    
    if (_isJianzhi) {
        salaryLab.frame=CGRectMake(208, 25, 80, 20);
        dateLab.frame=CGRectMake(218, 5, 70, 20);
    }
    
    //从数据源中取出数据
    HRHomeIntroduceModel *position = [dataArray objectAtIndex:indexPath.row];
    
    jobNameLab.text=position.jobName;
    companyNameLab.text=position.companyName;
    cityLab.text = position.workArea;
    salaryLab.text=[NSString stringWithFormat:@"%@",position.salary];
    dateLab.text=position.pubDate;
    
    //调整button上标题的位置
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantou.frame = CGRectMake(300, 25, 15, 15);
    
//    if (position.isRead.integerValue==0) {
//        
//        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"]
//                           forState:UIControlStateNormal];
//        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"]
//                           forState:UIControlStateHighlighted];
//        
//    }else
//    {
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                           forState:UIControlStateNormal];
        [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow.png"]
                           forState:UIControlStateHighlighted];
//    }
    [cell.contentView addSubview:jiantou];
    [cell.contentView addSubview:jobNameLab];
    [cell.contentView addSubview:companyNameLab];
    [cell.contentView addSubview:cityLab];
    [cell.contentView addSubview:salaryLab];
    [cell.contentView addSubview:dateLab];
    [cell.contentView addSubview:view_line];
    
    if (!_detail){   //处于简单状态下时
        
    }else
    {
        //处于详细状态时
        
        [view_line setFrame:CGRectMake(0, 119, iPhone_width, 1)];
        
        jiantou.frame = CGRectMake(300,48,15, 15);
        
        UILabel *detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(cell_index_space,65,260,10)];
        detailLabel.backgroundColor=[UIColor clearColor];
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.font = [UIFont systemFontOfSize:12];
        
        NSLog(@"position.degree is %@",position.degree);
        
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
        
        if (_isJianzhi) {
            detailLabel.frame=CGRectMake(10,45,260,10);
            requireLabel.frame=CGRectMake(10,52,260,40);
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HRHomeIntroduceModel *model=[dataArray objectAtIndex:indexPath.row];
    
    HR_JobDetailVC * jobDetailVC = [[HR_JobDetailVC alloc] init];
    jobDetailVC.dataArray=dataArray;
    jobDetailVC.index=indexPath.row;
    //    jobDetailVC.tag=_enterItem;
    
    jobDetailVC.cityCode=model.cityCode;
    
    jobDetailVC.isJianzhi=NO;

    [self.navigationController pushViewController:jobDetailVC animated:YES];
        
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_detail) {
        return 70;
    }
    
    return 120;
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
