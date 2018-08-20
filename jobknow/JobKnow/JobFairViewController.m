//
//  JobFairViewController.m
//  JobsGather
//
//  Created by faxin sun on 12-11-21.
//  Copyright (c) 2012年 zouyl. All rights reserved.
//
#import "JobFairViewController.h"
#import "NetWorkConnection.h"
#import "CityInfo.h"
#import "JSONKit.h"
#define CFONTSIZE 12

@interface JobFairViewController ()
@end

@implementation JobFairViewController

@synthesize theTableView;
@synthesize fairsList;
@synthesize ViewTitle;
@synthesize viewTitLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        num = ios7jj;
        // Custom initialization
        myInfo= [CityInfo standerDefault];
        //        [self univercityRequestWithUnivercity:_univercity Page:@"1"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSString *last = [myInfo.cityName substringFromIndex:myInfo.cityName.length-1];
    if ([last isEqualToString:@"市"]) {
        NSString *b = [myInfo.cityName substringToIndex:myInfo.cityName.length-1 ];//开始截取
        cityLabel.text = b;
    }else{
        cityLabel.text = myInfo.cityName;
    }
    
    [theTableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"招聘会"];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"招聘会"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    alert = [[OLGhostAlertView alloc] initWithTitle:nil message:nil];
    alert.position = OLGhostAlertViewPositionCenter;
    self.navigationController.navigationBar.hidden = YES;
    //数据源
    self.fairsList = [NSMutableArray array];
    self.univercityInfo = [NSMutableArray array];
    
    _cityCode = [[CityInfo standerDefault] cityCode];
    
    s = 1;
    u = 1;
    school = 0;
    //创建tableView
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height-40-20-40 +num) style:UITableViewStylePlain];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.backgroundColor = XZHILBJ_colour;
    
    
    //tablview的footview
    self.foot = [UIButton buttonWithType:UIButtonTypeCustom];
    self.foot.frame = CGRectMake(0, 0, iPhone_width, 40);
    [self.foot addTarget:self action:@selector(moreInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_foot setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.foot.userInteractionEnabled = YES;
    [_foot.titleLabel setFont:[UIFont systemFontOfSize:13]];
    _actView = [[ActivetView alloc] initWithFrame:CGRectMake((iPhone_width - 100)/2+15, 10, 100, 30)];
    _actView.alpha = 0;
    [_foot addSubview:_actView];
    
    //设置tableView的footView
    theTableView.tableFooterView = _foot;
    [self.view addSubview:self.theTableView];
    
    
    //加载二级导航的图片。。。。
    myImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, iPhone_height- 40-20+num, iPhone_width, 40)];
    myImgView.image = [UIImage imageNamed:@"zhaopinbg01.png"];
    myImgView.userInteractionEnabled= YES;
    [self.view addSubview:myImgView];
    
    [self addBackBtn];
    //城市名称
    cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 13, 65, 20)];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.textAlignment = NSTextAlignmentRight;
    cityLabel.font = [UIFont boldSystemFontOfSize:14];
    
    
    NSString *last = [myInfo.cityName substringFromIndex:myInfo.cityName.length-1];
    if ([last isEqualToString:@"市"]) {
        NSString *b = [myInfo.cityName substringToIndex:myInfo.cityName.length-1 ];//开始截取
        cityLabel.text = b;
    }else{
        cityLabel.text = myInfo.cityName;
    }
    
    [self addQuanchengTitleLabel:@"全城招聘会·" secTitle:cityLabel.text];
    
    //校园招聘会按钮
    univerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    univerBtn.frame = CGRectMake(165, 0, 145, 35);
    [univerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [univerBtn addTarget:self action:@selector(clickUniversity:) forControlEvents:UIControlEventTouchUpInside];
    [univerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[univerBtn setTitle:@"校园招聘会" forState:UIControlStateNormal];
    [univerBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [myImgView addSubview:univerBtn];

    //学校
    selectUniver = [UIButton buttonWithType:UIButtonTypeCustom];
    selectUniver.frame = CGRectMake(110, 5, 30, 30);
    [selectUniver setImage:[UIImage imageNamed:@"cell_arrow01.png"] forState:UIControlStateNormal];
    [selectUniver setImage:[UIImage imageNamed:@"cell_arrow02.png"] forState:UIControlStateHighlighted];
    //[univerBtn addSubview:selectUniver];
    selectUniver.enabled = NO;
    
    //社会招聘会按钮
    societyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    societyBtn.frame = CGRectMake(0, 0, 145, 35);
    [societyBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
    [societyBtn addTarget:self action:@selector(clickSociety:) forControlEvents:UIControlEventTouchUpInside];
    
    //[societyBtn setTitle:@"社会招聘会" forState:UIControlStateNormal];
    
    [societyBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [myImgView addSubview:societyBtn];
    
    NSLog(@"最初的坐标  x is  %f,yis %f",self.theTableView.contentOffset.x,self.theTableView.contentOffset.y);
    now_y = self.theTableView.contentOffset.y;
    
    
    [self.univercityInfo removeAllObjects];
    [self univercityRequestWithUnivercity:_univercity Page:@"1"];
}

#pragma mark TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_univercity) {
        return [self.univercityInfo count];
    }
    return [self.fairsList count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *dateTimeLabel, *addressLabel;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }else
    {
        UILabel *labeill = (UILabel *)[cell.contentView viewWithTag:10001];
        [labeill removeFromSuperview];
        UILabel *labeil = (UILabel *)[cell.contentView viewWithTag:10002];
        [labeil removeFromSuperview];
        UILabel *labei = (UILabel *)[cell.contentView viewWithTag:10003];
        [labei removeFromSuperview];
        UILabel *labei1 = (UILabel *)[cell.contentView viewWithTag:10004];
        [labei1 removeFromSuperview];
        cell.accessoryView = nil;
        
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //招聘会标题
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 235, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = RGBA(40, 100, 210, 1);
    titleLabel.tag = 10001;
    [cell.contentView addSubview:titleLabel];
    
    //招聘会地址
    addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, 210, 20)];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.font = [UIFont systemFontOfSize:15];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.textColor = [UIColor grayColor];
    addressLabel.tag  =10002;
    [cell.contentView addSubview:addressLabel];
    
    //招聘会更新日期
    UILabel * dateUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(235, 40, 130, 20)];
    dateUpLabel.backgroundColor = [UIColor clearColor];
    dateUpLabel.font = [UIFont systemFontOfSize:11];
    dateUpLabel.textColor = [UIColor grayColor];
    dateUpLabel.tag =10003;
    [cell.contentView addSubview:dateUpLabel];
    
    UIImageView *weekImg = [[UIImageView alloc]initWithFrame:CGRectMake(260, 0, 37.5, 31.5)];
    if (indexPath.row%2==0) {
        weekImg.image = [UIImage imageNamed:@"jobfair_item_week2.png"];
    }else{
        weekImg.image = [UIImage imageNamed:@"jobfair_item_week1.png"];
        
    }
    [cell.contentView addSubview:weekImg];
    // 周几
    dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 5, 95, 20)];
    dateTimeLabel.backgroundColor = [UIColor clearColor];
    dateTimeLabel.textAlignment = NSTextAlignmentLeft;
    dateTimeLabel.font = [UIFont fontWithName:Zhiti size:15];
    dateTimeLabel.textColor = [UIColor whiteColor];
    dateTimeLabel.tag = 10004;
    [cell.contentView addSubview:dateTimeLabel];
    
    //cell 右箭头
    UIButton *jiantou = [UIButton buttonWithType:UIButtonTypeCustom];
    jiantou.frame = CGRectMake(300, 20, 15, 15);
    [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"] forState:UIControlStateNormal];
    [jiantou setBackgroundImage:[UIImage imageNamed:@"cell_arrow00.png"] forState:UIControlStateHighlighted];
    [cell.contentView addSubview:jiantou];
    
    //    cell.accessoryView = v;
    
    
    //判断是否是学校
    ZPInfo *oneInfo = nil;
    if (_univercity) {
        oneInfo = [self.univercityInfo objectAtIndex:indexPath.row];
        titleLabel.text = oneInfo.companyName;
    }
    else
    {
        oneInfo = [self.fairsList objectAtIndex:indexPath.row];
        titleLabel.text = oneInfo.z_title;
    }
    
    NSString *upDate = [NSString stringWithFormat:@"%@%@",oneInfo.pubdate,@"　更新"];
    dateTimeLabel.text =oneInfo.week;
    addressLabel.text = oneInfo.address;
    dateUpLabel.text = oneInfo.date;
    cell.detailTextLabel.text = upDate;
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if (self.univercity)
    {
        single= [self.univercityInfo objectAtIndex:indexPath.row];
    }else
    {
        single = [self.fairsList objectAtIndex:indexPath.row];
    }
    //创建详细界面
    ZPDetailViewController *zpVC = [[ZPDetailViewController alloc]init];
    [zpVC setZpInfo:single];
    [self.navigationController pushViewController:zpVC animated:YES];
}



//加载更多执行的方法
- (void)moreInfo:(id)sender
{
    [_actView show:@"加载中..."];
    [self.foot setTitle:nil forState:UIControlStateNormal];
    if (_requestTypeItem == requestTypeZP)
    {
        [self univercityRequestWithUnivercity:self.univercity Page:[NSString stringWithFormat:@"%d",++u]];
    }else if(_requestTypeItem == requestTypeUnivercity)
    {
        [self univercityRequestWithUnivercity:self.univercity Page:[NSString stringWithFormat:@"%d",++s]];
    }else
    {
        [self zpFromUnivercity];
    }
}

- (void)backHomeVC:(id)sender
{
    _net.delegate = nil;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToCityVC:(id)sender
{
    allCityViewController *cityVC = [[allCityViewController alloc] init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

//社会招聘
- (void)clickSociety:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.foot.userInteractionEnabled = YES;
    
    [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
    [univerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    myImgView.image = [UIImage imageNamed:@"zhaopinbg01.png"];
    _net.delegate = nil;
    selectUniver.enabled = NO;
    _requestTypeItem = requestTypeZP;
    //删除学校招聘信息
    [self.univercityInfo removeAllObjects];
    //删除社会招聘信息
    [self.fairsList removeAllObjects];
    [theTableView reloadData];
    [self.foot setTitle:nil forState:UIControlStateNormal];
    [_actView show:@"加载中..."];
    self.univercity = NO;
    [self univercityRequestWithUnivercity:_univercity Page:@"1"];
}

//根据学校获得招聘会
- (void)zpFromUnivercity
{
    school++;
    NSString *page = [[NSString alloc] initWithFormat:@"%d",school];
    NSString *theURLStr = kCombineURL(KXZhiLiaoAPI,nil );
    NSDictionary *parmDics = [NSDictionary dictionaryWithObjectsAndKeys:self.univercityName,@"schoolname",page,@"page", nil];
//    _net = [[NetWorkConnection alloc] init];
//    _net.delegate = self;
    [_actView show:@"加载中..."];
//    [_net sendRequestURLStr:theURLStr ParamDic:parmDics Method:@"GET"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:theURLStr];
    [request setCompletionBlock:^{
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];

        self.foot.userInteractionEnabled = YES;
        [self.foot setTitle:@"更多" forState:UIControlStateNormal];
        [_actView hidden];
        NSNull *null = [NSNull null];
        NSObject *obj =[resultDic valueForKey:@"recruitMeeting"];
        NSArray *array = [resultDic valueForKey:@"recruitMeeting"];
        if ([obj isEqual:null]) {
            [self.theTableView setTableFooterView:nil];
            return;
        }
        if(_requestTypeItem == requestTypeUnivercity)
        {
            self.univercitys = [NSMutableArray array];
            [self.univercitys addObject:@"所有学校"];
            NSInteger num1 = 0;
            for (NSInteger i = 0; i<array.count; i++) {
                NSString *name = [array objectAtIndex:i];
                [self.univercitys addObject:name];
                num1++;
            }
            if (num1<20) {
                [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
                self.foot.userInteractionEnabled = NO;
                //[theTableView setTableFooterView:nil];
            }
            [self univercityRequestWithUnivercity:_univercity Page:@"1"];
            self.univercity = NO;
        }else
        {
            NSNull *null = [NSNull null];
            if (![array isEqual:null]) {
                [theTableView setTableFooterView:_foot];
                [self jsonWithDic:resultDic];
                
            }else
            {
                [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
                self.foot.userInteractionEnabled = NO;
                //[theTableView setTableFooterView:nil];
            }
        }
    }];
    [request setFailedBlock:^{
        [_actView hidden];
        
    }];
    [request startAsynchronous];
}

//学校招聘
- (void)clickUniversity:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.foot.userInteractionEnabled = YES;
    
    [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
    [societyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.foot setTitle:nil forState:UIControlStateNormal];
    myImgView.image = [UIImage imageNamed:@"zhaopinbg02.png"];
    [_actView show:@"加载中..."];
    _net.delegate = nil;
    selectUniver.enabled = YES;
    _requestTypeItem = requestTypeZP;
    //删除学校招聘信息
    [self.univercityInfo removeAllObjects];
    //删除社会招聘信息
    [self.fairsList removeAllObjects];
    [theTableView reloadData];
    self.univercity = YES;
    //发送请求
    [self univercityRequestWithUnivercity:self.univercity Page:@"1"];
    
}
- (void)sendChangeValue:(NSString *)cityCode name:(NSString *)cityName
{
    
    NSString *last = [cityName substringFromIndex:cityName.length-1];
    if ([last isEqualToString:@"市"]) {
        NSString *b = [cityName substringToIndex:cityName.length-1 ];
        //开始截取
        cityLabel.text = b;
    }else{
        cityLabel.text = cityName;
    }
    [self changeTExt:@"全城招聘会·" secText:cityLabel.text];
    self.foot.userInteractionEnabled = YES;
    
    _cityCode = cityCode;
    [self.univercityInfo removeAllObjects];
    [self univercityRequestWithUnivercity:_univercity Page:@"1"];
    
}
- (void)sendValue:(jobRead *)city{
    
    NSString *last = [city.name substringFromIndex:city.name.length-1];
    if ([last isEqualToString:@"市"]) {
        NSString *b = [city.name substringToIndex:city.name.length-1 ];
        //开始截取
        cityLabel.text = b;
    }else{
        cityLabel.text = city.name;
    }
    self.foot.userInteractionEnabled = YES;
    
    _cityCode = city.code;
    
    
    
}

//发送请求方法
- (void)univercityRequestWithUnivercity:(BOOL)isUnivercity Page:(NSString *)page
{
    NSString *theURLStr;
    _requestTypeItem = requestTypeZP;
    [_actView show:@"加载中..."];
    [self.foot setTitle:@"" forState:UIControlStateNormal];
    NSMutableDictionary *parmDics;
    //CityInfo *city = [CityInfo standerDefault];
    if (isUnivercity)
    {
        parmDics = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects: IMEI,kUserTokenStr, @"20",page,@"2",_cityCode?:@"2012",  nil] forKeys:[NSArray arrayWithObjects: @"userImei",@"userToken",@"count",@"page",@"type",LocaCity, nil]];
        theURLStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,kZPListSociety];
    }else
    {
        parmDics = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects: IMEI,kUserTokenStr, @"20",page,@"1",_cityCode?:@"2012",  nil] forKeys:[NSArray arrayWithObjects: @"userImei",@"userToken",@"count",@"page",@"type",LocaCity, nil]];
        theURLStr = [NSString stringWithFormat:@"%@%@",KXZhiLiaoAPI,kZPListSociety];
    }
//    _net = [[NetWorkConnection alloc] init];
//    _net.delegate = self;
//    [_net requestCache:theURLStr param:parmDics];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:parmDics urlString:theURLStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        
        //        [loadView hide:YES];
        NSError *error;
        
        NSDictionary *univercityDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        
        self.foot.userInteractionEnabled = YES;
        [self.foot setTitle:@"更多" forState:UIControlStateNormal];
        [_actView hidden];
        NSNull *null = [NSNull null];
        NSObject *obj =[univercityDic valueForKey:@"recruitMeeting"];
        NSArray *array = [univercityDic valueForKey:@"recruitMeeting"];
        if ([obj isEqual:null]) {
            [self.theTableView setTableFooterView:nil];
            return;
        }
        if(_requestTypeItem == requestTypeUnivercity)
        {
            self.univercitys = [NSMutableArray array];
            [self.univercitys addObject:@"所有学校"];
            NSInteger num1 = 0;
            for (NSInteger i = 0; i<array.count; i++) {
                NSString *name = [array objectAtIndex:i];
                [self.univercitys addObject:name];
                num1++;
            }
            if (num1<20) {
                [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
                self.foot.userInteractionEnabled = NO;
                //[theTableView setTableFooterView:nil];
            }
            [self univercityRequestWithUnivercity:_univercity Page:@"1"];
            self.univercity = NO;
        }else
        {
            NSNull *null = [NSNull null];
            if (![array isEqual:null]) {
                [theTableView setTableFooterView:_foot];
                [self jsonWithDic:univercityDic];
                
            }else
            {
                [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
                self.foot.userInteractionEnabled = NO;
                //[theTableView setTableFooterView:nil];
            }
        }

    }];
    [request setFailedBlock:^{
        //        [loadView hide:YES];
       [_actView hidden];
        
    }];
    [request startAsynchronous];
}
#pragma -mark 网络异步请求
- (void)receiveRequestFinish:(NSData *)receData Connection:(NSURLConnection *)connection
{
    NSDictionary *univercityDic = [NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableLeaves error:nil];
    self.foot.userInteractionEnabled = YES;
    [self.foot setTitle:@"更多" forState:UIControlStateNormal];
    [_actView hidden];
    NSNull *null = [NSNull null];
    NSObject *obj =[univercityDic valueForKey:@"recruitMeeting"];
    NSArray *array = [univercityDic valueForKey:@"recruitMeeting"];
    if ([obj isEqual:null]) {
        [self.theTableView setTableFooterView:nil];
        return;
    }
    if(_requestTypeItem == requestTypeUnivercity)
    {
        self.univercitys = [NSMutableArray array];
        [self.univercitys addObject:@"所有学校"];
        NSInteger num1 = 0;
        for (NSInteger i = 0; i<array.count; i++) {
            NSString *name = [array objectAtIndex:i];
            [self.univercitys addObject:name];
            num1++;
        }
        if (num1<20) {
            [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
            self.foot.userInteractionEnabled = NO;
            //[theTableView setTableFooterView:nil];
        }
        [self univercityRequestWithUnivercity:_univercity Page:@"1"];
        self.univercity = NO;
    }else
    {
        NSNull *null = [NSNull null];
        if (![array isEqual:null]) {
            [theTableView setTableFooterView:_foot];
            [self jsonWithDic:univercityDic];
            
        }else
        {
            [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
            self.foot.userInteractionEnabled = NO;
            //[theTableView setTableFooterView:nil];
        }
    }
    
}
- (void)receiveRequestFail:(NSError *)error
{
    [_actView hidden];
}
- (void)jsonWithDic:(NSDictionary *)dicData
{
    NSArray *zpArray = [dicData valueForKey:@"data"];
    //    NSLog(@"招聘会＝%@",zpArray);
    NSDictionary *dic;
    NSString *status = [dicData valueForKey:@"status"];
    if ([status isEqualToString:@"error - no recruitMeeting"]) {
        if (self.univercity) {
            [self.univercityInfo removeAllObjects];
        }else
        {
            [self.fairsList removeAllObjects];
        }
        [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
        self.foot.userInteractionEnabled = NO;
        [self.theTableView reloadData];
        return;
    }
    
    NSInteger num2 = 0;
    for (int i = 0; i<zpArray.count; i++) {
        ZPInfo *oneInfo = [[ZPInfo alloc] init];
        dic = [zpArray objectAtIndex:i];
        oneInfo.z_id = [dic valueForKey:@"id"];
        oneInfo.z_title = [dic valueForKey:@"title"];
        oneInfo.date = [dic valueForKey:@"date"];
        oneInfo.week = [dic valueForKey:@"week"];
        oneInfo.time = [dic valueForKey:@"time"];
        oneInfo.address = [dic valueForKey:@"address"];
        oneInfo.descriptionStr = [dic valueForKey:@"description"];
        oneInfo.pubdate = [dic valueForKey:@"pubdate"];
        oneInfo.meetingType = [dic valueForKey:@"meetingtype"];
        oneInfo.area = [dic valueForKey:@"area"];
        oneInfo.companyName = [dic valueForKey:@"companyname"];
        oneInfo.schoolName = [dic valueForKey:@"schoolname"];
        num2++;
        if (self.univercity) {
            [self.univercityInfo addObject:oneInfo];
        }else
        {
            [self.fairsList addObject:oneInfo];
        }
    }
    if (num2<20) {
        [self.foot setTitle:@"亲，暂无更多数据" forState:UIControlStateNormal];
        self.foot.userInteractionEnabled = NO;
    }
    
    [self.theTableView reloadData];
}

//动画方法
- (void)viewAnimation:(UIView *)view frame:(CGRect)frame time:(float)time alph:(float)alpha
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopView)];
    view.frame = frame;
    view.alpha = alpha;
    [UIView commitAnimations];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
}


@end
