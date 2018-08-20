//
//  SearchResultViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/7/19.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchResultCell.h"
#import "JobDetailViewController.h"//职位查看xin页
#import "MJRefresh.h"
#import "GRReadModel.h"
//#import "LMJDropdownMenu.h"//下拉选择器
@interface SearchResultViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>//LMJDropdownMenuDelegate
{
    UITextField * searchTf;
    
    UIButton * choiceBtn;
    UILabel * choiceLab;
    UIImageView * _arrowMark;
    UIView * bgChoiceView;
    UIView * workYearView;
    UIView * degreeView;
    
    UIButton * tradeBtn;
    UILabel * tradeLab;
    UIImageView * _arrowMark2;
    
    UIView * bgMainTradeView;
    UIScrollView * tradeBgView;
    UIImageView *titleIV;
    UITableView * _tableView;
    int pageIndex;
    
    NSUserDefaults *userDefaults;
    NSMutableArray * tradeArray;
    
    NSString * SearchTradeCodeStr;//搜索选择行业codestr
    
    NSString * SearchWorkExpCodeStrTemp;//工作经验code
    NSString * SearchWorkExpCodeStr;//工作经验code
    
    NSString * SearchDegreeCodeStrTemp;//学历要求
    NSString * SearchDegreeCodeStr;//学历要求
    
    MBProgressHUD *loadView;
    OLGhostAlertView * ghostView;
    
}
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableDictionary * dataDic;
@end

@implementation SearchResultViewController

- (void)backUp:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化的数据
- (void)initDidLoadWithNoDataTitle:(NSString *)noDataTitle{
    self.noDateView = [[XZLNoDataView alloc] initWithLabelString:noDataTitle];
    self.noDateView.frame = CGRectMake(0, 44 + self.num + 44, iPhone_width, iPhone_height - 44 - self.num - 44);
    self.noDateView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    pageIndex = 1;
    SearchWorkExpCodeStrTemp = @"";
    SearchWorkExpCodeStr = @"";

    SearchDegreeCodeStrTemp = @"";
    SearchDegreeCodeStr = @"";
    
    SearchTradeCodeStr = @"";
    
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self configHeadView];
    [self initDidLoadWithNoDataTitle:@""];
    //    [self addBackBtn];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSearchBar];
    [self initTableView];
    [self requestDataWithPage:1];
    
    // Do any additional setup after loading the view.
}

#pragma mark --*************____requestDataWithPage____**********
-(void)requestDataWithPage:(int)page
{
    //http://test.appapi.xzhiliao.com/api/position/partner/search_index
    //keyword city trade work_year degree 这些是参数，除了keyword，其他都是code

    NSString * urlstr = kCombineURL(kTestAPPAPIGR, @"/api/position/partner/search_index");
    
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString * cityCodeStr=[[NSString alloc]init];
    
    userDefaults =[NSUserDefaults standardUserDefaults];
    
    NSString * tokenStr = [XZLUserInfoTool getToken];
    //citycode 关键字 年限code多个  行业code单个 page count token
    cityCodeStr = [XZLUtil getCityCodeWithCityName:[userDefaults objectForKey:@"localCity"]];
    NSLog(@"cityCodeStr in postResumeBtn is %@",cityCodeStr);
    [paramDic setValue:self.searchKey forKey:@"keyword"];//关键字
    [paramDic setValue:cityCodeStr forKey:@"city"];//城市的code
    [paramDic setValue:SearchTradeCodeStr forKey:@"trade"];//十大行业单选
    [paramDic setValue:SearchWorkExpCodeStr forKey:@"work_year"];//工作年限
    [paramDic setValue:SearchDegreeCodeStr forKey:@"degree"];//学历
    [paramDic setValue:@"" forKey:@"hope_salary"];//学历
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [paramDic setValue:@"10" forKey:@"count"];
    NSLog(@"paramDic is %@",paramDic);
    [XZLNetWorkUtil requestPostURL:urlstr params:paramDic success:^(id responseObject) {
        if([_tableView isHeaderRefreshing] == YES){
            [_tableView headerEndRefreshing];
        }
        if([_tableView isFooterRefreshing] == YES){
            [_tableView footerEndRefreshing];
        }
        if (page == 1) {
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
        }
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            [loadView hide:YES];
            NSString *error = [NSString stringWithFormat:@"%@",responseObject[@"error_code"]];
            if (error.integerValue == 0) {
                NSDictionary *data = responseObject[@"data"];
                if ([data[@"total"] intValue]!= 0) {
                    if (page == 1) {
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        if (array.count==0) {
                            self.noDateView.hidden = NO;
                        }
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        self.dataArray = tempArray;
                        [_tableView reloadData];
                    }else{
                        NSMutableArray * array = data[@"position_list"];
                        NSMutableArray *tempArray = [NSMutableArray array];
                        for (NSDictionary *dataDic in array) {
                            SearchResultModel * searchModel = [[SearchResultModel alloc]initWithDictionary:dataDic];
                            [tempArray addObject:searchModel];
                        }
                        [self.dataArray addObjectsFromArray:tempArray];
                        [_tableView reloadData];
                    }
                    
                }else{
                    if (self.dataArray.count == 0) {
                        [_tableView reloadData];
                         _tableView.bounces = NO;
                        self.noDateView.hidden = NO;
                         [self.view addSubview:self.noDateView];
                    }
                }
            }
            
        }
    } failure:^(NSError *error) {
        NSLog(@"failed block%@",error);
        mGhostView(@"提示", @"获取数据失败，请检查网络");
    }];
}

#pragma mark - initTableView
-(void)initTableView
{
    choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    choiceBtn.frame = CGRectMake(0, 40 + 22, iPhone_width / 2, 44);
//    [choiceBtn setTitle:@"职位筛选" forState:UIControlStateNormal];
//    choiceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [choiceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [choiceBtn addTarget:self action:@selector(choiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    choiceLab = [[UILabel alloc]initWithFrame:CGRectMake(choiceBtn.frame.size.width / 2 - 33, 0, 66, choiceBtn.frame.size.height)];
    choiceLab.text = @"职位筛选";
    choiceLab.font = [UIFont systemFontOfSize:16];
    choiceLab.textColor = RGBA(74, 74, 74, 1);
    [choiceBtn addSubview:choiceLab];
    // 旋转尖头
    _arrowMark = [[UIImageView alloc] initWithFrame:CGRectMake(choiceLab.frame.origin.x + choiceLab.frame.size.width + 4, choiceBtn.frame.size.height/2 - 3, 9, 6)];
    _arrowMark.image  = [UIImage imageNamed:@"dropdownMenu_cornerIcon"];
    [choiceBtn addSubview:_arrowMark];
    [self.view addSubview:choiceBtn];
    
    //职位选择最后面的大背景
    bgChoiceView = [[UIView alloc]initWithFrame:CGRectMake(0, choiceBtn.frame.origin.y + choiceBtn.frame.size.height, iPhone_width,iPhone_height)];
    bgChoiceView.backgroundColor = [UIColor lightGrayColor];
    //工作经验整个后面的背景
    workYearView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 100)];
    workYearView.backgroundColor = [UIColor whiteColor];
    [bgChoiceView addSubview:workYearView];
    //工作经验
    UILabel * workyearLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 80, 20)];
    workyearLab.textColor = RGBA(74, 74, 74, 1);
    workyearLab.text = @"工作经验";
    workyearLab.font = [UIFont systemFontOfSize:15];
    [workYearView addSubview:workyearLab];
    NSMutableArray * selectWorkYearArray = [NSMutableArray arrayWithObjects:@"不限",@"3年以下",@"3-5年",@"5年以上", nil];
    for (int i = 0; i < selectWorkYearArray.count; i++) {
        UIButton * selectWorkYearBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (iPhone_width - 30 - 30)/4 * i + 10 * i, workyearLab.frame.origin.y + workyearLab.frame.size.height + 10, (iPhone_width - 30 - 30)/4, 40)];
        [selectWorkYearBtn setBackgroundColor:(i == 0 ? RGBA(255, 163, 29, 1):[UIColor whiteColor])];
        [selectWorkYearBtn.layer setBorderColor:(i == 0? RGBA(255, 163, 29, 1).CGColor:RGBA(216, 216, 216, 1).CGColor)];
        [selectWorkYearBtn setTitle:selectWorkYearArray[i] forState:UIControlStateNormal];
        [selectWorkYearBtn setTitleColor:(i == 0 ? [UIColor whiteColor]:RGBA(74, 74, 74, 1)) forState:UIControlStateNormal];
        [selectWorkYearBtn.layer setBorderWidth:0.5];
        selectWorkYearBtn.layer.cornerRadius = 4;
        selectWorkYearBtn.layer.masksToBounds = YES;
        selectWorkYearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [selectWorkYearBtn addTarget:self action:@selector(selectWorkYearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectWorkYearBtn.tag = 10086 + i;
        [workYearView addSubview:selectWorkYearBtn];
    }
    //学历要求后面的大背景
    degreeView = [[UIView alloc]initWithFrame:CGRectMake(0, workYearView.frame.origin.y + workYearView.frame.size.height, iPhone_width, 100)];
    degreeView.backgroundColor = [UIColor whiteColor];
    [bgChoiceView addSubview:degreeView];
    //学历要求title
    UILabel * degreeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 80, 20)];
    degreeLab.textColor = RGBA(74, 74, 74, 1);
    degreeLab.text = @"学历要求";
    degreeLab.font = [UIFont systemFontOfSize:15];
    [degreeView addSubview:degreeLab];
    
    NSMutableArray * selectdegreeArray = [NSMutableArray arrayWithObjects:@"不限",@"大专及以下",@"本科",@"本科以上", nil];
    for (int i = 0; i < selectdegreeArray.count; i++) {
        UIButton * selectdegreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 + (iPhone_width - 30 - 30)/4 * i + 10 * i, workyearLab.frame.origin.y + workyearLab.frame.size.height + 10, (iPhone_width - 30 - 30)/4, 40)];
        [selectdegreeBtn setBackgroundColor:(i == 0 ? RGBA(255, 163, 29, 1):[UIColor whiteColor])];
        [selectdegreeBtn.layer setBorderColor:(i == 0? RGBA(255, 163, 29, 1).CGColor:RGBA(216, 216, 216, 1).CGColor)];
        [selectdegreeBtn setTitle:selectdegreeArray[i] forState:UIControlStateNormal];
        [selectdegreeBtn setTitleColor:(i == 0 ? [UIColor whiteColor]:RGBA(74, 74, 74, 1)) forState:UIControlStateNormal];
        [selectdegreeBtn.layer setBorderWidth:0.5];
        selectdegreeBtn.layer.cornerRadius = 4;
        selectdegreeBtn.layer.masksToBounds = YES;
        selectdegreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [selectdegreeBtn addTarget:self action:@selector(selectDegreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectdegreeBtn.tag = 10010 + i;
        [degreeView addSubview:selectdegreeBtn];
    }
    UIView * whiteSureView = [[UIView alloc]initWithFrame:CGRectMake(0, degreeView.frame.origin.y + degreeView.frame.size.height, iPhone_width, 80)];
    whiteSureView.backgroundColor = [UIColor whiteColor];
    [bgChoiceView addSubview:whiteSureView];
    UIButton * sureChoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureChoiceBtn.frame = CGRectMake(15, 10, iPhone_width - 30, 44);
    [sureChoiceBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureChoiceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [sureChoiceBtn setBackgroundColor:RGBA(255, 178, 66, 1)];
    [sureChoiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureChoiceBtn.layer setCornerRadius:22];
    sureChoiceBtn.layer.masksToBounds = YES;
    [sureChoiceBtn addTarget:self action:@selector(sureChoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sureChoiceBtn.tag = 11111;
    [whiteSureView addSubview:sureChoiceBtn];
    
    tradeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tradeBtn.frame = CGRectMake(iPhone_width / 2, 40 + 22, iPhone_width / 2, 44);
//    [tradeBtn setTitle:@"行业筛选" forState:UIControlStateNormal];
//    tradeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [tradeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tradeBtn addTarget:self action:@selector(tradeBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    tradeLab = [[UILabel alloc]initWithFrame:CGRectMake(tradeBtn.frame.size.width / 2 - 33, 0, 66, tradeBtn.frame.size.height)];
    tradeLab.text = @"行业筛选";
    tradeLab.font = [UIFont systemFontOfSize:16];
    tradeLab.textColor = RGBA(74, 74, 74, 1);
    [tradeBtn addSubview:tradeLab];
    // 旋转尖头
    _arrowMark2 = [[UIImageView alloc] initWithFrame:CGRectMake(tradeLab.frame.origin.x + tradeLab.frame.size.width + 4, tradeBtn.frame.size.height/2 - 3, 9, 6)];
    _arrowMark2.image  = [UIImage imageNamed:@"dropdownMenu_cornerIcon"];
    [tradeBtn addSubview:_arrowMark2];
    [self.view addSubview:tradeBtn];
    //整个行业大背景bg
    bgMainTradeView = [[UIView alloc]initWithFrame:CGRectMake(0, choiceBtn.frame.origin.y + choiceBtn.frame.size.height, iPhone_width,  [ UIScreen mainScreen ].bounds.size.height - 44 - self.num - 44)];
    bgMainTradeView.backgroundColor = [UIColor lightGrayColor];
    //选择行业后面的bg
    tradeArray = [[NSMutableArray alloc]init];
    NSArray * array0 = @[@{@"code": @"",@"name": @"不限"
    }];
    [tradeArray addObject:[GRReadModel ModelWithDic:array0[0]]];

    [tradeArray addObjectsFromArray:[XZLUtil getIndustryArrayWithModel:YES]];

    tradeBgView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width,tradeArray.count * 50)];
    tradeBgView.backgroundColor = [UIColor whiteColor];
    tradeBgView.scrollEnabled = YES;
    tradeBgView.contentSize = CGSizeMake(iPhone_width, tradeArray.count * 50 + 100);
    [bgMainTradeView addSubview:tradeBgView];
    for (int i = 0; i < tradeArray.count; i++) {
        UIButton * selectTradeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 * i, iPhone_width, 50)];
        [selectTradeBtn addTarget:self action:@selector(selectTradeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        selectTradeBtn.tag = 1000 + i;
        [tradeBgView addSubview:selectTradeBtn];
        
        UILabel * contentLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, iPhone_width - 100, 50)];
        if (tradeArray[i] != nil) {
            GRReadModel *read;
            read=[tradeArray objectAtIndex:i];
            contentLab.text = [NSString stringWithFormat:@"%@",read.name];
        }
        contentLab.textColor = RGBA(74, 74, 74, 1);
        contentLab.font = [UIFont systemFontOfSize:14];
        contentLab.textAlignment = NSTextAlignmentLeft;
        [selectTradeBtn addSubview:contentLab];
        
        UIImageView * rightImgV = [[UIImageView alloc] initWithFrame:CGRectMake(selectTradeBtn.frame.size.width - 40, 15, 19, 19)];
        [rightImgV setImage:(i == 0 ? [UIImage imageNamed:@"hr_bank_select"]:nil)];
        rightImgV.tag = 2000;
        [selectTradeBtn addSubview:rightImgV];
        
        UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(15, 49.5, iPhone_width - 15, 0.5)];
        lineV.backgroundColor = RGBA(232, 232, 232, 1);
        [selectTradeBtn addSubview:lineV];
    }
    UIView * lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 44 + self.num + 40, iPhone_width, 1)];
    lineV.backgroundColor = RGBA(232, 232, 232, 1);
    [self.view addSubview:lineV];
    //列表tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + self.num + 41, iPhone_width, iPhone_height - 44 - self.num - 41) style:UITableViewStylePlain];//40 + 44 + 22
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [self.view addSubview:self.noDateView];
    // 上拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    _tableView.headerPullToRefreshText= @"上拉刷新";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新";
    _tableView.headerRefreshingText = @"努力加载中……";
    
    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    _tableView.footerPullToRefreshText= @"上拉刷新";
    _tableView.footerReleaseToRefreshText = @"松开马上刷新";
    _tableView.footerRefreshingText = @"努力加载中……";
    
    
}
#pragma mark - sureChoiceBtnClick
-(void)sureChoiceBtnClick:(UIButton *)button
{
    [self.noDateView removeFromSuperview];
    [self hideChoiceDown];
    SearchWorkExpCodeStr = SearchWorkExpCodeStrTemp;
    SearchDegreeCodeStr = SearchDegreeCodeStrTemp;
    [self requestDataWithPage:1];
}
#pragma mark - 职位筛选
-(void)choiceBtnClick:(UIButton *)button
{
    tradeLab.textColor = RGBA(74, 74, 74, 1);
    choiceLab.textColor = RGBA(255, 146, 4, 1);
    if (tradeBtn.selected == YES) {
        [self hideTradeDown];//ruguo choice 是展开的先把choice选择收起来
    }
    if(button.selected == NO) {
        [self showChoiceDown];
    }
    else {
        [self hideChoiceDown];
    }
}

- (void)showChoiceDown{   // 显示职位选择下拉列表
    [self.view addSubview:bgChoiceView]; // 将下拉视图添加到控件的俯视图上
    //    [bgChoiceView.superview bringSubviewToFront:bgChoiceView];// 将下拉列表置于最上层
    [UIView animateWithDuration:0.3 animations:^{
        choiceLab.textColor = RGBA(255, 146, 4, 1);
//        _arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        _arrowMark.image = [UIImage imageNamed:@"dropdownMenu_cornerIcon_orange"];
        bgChoiceView.frame = CGRectMake(0, choiceBtn.frame.origin.y + choiceBtn.frame.size.height, iPhone_width, iPhone_height);
    }completion:^(BOOL finished) {
    }];
    choiceBtn.selected = YES;
}
- (void)hideChoiceDown{  // 隐藏下拉列表
    
    [UIView animateWithDuration:0.3 animations:^{
        
//        _arrowMark.transform = CGAffineTransformIdentity;
        choiceLab.textColor = RGBA(74, 74, 74, 1);
        _arrowMark.image = [UIImage imageNamed:@"dropdownMenu_cornerIcon"];
        [bgChoiceView removeFromSuperview];
        
    }completion:^(BOOL finished) {
    }];
    choiceBtn.selected = NO;
}
#pragma mark selectWorkYearBtnClick点击某项工作年限
-(void)selectWorkYearBtnClick:(UIButton *)button
{
    //先把所有的背景文字设置为默认值 再把对应的点击button改了.
    for (id obj in workYearView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * theButton = (UIButton *)obj;
            theButton.backgroundColor = [UIColor whiteColor];
            [theButton.layer setBorderColor:RGBA(216, 216, 216, 1).CGColor];
            [theButton setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
        }
    }
    int indexCode = (int)button.tag - 10086;
    switch (indexCode) {
        case 0:
            SearchWorkExpCodeStrTemp = @"";
            break;
        case 1:
            SearchWorkExpCodeStrTemp = @"-1,0,1,2";
            break;
        case 2:
            SearchWorkExpCodeStrTemp = @"3,4,5";
            break;
        case 3:
            SearchWorkExpCodeStrTemp = @"6,7,8,9,10,100";
            break;
            
        default:
            break;
    }
    button.backgroundColor = RGBA(255, 163, 29, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setBorderColor:RGBA(255, 163, 29, 1).CGColor];
}

#pragma mark selectDegreeBtnClick点击某项学历要求
-(void)selectDegreeBtnClick:(UIButton *)button
{
    //先把所有的背景文字设置为默认值 再把对应的点击button改了.
    for (id obj in degreeView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * theButton = (UIButton *)obj;
            theButton.backgroundColor = [UIColor whiteColor];
            [theButton.layer setBorderColor:RGBA(216, 216, 216, 1).CGColor];
            [theButton setTitleColor:RGBA(74, 74, 74, 1) forState:UIControlStateNormal];
        }
    }
    NSLog(@"点击了某一项学历要求的tag是%d",(int)button.tag);
    button.backgroundColor = RGBA(255, 163, 29, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setBorderColor:RGBA(255, 163, 29, 1).CGColor];
    int indexCode = (int)button.tag - 10010;
    switch (indexCode) {
        case 0:
            SearchDegreeCodeStrTemp = @"";
            break;
        case 1:
            SearchDegreeCodeStrTemp = @"10,11,12,13,14";
            break;
        case 2:
            SearchDegreeCodeStrTemp = @"15";
            break;
        case 3:
            SearchDegreeCodeStrTemp = @"16,17,18";
            break;
        default:
            SearchDegreeCodeStrTemp = @"";
            break;
    }
   
}

#pragma mark - 行业筛选
-(void)tradeBtnBtnClick:(UIButton *)button
{
    tradeLab.textColor = RGBA(255, 146, 4, 1);
    choiceLab.textColor = RGBA(74, 74, 74, 1);
    if (choiceBtn.selected == YES) {
        [self hideChoiceDown];//ruguo choice 是展开的先把choice选择收起来
    }
    if(button.selected == NO) {
        [self showTradeDown];
    }
    else {
        [self hideTradeDown];
    }
}

- (void)showTradeDown{   // 显示行业选择下拉列表
    [self.view addSubview:bgMainTradeView]; // 将下拉视图添加到控件的俯视图上
    //    [bgChoiceView.superview bringSubviewToFront:bgChoiceView];// 将下拉列表置于最上层
    [UIView animateWithDuration:0.3 animations:^{
//        _arrowMark2.transform = CGAffineTransformMakeRotation(M_PI);
        _arrowMark2.image = [UIImage imageNamed:@"dropdownMenu_cornerIcon_orange"];

        bgMainTradeView.frame = CGRectMake(0, choiceBtn.frame.origin.y + choiceBtn.frame.size.height, iPhone_width,  [ UIScreen mainScreen ].bounds.size.height - 44 - self.num - 44);
    }completion:^(BOOL finished) {
    }];
    tradeBtn.selected = YES;
}
- (void)hideTradeDown{  // 隐藏下拉列表
    
    [UIView animateWithDuration:0.3 animations:^{
        tradeLab.textColor = RGBA(74, 74, 74, 1);
        _arrowMark2.image = [UIImage imageNamed:@"dropdownMenu_cornerIcon"];
//        _arrowMark2.transform = CGAffineTransformIdentity;
        [bgMainTradeView removeFromSuperview];
        
    }completion:^(BOOL finished) {
    }];
    tradeBtn.selected = NO;
}

#pragma mark - selectTradeBtnClick
-(void)selectTradeBtnClick:(UIButton *)button
{
    [self.noDateView removeFromSuperview];
    [self hideTradeDown];
    //先把所有的背景文字设置为默认值 再把对应的点击button改了.
    for (id obj in tradeBgView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton * thisBtn = (UIButton *)obj;
            for (id obj2 in thisBtn.subviews) {
                if ([obj2 isKindOfClass:[UIImageView class]]) {
                    UIImageView * theImgV = (UIImageView *)obj2;
                    [theImgV setImage:nil];
                }
            }
        }
    }
    UIImageView * imageV = (UIImageView *)[bgMainTradeView viewWithTag:2000];
    [imageV setImage:[UIImage imageNamed:@"hr_bank_select"]];
    [button addSubview:imageV];
    NSLog(@"点击了某一项行业的tag是%d",(int)button.tag);
    int index = (int)button.tag - 1000;
    GRReadModel *read;
    read=[tradeArray objectAtIndex:index];
    NSLog(@"选择的行业code是%@",read.code);
    SearchTradeCodeStr = read.code;
    [self requestDataWithPage:1];
}

#pragma mark - tableView-delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = @"searchCellID";
    SearchResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SearchResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataArray.count > 0) {
        SearchResultModel * searchModel = [self.dataArray objectAtIndex:indexPath.row];
        [cell setDataWithModel:searchModel];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了职位详情");
    JobDetailViewController * jobDetailVC = [[JobDetailViewController alloc]init];
    if (self.dataArray.count > 0) {
        SearchResultModel * searchModel = [self.dataArray objectAtIndex:indexPath.row];
        jobDetailVC.positionID = [NSString stringWithFormat:@"%@",searchModel.Id];
        jobDetailVC.companyName = searchModel.company_name;
    }
    [self.navigationController pushViewController:jobDetailVC animated:YES];
}

-(void)configHeadView
{
    titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44 + 20)];
    titleIV.userInteractionEnabled = YES;
    titleIV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleIV];
}
#pragma mark - addSearch
-(void)addSearchBar
{
    //顶部在搜索框的背景
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,60,30);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_title"] forState:UIControlStateNormal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 44);
    [button addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:_backBtn];
    //    //顶部在搜索框的背景
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(80, 5+self.num, iPhone_width - 90, 30)];
    titleView.backgroundColor = RGBA(239, 239, 239, 1);
    titleView.layer.cornerRadius = titleView.frame.size.height / 2;
    titleView.layer.masksToBounds = YES;
    [titleIV addSubview:titleView];
    
    UIImageView * searchImageV = [[UIImageView alloc]initWithFrame:CGRectMake(17, 7.5, 15, 15)];
    searchImageV.image = [UIImage imageNamed:@"hr_search_icon"];
    [titleView addSubview:searchImageV];
    
    searchTf = [[UITextField alloc]initWithFrame:CGRectMake(searchImageV.frame.origin.x + searchImageV.frame.size.width + 10, 0, titleIV.frame.size.width - 40, 30)];
    searchTf.backgroundColor = [UIColor clearColor];
    searchTf.delegate = self;
    searchTf.font = [UIFont systemFontOfSize:14];
    searchTf.tintColor = RGBA(255, 178, 66, 1);
    searchTf.placeholder = @"请输入公司/职位";
    searchTf.text = self.searchKey;
    searchTf.clearButtonMode = UITextFieldViewModeAlways;
    searchTf.keyboardType = UIKeyboardTypeDefault;
    searchTf.returnKeyType = UIReturnKeySearch;
    [titleView addSubview:searchTf];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTf resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    //重新吊一遍搜索请求api
    self.searchKey = searchTf.text;
    [self requestDataWithPage:1];
    return YES;
}

#pragma mark - 上拉刷新的方法
- (void)headerRefresh{
    // 取新记录
    pageIndex = 1;
    [self requestDataWithPage:pageIndex];
    
}

- (void)footerRefresh{
    pageIndex++;
    [self requestDataWithPage:pageIndex];
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
