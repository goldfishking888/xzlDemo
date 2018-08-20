//
//  Bonus_JobDetailVCViewController.m
//  JobKnow
//
//  Created by Suny on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "Bonus_JobDetailVCViewController.h"

#import "CompanyIntroduce.h"
#import "MapViewController.h"
#import "WebViewController.h"
#import "UIMenuBarItem.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "WeiboViewController.h"
#import "OtherLogin.h"

#import "JobDetailView.h"
#import "BaiduMapViewController.h"


@interface Bonus_JobDetailVCViewController ()

@end

@implementation Bonus_JobDetailVCViewController

@synthesize isJianzhi;

-(void)initData
{
    num=ios7jj;
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        _index=0;
        
        _dataArray=[[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self addBackBtn];
    
    //获取职位详情
//    [self requestJobDetailData];
    
    //titleLabelx和titleLabely是用来显示标题的label
    titleLabelx = [[UILabel alloc]initWithFrame:CGRectMake(40,10+num, 220, 25)] ;
    [titleLabelx setTextAlignment:NSTextAlignmentLeft];
    [titleLabelx setBackgroundColor:[UIColor clearColor]];
    [titleLabelx setTextColor:RGBA(209, 120, 4, 1)];
    [titleLabelx setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:titleLabelx];
    
    titleLabely = [[UILabel alloc]initWithFrame:CGRectMake(39,9+num, 220, 25)] ;
    [titleLabely setTextAlignment:NSTextAlignmentLeft];
    [titleLabely setBackgroundColor:[UIColor clearColor]];
    [titleLabely setTextColor:[UIColor whiteColor]];
    [titleLabely setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:titleLabely];
    
    [self addTitleLabel:_positionModel.cname];
    
    //此处加分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(278,3+num, 45, 35);
    [shareBtn addTarget:self action:@selector(newShare:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"night_icon_share.png"] forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingyueqi_bg_for2"]];
    backgroundView.frame = CGRectMake(0, 44+num, iPhone_width,44);
    backgroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    //屏幕上方橙色下划线
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underLine.png"]];
    line.frame = CGRectMake(0,84+num,iPhone_width/2, 4);
    [self.view addSubview:line];
    
    //职位详情
    jobDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jobDetailBtn.frame = CGRectMake(0,44+num,160,44);
    [jobDetailBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
    [jobDetailBtn setTitle:@"职位详情" forState:UIControlStateNormal];
    [jobDetailBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [jobDetailBtn addTarget:self action:@selector(jobDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jobDetailBtn];
    
    //企业简介
    companyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    companyBtn.frame = CGRectMake(160, 44+num, 160, 44);
    [companyBtn setTitle:@"企业信息" forState:UIControlStateNormal];
    [companyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [companyBtn addTarget:self action:@selector(companyIntroduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:companyBtn];
    

    rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,44+44+num,iPhone_width,iPhone_height -44-44-num)];
    rootScrollView.pagingEnabled = YES;
    rootScrollView.bounces = NO;
    rootScrollView.delegate = self;
    rootScrollView.contentSize = CGSizeMake(iPhone_width * 2, iPhone_height - 44-44-num);
    [self.view  addSubview:rootScrollView];
    
    //职位详情
    _jobScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-num)];
    _jobScrollView.backgroundColor=XZHILBJ_colour;
    _jobScrollView.alwaysBounceVertical=YES;
    _jobScrollView.alwaysBounceHorizontal=NO;
    
    //企业信息
    _companyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(iPhone_width, 0, iPhone_width,iPhone_height - 44-num)];
    _companyScrollView.backgroundColor = XZHILBJ_colour;
    _companyScrollView.alwaysBounceVertical=YES;
    _companyScrollView.alwaysBounceHorizontal=NO;
    
    [rootScrollView addSubview:_jobScrollView];
    [rootScrollView addSubview:_companyScrollView];

    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"职位查看"];
}

#pragma mark 视图出现之前
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"职位查看"];
    
    if (detailView==nil){
        detailView=[[Bonus_JobDetailView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,200) WithJobDetail:_positionModel];
        detailView.delegate=self;
        [_jobScrollView addSubview:detailView];
        _jobScrollView.contentSize=CGSizeMake(iPhone_width, iPhone_height);
    }
    
    
    if (introduceView ==nil) {
        introduceView=[[Bonus_CompanyIntroView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,800) withModel:_positionModel];
        introduceView.delegate=self;
        [_companyScrollView addSubview:introduceView];
        _companyScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height);
    }
    
    [self resetJobScrollView];
    
}

-(void)resetJobScrollView{
    
    //职位描述
    NSString *introductionText=@"";
    
    if ([_positionModel.required isEqualToString:@""]) {
        //
        introductionText=@"无";
    }else
    {
        introductionText=_positionModel.required;
    }
    
    NSLog(@"预算的职位描述文本 in HR_JobDetailVC is %@",introductionText);
    
    CGSize autoSize2 = CGSizeMake(iPhone_width-10 ,MAXFLOAT);
    
    CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger introductionHeight=size2.height;
    
    
    NSLog(@"预算的职位描述文本高度 is %d",introductionHeight);
    
    //
    //    //all是用来修改整个tableViewCell的高度的。
    NSInteger allHeight=introductionHeight+10*45+35 +40;
    
    _jobScrollView.contentSize=CGSizeMake(iPhone_width,allHeight+142);
    
    
    [detailView.myTableView reloadData];
    
}

#pragma mark- 获取职位详情（请求问了web修改查看数，获取的职位数据没用，用的列表数据）

-(void)requestJobDetailData
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled=NO;
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,SeniorJobDetail);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",_position_id,@"jid",_cityCode,@"localcity",_pid,@"pid",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSDictionary *infoDic = [resultDic valueForKey:@"info"];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        if(!resultDic){
            
            //            ghostView.message=@"请重新登录";
            //            [ghostView show];
            
            
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"获取职位详情成功");
            //TODO 修改列表查看数
            _positionModel = [[SeniorJobDetailModel alloc] initWithDictionary:infoDic] ;
            detailView.positionModel = _positionModel;
            introduceView.positionModel = _positionModel;
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
}



#pragma mark-  UIScrollView代理方法的实现
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 160.0f) {  //屏幕在职位详情位置时
        
        _postItem=PostOne;
        
        [UIView animateWithDuration:0.3 animations:^{
            line.frame = CGRectMake(0,84+num, iPhone_width/2, 4);
        }];
        
        [jobDetailBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        rootScrollView.frame = CGRectMake(0,88+num,iPhone_width, iPhone_height - 88-num);
    }
    else //企业信息
    {
        
        _postItem=PostOne;
        //公司性质
        NSString *natureText=@"";
        
        natureText=_positionModel.corpprop;
        
        if ([natureText isEqualToString:@""]) {
            natureText=@"无";
        }
        
        CGSize autoSize = CGSizeMake(iPhone_width-20, MAXFLOAT);
        
        CGSize size = [natureText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
        NSInteger natureHeight=size.height;
        
        
        //所属行业
        NSString *industryText=@"";
        industryText=_positionModel.trade;
        
        if ([industryText isEqualToString:@""]) {
            industryText=@"无";
        }
        
        
        CGSize autoSize3 = CGSizeMake(iPhone_width, MAXFLOAT);
        CGSize size3 = [industryText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize3 lineBreakMode:NSLineBreakByWordWrapping];
        
        NSInteger industryHeight=size3.height;
        
        
        //企业简介
        NSString *introductionText=@"";
        
        if ([_positionModel.intro isEqualToString:@""]) {
            
            introductionText=@"无";
        }else
        {
            introductionText=_positionModel.intro;
        }
        
        NSLog(@"introductionText in JobReaderDetailVC is %@",introductionText);
        
        CGSize autoSize2 = CGSizeMake(iPhone_width,MAXFLOAT);
        
        CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:14.4] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
        
        NSInteger introductionHeight=size2.height;
        
        //职位名称
        CustomLabel*companyName = [[CustomLabel alloc]labelinitWithText2:_positionModel.cname X:5 Y:2];
        
        companyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        
        NSInteger companyHeight=companyName.frame.size.height;
        
        NSLog(@"companyHeight is %d",companyHeight);
        NSLog(@"natureHeight is %d",natureHeight);
        NSLog(@"introductionHeight is %d",introductionHeight);
        NSLog(@"industryHeight is %d",industryHeight);
        
        introduceView.natureHeight=natureHeight;
        introduceView.industryHeight=industryHeight;
        introduceView.introductionHeight=introductionHeight;
        
        //all是用来修改整个tableViewCell的高度的。
        NSInteger allHeight=companyHeight+natureHeight+industryHeight+introductionHeight+introduceView.count*45+200;
        
        NSLog(@"所有的高度加起来是 %d",allHeight);
        
        introduceView.frame=CGRectMake(0,0,iPhone_width,allHeight+150);
        
        introduceView.myTableView.frame=CGRectMake(0,companyHeight+5,iPhone_width,allHeight+100);
        
        _companyScrollView.contentSize=CGSizeMake(iPhone_width,allHeight+132+10);
        
        introduceView.isDownLoad=YES;
        
        [introduceView.myTableView reloadData];
        
        [UIView animateWithDuration:0.3 animations:^{
            line.frame = CGRectMake(iPhone_width/2,84+num, iPhone_width/2, 4);
        }];
        
        rootScrollView.frame = CGRectMake(0,88+num,iPhone_width,iPhone_height-88-num);
        
        [jobDetailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [companyBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        
    }
}

#pragma mark 屏幕上方的三个按钮点击响应事件
-(void)jobDetailBtnClick:(id)sender
{
    _postItem=PostOne;
    
    rootScrollView.frame = CGRectMake(0, 88+num, iPhone_width, iPhone_height -44-num-44);
    
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *btn = (UIButton *)sender;
        [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        line.frame = CGRectMake(0 ,84+num, iPhone_width/2, 4);
        [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        
        rootScrollView.contentOffset = CGPointMake(0, 0);
    }];
}

//企业简介按钮
-(void)companyIntroduceBtnClick:(id)sender
{
    _postItem=PostOne;
    
    rootScrollView.frame = CGRectMake(0,88+num,iPhone_width,iPhone_height-88-num);
    
    [UIView animateWithDuration:0.3 animations:^{UIButton *btn = (UIButton *)sender;
        
        [jobDetailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        line.frame = CGRectMake(iPhone_width/2 ,84+num, iPhone_width/2, 4);
        rootScrollView.contentOffset = CGPointMake(iPhone_width, 0);
    }];
    
    //公司性质
    NSString *natureText=@"";
    
    natureText=_positionModel.corpprop;
    
    if ([natureText isEqualToString:@""]) {
        natureText=@"无";
    }
    
    CGSize autoSize = CGSizeMake(iPhone_width-20, MAXFLOAT);
    
    CGSize size = [natureText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
    NSInteger natureHeight=size.height;
    
    
    //所属行业
    NSString *industryText=@"";
    industryText=_positionModel.trade;
    
    if ([industryText isEqualToString:@""]) {
        industryText=@"无";
    }
    
    
    CGSize autoSize3 = CGSizeMake(iPhone_width, MAXFLOAT);
    CGSize size3 = [industryText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize3 lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger industryHeight=size3.height;
    
    
    //企业简介
    NSString *introductionText=@"";
    
    if ([_positionModel.intro isEqualToString:@""]) {
        
        introductionText=@"无";
    }else
    {
        introductionText=_positionModel.intro;
    }
    
    NSLog(@"introductionText in JobReaderDetailVC is %@",introductionText);
    
    CGSize autoSize2 = CGSizeMake(iPhone_width,MAXFLOAT);
    
    CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:14.4] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger introductionHeight=size2.height;
    
    //职位名称
    CustomLabel*companyName = [[CustomLabel alloc]labelinitWithText2:_positionModel.cname X:5 Y:2];
    
    companyName.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    
    NSInteger companyHeight=companyName.frame.size.height;
    
    NSLog(@"companyHeight is %d",companyHeight);
    NSLog(@"natureHeight is %d",natureHeight);
    NSLog(@"introductionHeight is %d",introductionHeight);
    NSLog(@"industryHeight is %d",industryHeight);
    
    introduceView.natureHeight=natureHeight;
    introduceView.industryHeight=industryHeight;
    introduceView.introductionHeight=introductionHeight;
    
    //all是用来修改整个tableViewCell的高度的。
    NSInteger allHeight=companyHeight+natureHeight+industryHeight+introductionHeight+introduceView.count*45+200;
    
    NSLog(@"所有的高度加起来是 %d",allHeight);
    
    introduceView.frame=CGRectMake(0,0,iPhone_width,allHeight+150);
    
    introduceView.myTableView.frame=CGRectMake(0,companyHeight+5,iPhone_width,allHeight+100);
    
    _companyScrollView.contentSize=CGSizeMake(iPhone_width,allHeight+132+10);
    
    introduceView.isDownLoad=YES;
    
    [introduceView.myTableView reloadData];

}



//电话
-(void)telephoneBtnClick:(id)sender
{
    NSLog(@"电话按钮被点击了。。。");
    [self telephone:_positionModel.mobile];
}

#pragma mark 添加标题
-(void)addTitleLabel:(NSString*)title{
    NSLog(@"title in JobSeeVC  and addTitleLabel is %@",title);
    titleLabelx.text=title;
    titleLabely.text=title;
}

#pragma mark- JobDetailView的代理方法

-(void)toRuzhiJiangjinJieshao{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    JumpWebViewController *vc = [[JumpWebViewController alloc] init];
    //    vc.jumpRequest = [NSString stringWithFormat:@"http://api.xzhiliao.com/new_api/senior/senior_about?userImei=%@&userToken=%@",IMEI,[userDefaults valueForKey:@"userToken"]];;
    NSString *urlStr = [NSString stringWithFormat:@"%@new_api/senior/senior_about?userImei=%@&userToken=%@&ios_ver=2.8.5",KXZhiLiaoAPI,IMEI,[userDefaults valueForKey:@"userToken"]];
    vc.jumpRequest = urlStr;
    vc.webTitle = @"入职奖金";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)changeScreenHeight:(NSInteger)height
{
    NSLog(@"changeScreenHeight高度被改变了");
    NSLog(@"height in changeScreenHeight is %d",height);
    
    detailView.frame=CGRectMake(detailView.frame.origin.x,detailView.frame.origin.y,iPhone_width,height+120);
    detailView.myTableView.frame=CGRectMake(detailView.myTableView.frame.origin.x,detailView.myTableView.frame.origin.y,iPhone_width,height+100);
    //    _jobScrollView.contentSize=CGSizeMake(iPhone_width,height+112);
}

//地图搜索
-(void)baidu:(NSString *)urlStr  andTag:(NSString *)tag
{
    NSLog(@"百度搜索代理执行到了");
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.floog = @"公司搜索";
    NSString *url=@"";
    if ([tag isEqualToString:@"百度"]) {
        url = [[NSString alloc] initWithFormat:@"www.baidu.com/s?wd=%@",urlStr];
    }else
    {
        url =urlStr;
    }
    
    webVC.urlStr = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

//打电话
-(void)telephone:(NSString *)telephoneStr
{
    NSLog(@"电话按钮的代理方法被执行了");
    
    if ([telephoneStr isEqualToString:@"企业未公开"]){
        return;
    }
    
    
    UIActionSheet *actionSheet;
    
    //NSString * telephone = [[NSString alloc] initWithFormat:@"%@",telephoneStr];
    
    telStr=telephoneStr;
    
    if (telephoneStr.length >30&&telephoneStr.length<40){
        
        //三个电话截取字符
        NSRange range01 = [telStr rangeOfString:@" "];//获取$file/的位置
        
        NSString *str1 = [telStr substringFromIndex:range01.location +
                          range01.length];//开始截取
        
        
        title01 = [telStr substringToIndex:range01.location +range01.length];
        
        
        NSRange range02 = [str1 rangeOfString:@" "];
        
        
        title02 = [str1 substringToIndex:range02.location +range02.length];
        title03 = [str1 substringFromIndex:range02.location +range02.length];
        
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"拨打电话 "
                       delegate:self
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:title01,title02,title03,nil];
        actionSheet.tag =520;
        
    }else{
        
        if (telStr.length >20&&telStr.length<30) {
            
            NSLog(@"此处执行说明是两个电话号码");
            
            //两个电话截取字符串
            NSRange range = [telStr rangeOfString:@" "];//获取$file/的位置
            
            NSString *telphoneStr = [telStr substringFromIndex:range.location +
                                     range.length];//开始截取
            telStr01=telphoneStr;
            
            NSString *telphoneStr2 = [telStr substringToIndex:range.location +range.length];
            telStr02=telphoneStr2;
            
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"拨打电话 "
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:nil
                           otherButtonTitles:telphoneStr,telphoneStr2,nil];
            
            actionSheet.tag =521;
            
        }else{
            
            
            actionSheet = [[UIActionSheet alloc]
                           initWithTitle:@"拨打电话 "
                           delegate:self
                           cancelButtonTitle:@"取消"
                           destructiveButtonTitle:telStr
                           otherButtonTitles:nil];
            
            actionSheet.tag = 522;
        }
    }
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.view];
    
}

//发邮箱
-(void)email:(NSString *)emailStr
{
    NSLog(@"email 代理执行到了。。。。");
    
    NSArray *imageNames = [NSArray arrayWithObjects:@"139邮箱",@"189邮箱",@"google邮箱",@"hotemail邮箱",@"sohu邮箱",@"QQ邮箱",@"网易邮箱",@"yahoo邮箱", nil];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSInteger i = 1; i < 9; i++)
    {
        NSString *name = [imageNames objectAtIndex:i-1];
        NSString *imageStr = [[NSString alloc] initWithFormat:@"mail%d.png",i];
        UIImage *image = [UIImage imageNamed:imageStr];
        UIMenuBarItem *item = [[UIMenuBarItem alloc] initWithTitle:name target:self image:image action:@selector(clickItem:)];
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        item.tag = i;
        [images addObject:item];
    }
    
    _bar = [[UIMenuBar alloc] init];
    
    _bar.Menudelegate = self;
    
    [_bar setItems:images];
    [_bar show];
}


- (void)clickItem:(id)sender
{
    UIMenuBarItem *item = (UIMenuBarItem *)sender;
    WebViewController *webVC = [[WebViewController alloc] init];
    //    webVC.change = YES;
    webVC.floog = @"邮件";
    NSString *url = nil;
    switch (item.tag) {
        case 1:
            url = k139Email;
            break;
        case 2:
            url = k189Email;
            break;
        case 3:
            url = kGoogleEmail;
            break;
        case 4:
            url = kHotEmail;
            break;
        case 5:
            url = kSohuEmail;
            break;
        case 6:
            url = kQQEnail;
            break;
        case 7:
            url = kWangyi;
            break;
        case 8:
            url = kSohuEmail;
            break;
    }
    webVC.urlStr = url;
    [self.navigationController pushViewController:webVC animated:YES];
    [_bar dismiss];
}


//地址搜索
-(void)address:(NSString *)addressStr
{
    NSLog(@"地址搜索的代理执行到了 is %@",addressStr);
    BaiduMapViewController *mapVC = [[BaiduMapViewController alloc] init];
    mapVC.address = addressStr;
    [self.navigationController pushViewController:mapVC animated:YES];
}



//修改postBtn
-(void)changePostBtn:(NSString *)title
{
    if (title&&title.integerValue==0) {
        _numberBtn.alpha=0;
    }else
    {
        _numberBtn.alpha=1;
        [_numberBtn setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark 分享响应事件

- (void)newShare:(id)sender
{
    NSLog(@"分享按钮被执行到了。。。。。。");
    
   
}


////获取服务器保存的分享积分记录
//- (void)requestSave
//{
//    _net = [[NetWorkConnection alloc] init];
//    _net.delegate = self;
//    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken" ,nil];
//    NSString *url = kCombineURL(KXZhiLiaoAPI, Shar_score);
//    
//    [_net sendRequestURLStr:url ParamDic:paramDic Method:@"GET"];
//}



- (NSString *)messageContent
{
    ResumeOperation *resume = [ResumeOperation defaultResume];
    
    NSString *resumeId = [resume.resumeDictionary valueForKey:@"jlBianhao"];
    NSString *pn = [[NSUserDefaults standardUserDefaults] valueForKey:@"personName"];
    NSString *wy = [resume.resumeDictionary valueForKey:@"myWorkYear"];
    NSString *tel = [resume.resumeDictionary valueForKey:@"myTel"];
    NSString *infoString = [NSString stringWithFormat:@"您好，我是%@，应聘：%@",pn,_positionModel.jobName];
    
    NSString *degree = [resume.resumeDictionary valueForKey:@"degree"];
    if (degree.length > 0) {
        infoString = [infoString stringByAppendingFormat:@"我的学历是：%@",degree];
    }
    infoString = [infoString stringByAppendingFormat:@"工作年限 ：%@，我的联系电话是：%@，简历详情： [aa href=http://www.xzhiliao.com/admin/resume?rid=%@]http://www.xzhiliao.com/admin/resume?rid=%@[/aa]",wy,tel,resumeId,resumeId];
    return infoString;
}

#pragma -mark UIActionSheetDeleate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"UIActionSheet is Clicked!");
    
    if (actionSheet.tag==520) {   //3个电话
        
        
        if (buttonIndex==0){
            
            
            [self testTelephone];
            
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",title01];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
            
        }else if(buttonIndex==1)
        {
            [self testTelephone];
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",title02];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
            
            
        }else if (buttonIndex ==2)
        {
            [self testTelephone];
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",title03];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }else if (actionSheet.tag==521)  //2个电话的时候
    {
        NSLog(@"actionSheet.tag==521 and buttonIndex is %d",buttonIndex);
        
        if (buttonIndex==0) {
            
            [self testTelephone];
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",telStr01];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
            
        }else if(buttonIndex ==1)
        {
            [self testTelephone];
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",telStr02];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }else if (actionSheet.tag==522)
    {
        if (buttonIndex==0) {
            
            [self testTelephone];
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",telStr];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}


#pragma mark 返回按钮
- (void)backUp:(id)sender
{
    [self.delegate jobReaderDetailVC];
    
    NSLog(@"backUp被执行。。。。。");
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 设置底部按钮的alpha值

-(void)testTelephone
{
    NSString* deviceType = [UIDevice currentDevice].model;
    
    NSLog(@"deviceType is %@",deviceType);
    
    if (![deviceType isEqualToString:@"iPhone"]){
        ghostView.message=@"当前设备不支持通话";
        [ghostView show];
        return;
    }
    
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
