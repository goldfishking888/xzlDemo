//
//  HR_JobDetailVC.m
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
// HR圈的简历详情

#import "HR_JobDetailVC.h"
#import "CompanyIntroduce.h"
#import "MapViewController.h"
#import "WebViewController.h"
#import "UIMenuBarItem.h"
#import "AppDelegate.h"
#import "WebViewController.h"
#import "WeiboViewController.h"
#import "OtherLogin.h"
#import "BaiduMapViewController.h"
#import "MessageDetailViewController.h"
#import "MessageListModel.h"

#import "JobDetailView.h"

@interface HR_JobDetailVC ()

@end

@implementation HR_JobDetailVC

@synthesize isJianzhi;

-(void)initData
{
    num=ios7jj;
    ghostView=[[OLGhostAlertView alloc]initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position=OLGhostAlertViewPositionCenter;
    [self creatResumeIntroView];
    [self creatRuzhiIntroView];
}

-(void)creatResumeIntroView{
    introView_back = [[UIView alloc] initWithFrame:self.view.frame];
    introView_back.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.75];
    introView = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 258, 200)];
    [introView.layer setCornerRadius:4];
    [introView.layer setMasksToBounds:YES];
    introView.backgroundColor = [UIColor whiteColor];
    [introView_back addSubview:introView];
    introView_back.center = self.view.center;
    introView.center = introView_back.center;
    label_intro_A = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, introView.frame.size.width-35, 60)];
    [label_intro_A setFont:[UIFont boldSystemFontOfSize:14]];
    label_intro_A.numberOfLines = 0;
    [label_intro_A setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_A setText:@"您推荐的简历被企业付费查看之后，您可获得与简历价值金额相等的奖金。"];
    [label_intro_A setFont:[UIFont systemFontOfSize:15]];
    introView_line = [[UIView alloc] initWithFrame:CGRectMake(20, label_intro_A.frame.origin.y+label_intro_A.frame.size.height +15, introView.frame.size.width-40, 1)];
    [introView_line setBackgroundColor:[UIColor colorWithHex:0xf0f0f0 alpha:1]];
    
    
    label_intro_B = [[UILabel alloc] initWithFrame:CGRectMake(40, introView_line.frame.origin.y+introView_line.frame.size.height +15, introView.frame.size.width-60, 60)];
    [label_intro_B setFont:[UIFont systemFontOfSize:12]];
    [label_intro_B setTextColor:color_lightgray];
    label_intro_B.numberOfLines = 0;
    [label_intro_B setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_B setText:@"例:您给企业推荐了一份价格为15元的简历，企业付费阅读后，您可获得15元的简历奖金。"];
    
    imagePointB = [[UIImageView alloc] initWithFrame:CGRectMake(20, label_intro_B.frame.origin.y+10, 4, 4)];
    [imagePointB setImage:[UIImage imageNamed:@"point_img"]];
    
    [introView addSubview:label_intro_A];
    [introView addSubview:introView_line];
    
    [introView addSubview:label_intro_B];
    
    [introView addSubview:imagePointB];
    
    
    [introView_back setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introView_backClick)];
    [introView_back addGestureRecognizer:tap];
}

-(void)creatRuzhiIntroView{
    introView_back_2 = [[UIView alloc] initWithFrame:self.view.frame];
    introView_back_2.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.75];
    introView_2 = [[UIView alloc] initWithFrame:CGRectMake(40, 100, 258, 320)];
    [introView_2.layer setCornerRadius:4];
    [introView_2.layer setMasksToBounds:YES];
    introView_2.backgroundColor = [UIColor whiteColor];
    [introView_back_2 addSubview:introView_2];
    introView_back_2.center = self.view.center;
    introView_2.center = introView_back_2.center;
    label_intro_A_2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, introView_2.frame.size.width-30, 40)];
//    [label_intro_A_2 setFont:[UIFont boldSystemFontOfSize:14]];
    label_intro_A_1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, introView_2.frame.size.width-30, 20)];
    [label_intro_A_1 setFont:[UIFont systemFontOfSize:17]];
    [label_intro_A_1 setTextColor:XZhiL_colour];
    [label_intro_A_1 setTextAlignment:NSTextAlignmentCenter];
    [label_intro_A_1 setText:@" 这是该职位的总推荐奖金 "];
    
    label_intro_A_2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label_intro_A_1.frame.origin.y + label_intro_A_1.frame.size.height + 10, introView_2.frame.size.width-30, 40)];
    //    [label_intro_A_2 setFont:[UIFont boldSystemFontOfSize:14]];
    label_intro_A_2.numberOfLines = 0;
    [label_intro_A_2 setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_A_2 setText:@"    所有简历只有在通过了官方猎头逐一审核通过后才会推荐给企业;"];
    [label_intro_A_2 setFont:[UIFont systemFontOfSize:15]];
    
    imagePointA_2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, label_intro_A_2.frame.origin.y+8, 6, 6)];
    [imagePointA_2 setImage:[UIImage imageNamed:@"point_img"]];
    
    label_intro_B_2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label_intro_A_2.frame.origin.y+label_intro_A_2.frame.size.height +10, introView_2.frame.size.width-30, 40)];
    [label_intro_B_2 setFont:[UIFont systemFontOfSize:15]];
    //    [label_intro_B_2 setTextColor:color_lightgray];
    label_intro_B_2.numberOfLines = 0;
    [label_intro_B_2 setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_B_2 setText:@"    如果您推荐的人才入职了,您可获该奖金的80%;"];
    
    imagePointB_2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, label_intro_B_2.frame.origin.y+8, 6, 6)];
    [imagePointB_2 setImage:[UIImage imageNamed:@"point_img"]];
    
    label_intro_B_3 = [[UILabel alloc] initWithFrame:CGRectMake(15, label_intro_B_2.frame.origin.y+label_intro_B_2.frame.size.height +10, introView_2.frame.size.width-30, 72)];
    [label_intro_B_3 setFont:[UIFont systemFontOfSize:15]];
    //    [label_intro_B_2 setTextColor:color_lightgray];
    label_intro_B_3.numberOfLines = 0;
    [label_intro_B_3 setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_B_3 setText:@"    如果您推荐的人才未入职,但简历被企业查看了,则您可与其他简历被企业查看的推荐人均分奖金的另20%;"];
    
    imagePointB_3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, label_intro_B_3.frame.origin.y+8, 6, 6)];
    [imagePointB_3 setImage:[UIImage imageNamed:@"point_img"]];
    
    //第4个
    label_intro_C_1 = [[UILabel alloc] initWithFrame:CGRectMake(15, label_intro_B_3.frame.origin.y+label_intro_B_3.frame.size.height +10, introView_2.frame.size.width-30, 40)];
    [label_intro_C_1 setFont:[UIFont systemFontOfSize:15]];
    //    [label_intro_B_2 setTextColor:color_lightgray];
    label_intro_C_1.numberOfLines = 0;
    [label_intro_C_1 setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_C_1 setText:@"    所获奖金被记入业绩,可参与提成;"];
    
    imagePointC_1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, label_intro_C_1.frame.origin.y+8, 6, 6)];
    [imagePointC_1 setImage:[UIImage imageNamed:@"point_img"]];
    
    //5
    label_intro_C_2 = [[UILabel alloc] initWithFrame:CGRectMake(15, label_intro_C_1.frame.origin.y+label_intro_C_1.frame.size.height +10, introView_2.frame.size.width-30, 40)];
    [label_intro_C_2 setFont:[UIFont systemFontOfSize:15]];
    //    [label_intro_B_2 setTextColor:color_lightgray];
    label_intro_C_2.numberOfLines = 0;
    [label_intro_C_2 setLineBreakMode:NSLineBreakByWordWrapping];
    [label_intro_C_2 setText:@"   满60份后3日内依然未有确定人选时,则自动重启合推。"];
    
    imagePointC_2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, label_intro_C_2.frame.origin.y+8, 6, 6)];
    [imagePointC_2 setImage:[UIImage imageNamed:@"point_img"]];
    
    
    
    [introView_2 addSubview:label_intro_A_2];
    
    [introView_2 addSubview:label_intro_B_2];
    
    [introView_2 addSubview:label_intro_B_3];
    
    [introView_2 addSubview:label_intro_A_1];
    
    [introView_2 addSubview:imagePointB_2];
    [introView_2 addSubview:imagePointB_3];
    [introView_2 addSubview:imagePointA_2];
    
    [introView_2 addSubview:label_intro_C_1];
    [introView_2 addSubview:label_intro_C_2];
    [introView_2 addSubview:imagePointC_1];
    [introView_2 addSubview:imagePointC_2];
    
    [introView_back_2 setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(introView_2_backClick)];
    [introView_back_2 addGestureRecognizer:tap];
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
    
    positionModel = [_dataArray objectAtIndex:_index];
    
    positionModel.isRead=@"1";

    //获取职位详情
    [self requestJobDetailData];
    //获取职位分享链接
    [self requestShareLink];
    
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
    
    [self addTitleLabel:positionModel.companyName];
    
    //此处加分享按钮
    shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(iPhone_width - 40,3+num, 45, 35);
    [shareBtn addTarget:self action:@selector(newShare:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"night_icon_share.png"] forState:UIControlStateNormal];
    [self.view addSubview:shareBtn];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingyueqi_bg.png"]];
    backgroundView.frame = CGRectMake(0, 44+num, iPhone_width,44);
    backgroundView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    //屏幕上方橙色下划线
    line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"underLine.png"]];
    line.frame = CGRectMake(0,84+num,iPhone_width/3, 4);
    [self.view addSubview:line];
    
    //职位详情
    jobDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jobDetailBtn.frame = CGRectMake(10,44+num,iPhone_width/3,44);
    [jobDetailBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
    [jobDetailBtn setTitle:@"职位详情" forState:UIControlStateNormal];
    [jobDetailBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [jobDetailBtn addTarget:self action:@selector(jobDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jobDetailBtn];
    
    //企业简介
    companyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    companyBtn.frame = CGRectMake(iPhone_width/3, 44+num, iPhone_width/3, 44);
    [companyBtn setTitle:@"企业信息" forState:UIControlStateNormal];
    [companyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [companyBtn addTarget:self action:@selector(companyIntroduceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:companyBtn];
    
    //其它职位
    otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherBtn.frame = CGRectMake(iPhone_width*2/3,44+num,iPhone_width/3,44);
    [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [otherBtn setTitle:@"其它职位" forState:UIControlStateNormal];
    [otherBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [otherBtn addTarget:self action:@selector(otherJobsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherBtn];
    
    rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,88+num,iPhone_width,iPhone_height - 133)];
    rootScrollView.pagingEnabled = YES;
    rootScrollView.bounces = NO;
    rootScrollView.delegate = self;
    rootScrollView.contentSize = CGSizeMake(iPhone_width * 3, iPhone_height - 133);
    [self.view  addSubview:rootScrollView];
    
    //职位详情
    _jobScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,iPhone_height-44-num-45)];
    _jobScrollView.backgroundColor=XZHILBJ_colour;
    _jobScrollView.alwaysBounceVertical=YES;
    _jobScrollView.alwaysBounceHorizontal=NO;
    
    //企业信息
    _companyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(iPhone_width, 0, iPhone_width,iPhone_height - 88)];
    _companyScrollView.backgroundColor = XZHILBJ_colour;
    _companyScrollView.alwaysBounceVertical=YES;
    _companyScrollView.alwaysBounceHorizontal=NO;
    
    [rootScrollView addSubview:_jobScrollView];
    [rootScrollView addSubview:_companyScrollView];
    [rootScrollView addSubview:otherView];
    
    //屏幕下方的图
    bottomImage=[[UIView alloc]init];
    bottomImage.backgroundColor=[UIColor whiteColor];
    
    if (IOS7) {
        bottomImage.frame = CGRectMake(0,iPhone_height - 45, iPhone_width, 45);
    }else
    {
        bottomImage.frame = CGRectMake(0,iPhone_height -65,iPhone_width, 45);
    }
    
    [self.view addSubview:bottomImage];
    
    UIView *view_bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 1)];
    [view_bottomLine setBackgroundColor:color_view_line];
    [bottomImage addSubview:view_bottomLine];
    
    //上一条
    _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lastBtn.frame =CGRectMake(0,2, iPhone_width/5, 45);
    [_lastBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_lastBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_lastBtn setTitle:@"上一条" forState:UIControlStateNormal];
    [_lastBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_lastBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_lastBtn setTitleEdgeInsets:UIEdgeInsetsMake(2,0, 3, 0)];
    [_lastBtn setBackgroundImage:[UIImage imageNamed:@"left_n@2x.png"] forState:UIControlStateNormal];
    [_lastBtn setBackgroundImage:[UIImage imageNamed:@"left_l@2x.png"] forState:UIControlStateHighlighted];
    [_lastBtn addTarget:self action:@selector(lastBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //明细
    UIImage *detailImage=[UIImage imageNamed:@"mingxi.png"];
    UIImageView *detailImageView=[[UIImageView alloc]initWithImage:detailImage];
    detailImageView.frame=CGRectMake(7,-2,50,50);
    detailImageView.tag=101;
    
    _mingxiBtn = [myButton buttonWithType:UIButtonTypeCustom];
    _mingxiBtn.frame =CGRectMake(0,2, iPhone_width/5, 45);
    [_mingxiBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_mingxiBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_mingxiBtn setTitle:@"明细" forState:UIControlStateNormal];
    [_mingxiBtn setTitle:@"明细" forState:UIControlStateSelected];
    [_mingxiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_mingxiBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_mingxiBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    
    [_mingxiBtn addSubview:detailImageView];
    
    [_mingxiBtn addTarget:self action:@selector(mingxiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //收藏
    _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectionBtn.tag=1024;
    _collectionBtn.frame = CGRectMake(iPhone_width/5,2, iPhone_width/5, 45);
    [_collectionBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_collectionBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    
    [_collectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_collectionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [_collectionBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [_collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //当前职位是否已经被收藏，0表示没有，1表示有
    if (positionModel.isfavorites.integerValue==0) {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favourite_l.png"] forState:UIControlStateHighlighted];
    }else
    {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateNormal];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateHighlighted];
    }
    
    //推荐
    _postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _postBtn.frame = CGRectMake(iPhone_width*2/5,2,iPhone_width/5, 45);
    [_postBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_postBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [_postBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [_postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_postBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_postBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_postBtn setBackgroundImage:[UIImage imageNamed:@"post_n.png"] forState:UIControlStateNormal];
    [_postBtn setBackgroundImage:[UIImage imageNamed:@"post_l.png"] forState:UIControlStateHighlighted];
    [_postBtn addTarget:self action:@selector(postBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //电话
    _telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _telephoneBtn.frame = CGRectMake(128,2,iPhone_width/5, 45);
    [_telephoneBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_telephoneBtn setTitle:@"电话" forState:UIControlStateNormal];
    [_telephoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_telephoneBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_telephoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [_telephoneBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_telephoneBtn setBackgroundImage:[UIImage imageNamed:@"ip01.png"] forState:UIControlStateNormal];
    [_telephoneBtn setBackgroundImage:[UIImage imageNamed:@"ip02.png"] forState:UIControlStateHighlighted];
    [_telephoneBtn addTarget:self action:@selector(telephoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //私信
    _sixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sixinBtn.frame = CGRectMake(iPhone_width*3/5,2, iPhone_width/5, 45);
    [_sixinBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_sixinBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_sixinBtn setTitle:@"私信" forState:UIControlStateNormal];
    [_sixinBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [_sixinBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_sixinBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_sixinBtn setBackgroundImage:[UIImage imageNamed:@"message_p.png"] forState:UIControlStateNormal];
    [_sixinBtn setBackgroundImage:[UIImage imageNamed:@"message_pl.png"] forState:UIControlStateHighlighted];
    [_sixinBtn addTarget:self action:@selector(sixinBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //下一条
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(iPhone_width*4/5 ,2, iPhone_width/5, 45);
    [_nextBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
    [_nextBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
    [_nextBtn setTitle:@"下一条" forState:UIControlStateNormal];
    [_nextBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
    [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"right_l.png"] forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:[UIImage imageNamed:@"right_p.png"] forState:UIControlStateHighlighted];
    [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _numberBtn.alpha = 0;
    _numberBtn.frame = CGRectMake(160,2,18,18);
    
    [_numberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_numberBtn setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateNormal];
    [_numberBtn setBackgroundImage:[UIImage imageNamed:@"number.png"] forState:UIControlStateHighlighted];
    [_numberBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:8]];
    
    //初始化的时候
    if (_tag!=4){
        _mingxiBtn.alpha=0;
        _telephoneBtn.alpha=0;
        
    }else
    {
        NSLog(@"当前是兼职职位");
        _sixinBtn.alpha=0;
        _postBtn.alpha=0;
        _collectionBtn.alpha=0;
        _mingxiBtn.alpha=0;
    }
    
    [bottomImage addSubview:_nextBtn];
    [bottomImage addSubview:_mingxiBtn];
    [bottomImage addSubview:_collectionBtn];
    [bottomImage addSubview:_postBtn];
    [bottomImage addSubview:_sixinBtn];
    [bottomImage addSubview:_lastBtn];
    [bottomImage addSubview:_telephoneBtn];
    [bottomImage addSubview:_numberBtn];
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
        detailView=[[HR_JobDetailView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,200) WithJobDetail:positionModel];
        detailView.delegate=self;
        [_jobScrollView addSubview:detailView];
        _jobScrollView.contentSize=CGSizeMake(iPhone_width, iPhone_height);
        [_jobScrollView setBackgroundColor:[UIColor clearColor]];
//        [rootScrollView addSubview:detailView];
    }
    [self resetJobScrollView];
    
    if (introduceView ==nil) {
        introduceView=[[HR_CompanyIntroView alloc]initWithFrame:CGRectMake(0,0,iPhone_width,800) withModel:positionModel];
        introduceView.delegate=self;
        [_companyScrollView addSubview:introduceView];
        _companyScrollView.contentSize=CGSizeMake(iPhone_width,iPhone_height);
    }

    if (otherView ==nil){
        otherView=[[HR_OtherJobListView alloc]initWithFrame:CGRectMake(iPhone_width*2,0,iPhone_width,iPhone_height-44-num-45-44) withModel:positionModel];
        otherView.otherDelegate=self;
        otherView.backgroundColor=[UIColor clearColor];
        [rootScrollView addSubview:otherView];
    }
}

#pragma mark- 获取职位详情（请求问了web修改查看数，获取的职位数据没用，用的列表数据）

-(void)requestJobDetailData
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled=NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *cityCode = [userDefaults valueForKey:@"cityCode"];
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRJobDetail);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.postId,@"jobId",cityCode,@"cityCode",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSError *error;
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        if(errorStr.integerValue == 0){
            NSLog(@"获取职位详情成功");
            //TODO 修改列表查看数
            
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
}

#pragma mark- 获取分享链接

-(void)requestShareLink
{
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    loadView.userInteractionEnabled=NO;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *cityCode = [userDefaults valueForKey:@"cityCode"];
    NSString *inviteCode = [userDefaults valueForKey:@"inviteId"];
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,SharePosition);
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:inviteCode,@"inviteCode",positionModel.postId,@"postId",positionModel.jobName,@"jobName",positionModel.companyName,@"companyName",positionModel.salary,@"salary",_cityCode,@"localcity",@"1",@"u_type",[XZLUtil currentVersion],@"version",IMEI,@"userImei",kUserTokenStr,@"userToken",@"xzhiliao",@"source",nil];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
    [request setCompletionBlock:^{
        [loadView hide:YES];
        NSError *error;
        shareDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[shareDic valueForKey:@"error"];
        if(!shareDic){
            ghostView.message=@"获取分享链接失败";
            [ghostView show];
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"获取职位分享链接成功");
 
        }
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
}


-(void)resetJobScrollView{
    
    //职位描述
    NSString *introductionText=@"";
    
    if ([positionModel.required isEqualToString:@""]) {
//
        introductionText=@"无";
    }else
    {
        introductionText=positionModel.required;
    }
    
    NSLog(@"预算的职位描述文本 in HR_JobDetailVC is %@",introductionText);
    
    CGSize autoSize2 = CGSizeMake(iPhone_width - 20,MAXFLOAT);
    
    CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
    
    NSInteger introductionHeight=size2.height;
    

    NSLog(@"预算的职位描述文本高度 is %d",introductionHeight);

//    
//    //all是用来修改整个tableViewCell的高度的。
    NSInteger allHeight=introductionHeight+10*45+35 +40;
    
    _jobScrollView.contentSize=CGSizeMake(iPhone_width,allHeight+132);
    
    
    [detailView.myTableView reloadData];

}

#pragma mark  UIScrollView代理方法的实现
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 20.0f) {  //屏幕在职位详情位置时
        
        [self setFirst];//设置屏幕底部的按钮
        
        //显示分享按钮
        [shareBtn setHidden:NO];
        
        _postItem=PostOne;
        
        [UIView animateWithDuration:0.3 animations:^{
            line.frame = CGRectMake(0,84+num, iPhone_width/3, 4);
        }];
        
        [jobDetailBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        rootScrollView.frame = CGRectMake(0,88+num,iPhone_width, iPhone_height - 133);
    }
    else if(iPhone_width - 10 < scrollView.contentOffset.x && scrollView.contentOffset.x< iPhone_width*2)//企业信息
    {
        
        [self setSecond];
        
        //隐藏分享按钮
        [shareBtn setHidden:YES];
        
        _postItem=PostOne;
        
        Net *n=[Net standerDefault];
        
        if (n.status ==NotReachable) {
            ghostView.message=@"无网络连接,请检查您的网络!";
            [ghostView show];
            return;
        }
        
        if (!introduceView.companyDic) {
            
            
//            _net=[[NetWorkConnection alloc]init];
//            
//            _net.delegate=self;
            
            NSString *url = kCombineURL(KXZhiLiaoAPI,kNewCompanyDetail);
            
            NSLog(@"positionInfo.companyId is %@",positionModel.companyId);
            
            NSLog(@"positionInfo.workAreaCode is %@",positionModel.cityCode);
            
            NSDictionary *paramDic;
            
            if(isJianzhi){
                
                paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.postId,@"cid",_cityCode,@"localcity",nil];
                
            }else
            {
                paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.companyId,@"cid",positionModel.cityCode,@"localcity",nil];
            }
            
            _typeItem=CompanyIntro;
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
//            [_net request:url param:paramDic andTime:20];
            
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
            [request setCompletionBlock:^{
                
                [loadView hide:YES];
                
                NSError *error;
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
                
                NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
                
                NSLog(@"receStr in ReceiveDataFin is %@",receStr);
                
                
                if (resultDic) {
                    
                }else
                {
                    ghostView.message=@"下载失败";
                    [ghostView show];
                    return;
                }
                
                _companyDic=[NSMutableDictionary dictionaryWithDictionary:resultDic];
                
                NSLog(@"resultDic in CompanyIntro is %@",resultDic);
                
                introduceView.companyDic=_companyDic;
                
                //如果是兼职的话，可能是空，所以应该进行一下判断
                
                //公司性质
                NSString *natureText=@"";
                
                natureText=[resultDic valueForKey:@"companyNature"];
                
                if ([natureText isEqualToString:@""]) {
                    natureText=@"无";
                }
                
                CGSize autoSize = CGSizeMake(iPhone_width-20, MAXFLOAT);
                
                CGSize size = [natureText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
                NSInteger natureHeight=size.height;
                
                
                //所属行业
                NSString *industryText=@"";
                industryText=[resultDic valueForKey:@"companyIndustry"];
                
                if ([industryText isEqualToString:@""]) {
                    industryText=@"无";
                }
                
                CGSize autoSize3 = CGSizeMake(iPhone_width, MAXFLOAT);
                CGSize size3 = [industryText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize3 lineBreakMode:NSLineBreakByWordWrapping];
                
                NSInteger industryHeight=size3.height;
                
                //企业简介
                NSString *introductionText=@"";
                
                if ([[resultDic valueForKey:@"companyIntroduction"] isEqualToString:@""]) {
                    
                    introductionText=@"无";
                }else
                {
                    introductionText=[resultDic valueForKey:@"companyIntroduction"];
                }
                
                NSLog(@"introductionText in JobReaderDetailVC is %@",introductionText);
                
                CGSize autoSize2 = CGSizeMake(iPhone_width,MAXFLOAT);
                
                CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:14.4] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
                
                NSInteger introductionHeight=size2.height;
                
                //职位名称
                CustomLabel*companyName = [[CustomLabel alloc]labelinitWithText2:positionModel.companyName X:5 Y:2];
                
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

  
            }];
            [request setFailedBlock:^{
                [loadView hide:YES];
                
                ghostView.message=@"下载失败";
                [ghostView show];
                
            }];
            [request startAsynchronous];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            line.frame = CGRectMake(iPhone_width/3,84+num, iPhone_width/3, 4);
        }];
        
        rootScrollView.frame = CGRectMake(0,88+num,iPhone_width,iPhone_height-88);
        
        [jobDetailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [companyBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }else if(scrollView.contentOffset.x > iPhone_width*2 - 10)  //其他职位
    {
        
        [self setThrid];
        
        //隐藏分享按钮
        [shareBtn setHidden:YES];
        
        _postItem=PostOther;
        
        [UIView animateWithDuration:0.3 animations:^{
            line.frame = CGRectMake(iPhone_width*2/3, 84+num, iPhone_width/3, 4);
        }];
        rootScrollView.frame = CGRectMake(0,88+num, iPhone_width, iPhone_height - 88);
        [jobDetailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [otherBtn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        
        if (!otherView.otherDic) {
            
//            _net=[[NetWorkConnection alloc]init];
//            _net.delegate=self;
            
            NSString *url = kCombineURL(KWWWXZhiLiaoAPI,kWWWNewOtherJobs);
            
            NSLog(@"positionModel.companyId is %@",positionModel.companyId);
            
            NSLog(@"positionInfo.workAreaCode is %@",positionModel.cityCode);
            
            NSDictionary *paramDic;
            
            if (isJianzhi) {
                
                
                otherView.isJianzhi=YES;
                
                paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"role",@"3",IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.postId,@"cid",positionModel.postId,@"pid",@"1",@"type",_cityCode,@"localcity",@"1",@"page",nil];
            }else
            {
                otherView.isJianzhi=NO;
                
                paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"role",@"3",IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.companyId,@"cid",@"0",@"type",positionModel.cityCode,@"localcity",@"1",@"page",nil];
            }
            
            Net *n=[Net standerDefault];
            
            if (n.status ==NotReachable) {
                ghostView.message=@"无网络连接,请检查您的网络!";
                [ghostView show];
                return;
            }
            
            _typeItem=OtherJob;
            
            loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
//            [_net request:url param:paramDic andTime:20];
            
            NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
            [request setCompletionBlock:^{
                
                [loadView hide:YES];
                
                NSError *error;
                
                NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
                
//                NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//                
//                NSLog(@"receStr in ReceiveDataFin is %@",receStr);
                NSNumber *error_code =[resultDic valueForKey:@"error_code"];
                
                NSLog(@"resultDic in 其他职位 is %@",resultDic);
                
                if (resultDic) {
                    
                }else
                {
                    ghostView.message=@"下载失败";
                    [ghostView show];
                    return;
                }
                
                NSMutableDictionary * dicss = [NSMutableDictionary dictionaryWithCapacity:0];
                dicss = [resultDic valueForKey:@"data"];
                _otherDic=[NSMutableDictionary dictionaryWithCapacity:0];
                _otherDic = dicss;
                otherView.otherDic= dicss;
                
                NSArray *arr=[resultDic valueForKey:@"data"];
                
                if ([arr count]==0) {
                    ghostView.message=@"主人，该公司没有其他职位哟";
                    [ghostView show];
                    return;
                }
                
                for (int i=0;i<[arr count];i++) {
                    NSDictionary *dic=[arr objectAtIndex:i];
                    HRHomeIntroduceModel *model=[[HRHomeIntroduceModel alloc]initWithDictionary:dic];
                    [otherView.dataArray addObject:model];
                }
                
                NSLog(@"otherView.dataArray count is %d",[otherView.dataArray count]);
                
                otherView.myTableView.contentSize=CGSizeMake(iPhone_width,[otherView.dataArray count]*70+50);
                
                UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, otherView.myTableView.frame.size.width, 30)];
                [viewHead setBackgroundColor:[UIColor clearColor]];
                RTLabel *label_rec =  [[RTLabel alloc] initWithFrame:CGRectMake(12,5,iPhone_width - 150,20)];
                [label_rec setBackgroundColor:[UIColor clearColor]];
                label_rec.font = [UIFont systemFontOfSize:14];
                label_rec.backgroundColor = [UIColor clearColor];
                NSString *salaryStr=[NSString stringWithFormat:@"%@：<font color='#f76806'>%@</font> 条",@"其他职位:",[_otherDic valueForKey:@"allCounts"]];
                label_rec.text=salaryStr;
                [viewHead addSubview:label_rec];
                otherView.myTableView.tableHeaderView = viewHead;
                
                [otherView.myTableView reloadData];
                
                [otherView setFooterView];
                
                if ([otherView.dataArray count]!=20) {
                    [otherView removeFooterView];
                }
                
                if ([otherView.dataArray count]==0) {
                    ghostView.message=@"该企业没有更多职位~";
                    [ghostView show];
                    
                }

            }];
            [request setFailedBlock:^{
                [loadView hide:YES];
                
                ghostView.message=@"下载失败";
                [ghostView show];
                
            }];
            [request startAsynchronous];
        }
    }
}

#pragma mark 屏幕上方的三个按钮点击响应事件
-(void)jobDetailBtnClick:(id)sender
{
    [self setFirst];
    
    _postItem=PostOne;
    
    rootScrollView.frame = CGRectMake(0, 88+num, iPhone_width, iPhone_height -44-num-44-45);
    
    [UIView animateWithDuration:0.3 animations:^{
        UIButton *btn = (UIButton *)sender;
        [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        line.frame = CGRectMake(0 ,84+num, iPhone_width/3, 4);
        [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        
        rootScrollView.contentOffset = CGPointMake(0, 0);
    }];
}

//企业简介按钮
-(void)companyIntroduceBtnClick:(id)sender
{
    [self setSecond];
    
    _postItem=PostOne;
    
    rootScrollView.frame = CGRectMake(0,88+num,iPhone_width,iPhone_height-88-45);
    
    [UIView animateWithDuration:0.3 animations:^{UIButton *btn = (UIButton *)sender;
        
        [jobDetailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [otherBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        line.frame = CGRectMake(iPhone_width/3 ,84+num, iPhone_width/3, 4);
        rootScrollView.contentOffset = CGPointMake(iPhone_width, 0);
    }];
    
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    if(!introduceView.companyDic){
        
//        _net=[[NetWorkConnection alloc]init];
//        _net.delegate=self;
        
        NSString *url = kCombineURL(KXZhiLiaoAPI,kNewCompanyDetail);
        
        NSLog(@"positionInfo.companyId is %@",positionModel.companyId);
        
        NSLog(@"positionInfo.workAreaCode is %@",positionModel.cityCode);
        
        NSLog(@"_cityCode is %@",_cityCode);
        
        NSDictionary *paramDic;
        
        NSLog(@"isJianzhi is %d",isJianzhi);
        
        if (isJianzhi){
            paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.postId,@"cid",@"1",@"type",_cityCode,@"localcity",nil];
        }else
        {
            paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.companyId,@"cid",@"0",@"type",positionModel.cityCode,@"localcity",nil];
        }
        
        _typeItem=CompanyIntro;
        
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
//        [_net request:url param:paramDic andTime:20];
        
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            
            NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"receStr in ReceiveDataFin is %@",receStr);

            if (resultDic) {
                
            }else
            {
                ghostView.message=@"暂无企业信息";
                [ghostView show];
                return;
            }
            if(![resultDic isKindOfClass:[NSDictionary class]]){
                ghostView.message=@"暂无企业信息";
                [ghostView show];
                return;
            }
            _companyDic=[NSMutableDictionary dictionaryWithDictionary:resultDic];
            
            NSLog(@"resultDic in CompanyIntro is %@",resultDic);
            
            introduceView.companyDic=_companyDic;
            
            //如果是兼职的话，可能是空，所以应该进行一下判断
            
            //公司性质
            NSString *natureText=@"";
            
            natureText=[resultDic valueForKey:@"companyNature"];
            
            if ([natureText isEqualToString:@""]) {
                natureText=@"无";
            }
            
            CGSize autoSize = CGSizeMake(iPhone_width-20, MAXFLOAT);
            
            CGSize size = [natureText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
            NSInteger natureHeight=size.height;
            
            
            //所属行业
            NSString *industryText=@"";
            industryText=[resultDic valueForKey:@"companyIndustry"];
            
            if ([industryText isEqualToString:@""]) {
                industryText=@"无";
            }
            
            CGSize autoSize3 = CGSizeMake(iPhone_width, MAXFLOAT);
            CGSize size3 = [industryText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize3 lineBreakMode:NSLineBreakByWordWrapping];
            
            NSInteger industryHeight=size3.height;
            
            //企业简介
            NSString *introductionText=@"";
            
            if ([[resultDic valueForKey:@"companyIntroduction"] isEqualToString:@""]) {
                
                introductionText=@"无";
            }else
            {
                introductionText=[resultDic valueForKey:@"companyIntroduction"];
            }
            
            NSLog(@"introductionText in JobReaderDetailVC is %@",introductionText);
            
            CGSize autoSize2 = CGSizeMake(iPhone_width,MAXFLOAT);
            
            CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:14.4] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
            
            NSInteger introductionHeight=size2.height;
            
            //职位名称
            CustomLabel*companyName = [[CustomLabel alloc]labelinitWithText2:positionModel.companyName X:5 Y:2];
            
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
            
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            
            ghostView.message=@"下载失败";
            [ghostView show];
            
        }];
        [request startAsynchronous];

    }
}

#pragma mark - 其他职位
-(void)otherJobsBtnClick:(id)sender
{
    [self setThrid];
    
    _postItem=PostOther;
    
    rootScrollView.frame = CGRectMake(0,88+num, iPhone_width, iPhone_height - 88);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIButton *btn = (UIButton *)sender;
        [jobDetailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [companyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:XZhiL_colour forState:UIControlStateNormal];
        line.frame = CGRectMake((iPhone_width/3)*2 ,84+num, iPhone_width/3, 4);
        rootScrollView.contentOffset = CGPointMake(iPhone_width*2, 0);
        
    }];
    
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        
        return;
    }
    
    if (!otherView.otherDic) {
        
//        _net=[[NetWorkConnection alloc]init];
//        _net.delegate=self;
        
        NSString *url = kCombineURL(KWWWXZhiLiaoAPI,kWWWNewOtherJobs);
        NSLog(@"positionModel.companyId is %@",positionModel.companyId);
        NSLog(@"positionInfo.workAreaCode is %@",positionModel.cityCode);
        
        NSDictionary *paramDic;
        
        if (isJianzhi) {
            
            otherView.isJianzhi=YES;
            
            paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"role",@"3",IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.cid,@"cid",_cityCode,@"localcity",positionModel.postId,@"pid",nil];
            otherView.cityCodeStr=_cityCode;
            
        }else
        {
            otherView.isJianzhi=NO;
            
            paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:@"role",@"3",IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.cid,@"cid",_cityCode,@"localcity",positionModel.postId,@"pid",nil];
        }
        
        _typeItem=OtherJob;
        
        loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        loadView.userInteractionEnabled = NO;
//        [_net request:url param:paramDic andTime:20];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            
//            NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
//            
//            NSLog(@"receStr in ReceiveDataFin is %@",receStr);
            NSNumber *error_code =[resultDic valueForKey:@"error_code"];

            NSLog(@"resultDic in 其他职位 is %@",resultDic);
            
            if (resultDic) {
                
            }else
            {
                ghostView.message=@"下载失败";
                [ghostView show];
                return;
            }
            NSMutableDictionary * dicss = [NSMutableDictionary dictionaryWithCapacity:0];
            dicss = [resultDic valueForKey:@"data"];
            _otherDic=[NSMutableDictionary dictionaryWithCapacity:0];
            _otherDic = dicss;
            otherView.otherDic= dicss;
            
            NSArray *arr=[dicss valueForKey:@"data"];
            
            if ([arr count]==0) {
                ghostView.message=@"主人，该公司没有其他职位哟";
                [ghostView show];
                return;
            }
            
            for (int i=0;i<[arr count];i++) {
                NSDictionary *dic=[arr objectAtIndex:i];
                HRHomeIntroduceModel *model=[[HRHomeIntroduceModel alloc]initWithDictionary:dic];
                [otherView.dataArray addObject:model];
            }
            
            NSLog(@"otherView.dataArray count is %d",[otherView.dataArray count]);
            
            otherView.myTableView.contentSize=CGSizeMake(iPhone_width,[otherView.dataArray count]*50+50);
            
            UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, otherView.myTableView.frame.size.width, 30)];
            [viewHead setBackgroundColor:[UIColor clearColor]];
            RTLabel *label_rec =  [[RTLabel alloc] initWithFrame:CGRectMake(12,5,iPhone_width - 150,20)];
            [label_rec setBackgroundColor:[UIColor clearColor]];
            label_rec.font = [UIFont systemFontOfSize:14];
            label_rec.backgroundColor = [UIColor clearColor];
            NSString *salaryStr=[NSString stringWithFormat:@"%@：<font color='#f76806'>%@</font> 条",@"其他职位:",[_otherDic valueForKey:@"allCounts"]];
            label_rec.text=salaryStr;
            [viewHead addSubview:label_rec];
            otherView.myTableView.tableHeaderView = viewHead;
            
            [otherView.myTableView reloadData];
            
            [otherView setFooterView];
            
            if ([otherView.dataArray count]!=20) {
                [otherView removeFooterView];
            }
            
            if ([otherView.dataArray count]==0) {
                ghostView.message=@"该企业没有更多职位~";
                [ghostView show];
                
            }
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            
            ghostView.message=@"下载失败";
            [ghostView show];
            
        }];
        [request startAsynchronous];
    }
}

-(void)receiveASIRequestFinish:(NSData *)receData
{
    [loadView hide:YES];
    
    NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:receData options:NSJSONReadingMutableContainers error:nil];
    
    NSString *receStr=[[NSString alloc] initWithData:receData encoding:NSUTF8StringEncoding];
    
    NSLog(@"receStr in ReceiveDataFin is %@",receStr);

    if (_typeItem==CompanyIntro) {//以下数据时其他职位的数据
        
        
        if (resultDic) {
            
        }else
        {
            ghostView.message=@"下载失败";
            [ghostView show];
            return;
        }
        
        _companyDic=[NSMutableDictionary dictionaryWithDictionary:resultDic];
        
        NSLog(@"resultDic in CompanyIntro is %@",resultDic);
        
        introduceView.companyDic=_companyDic;
        
        //如果是兼职的话，可能是空，所以应该进行一下判断
        
        //公司性质
        NSString *natureText=@"";
        
        natureText=[resultDic valueForKey:@"companyNature"];
        
        if ([natureText isEqualToString:@""]) {
            natureText=@"无";
        }
        
        CGSize autoSize = CGSizeMake(iPhone_width-20, MAXFLOAT);
        
        CGSize size = [natureText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
        NSInteger natureHeight=size.height;
        
        
        //所属行业
        NSString *industryText=@"";
        industryText=[resultDic valueForKey:@"companyIndustry"];
        
        if ([industryText isEqualToString:@""]) {
            industryText=@"无";
        }
        
        CGSize autoSize3 = CGSizeMake(iPhone_width, MAXFLOAT);
        CGSize size3 = [industryText sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:autoSize3 lineBreakMode:NSLineBreakByWordWrapping];
        
        NSInteger industryHeight=size3.height;
        
        //企业简介
        NSString *introductionText=@"";
        
        if ([[resultDic valueForKey:@"companyIntroduction"] isEqualToString:@""]) {
            
            introductionText=@"无";
        }else
        {
            introductionText=[resultDic valueForKey:@"companyIntroduction"];
        }
        
        NSLog(@"introductionText in JobReaderDetailVC is %@",introductionText);
        
        CGSize autoSize2 = CGSizeMake(iPhone_width,MAXFLOAT);
        
        CGSize size2 = [introductionText sizeWithFont:[UIFont systemFontOfSize:14.4] constrainedToSize:autoSize2 lineBreakMode:NSLineBreakByWordWrapping];
        
        NSInteger introductionHeight=size2.height;
        
        //职位名称
        CustomLabel*companyName = [[CustomLabel alloc]labelinitWithText2:positionModel.companyName X:5 Y:2];
        
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
        
    }else if (_typeItem==OtherJob)//下面的数据是其他职位的数据
    {
        
        NSLog(@"resultDic in 其他职位 is %@",resultDic);
        
        if (resultDic) {
            
        }else
        {
            ghostView.message=@"下载失败";
            [ghostView show];
            return;
        }
        
        NSMutableDictionary * dicss = [NSMutableDictionary dictionaryWithCapacity:0];
        dicss = [resultDic valueForKey:@"data"];
        _otherDic=[NSMutableDictionary dictionaryWithCapacity:0];
        _otherDic = dicss;
        otherView.otherDic= dicss;
        
        NSArray *arr=[dicss valueForKey:@"data"];
        
        if ([arr count]==0) {
            ghostView.message=@"主人，该公司没有其他职位哟";
            [ghostView show];
            return;
        }
        
        for (int i=0;i<[arr count];i++) {
            NSDictionary *dic=[arr objectAtIndex:i];
            HRHomeIntroduceModel *model=[[HRHomeIntroduceModel alloc]initWithDictionary:dic];
            [otherView.dataArray addObject:model];
        }
        
        NSLog(@"otherView.dataArray count is %d",[otherView.dataArray count]);
        
        otherView.myTableView.contentSize=CGSizeMake(iPhone_width,[otherView.dataArray count]*50+50);
        
        UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, otherView.myTableView.frame.size.width, 30)];
        [viewHead setBackgroundColor:[UIColor clearColor]];
        RTLabel *label_rec =  [[RTLabel alloc] initWithFrame:CGRectMake(12,5,iPhone_width - 150,20)];
        [label_rec setBackgroundColor:[UIColor clearColor]];
        label_rec.font = [UIFont systemFontOfSize:14];
        label_rec.backgroundColor = [UIColor clearColor];
        NSString *salaryStr=[NSString stringWithFormat:@"%@：<font color='#f76806'>%@</font> 条",@"其他职位:",[_otherDic valueForKey:@"allCounts"]];
        label_rec.text=salaryStr;
        [viewHead addSubview:label_rec];
        otherView.myTableView.tableHeaderView = viewHead;
        
        [otherView.myTableView reloadData];
        
        [otherView setFooterView];
        
        if ([otherView.dataArray count]!=20) {
            [otherView removeFooterView];
        }
        
        if ([otherView.dataArray count]==0) {
            ghostView.message=@"该企业没有更多职位~";
            [ghostView show];
            
        }
    }else if (_typeItem==CollectJob)
    {
        
        NSLog(@"此处是收藏的返回值");
        
        NSLog(@"resultDic in JobReaderVC is %@",resultDic);
        
        /*
         1.下载数据之后，如果存在data，则说明是收藏按钮,否则为取消收藏
         2.相应的修改背景颜色
         */
        
        if (resultDic) {
            
        }else
        {
            ghostView.message=@"网络请求失败";
            [ghostView show];
            return;
        }
        
        NSDictionary *dataDic=[resultDic valueForKey:@"data"];
        
        NSString *error=[resultDic valueForKey:@"error"];
        
        if ([[NSString stringWithFormat:@"%@",positionModel.isfavorites] isEqualToString:@"0"]){
            //原来是0，说明未收藏，调用的是收藏接口
            
            if (error&&error.integerValue==0) {
                
                positionModel.isfavorites = @"1";
                [[_dataArray objectAtIndex:_index] setValue:@"1" forKey:@"isfavorites"];
                if ([_delegate_collect respondsToSelector:@selector(afterCollectOperationDoneWithDataArray:)]) {
                    [_delegate_collect afterCollectOperationDoneWithDataArray:_dataArray];
                }
                //收藏成功
                UIButton *btn=(UIButton *)[bottomImage viewWithTag:1024];
                [btn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateNormal];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateHighlighted];
                
                ghostView.message=@"收藏成功";
                [ghostView show];
                positionModel.isfavorites=@"1";
                
            }else
            {
                //收藏失败
                ghostView.message=@"收藏失败";
                [ghostView show];
            }
            
            return;
        }else
        {
            
            //data没数据，是取消收藏接口
            if (error&&error.integerValue==0) {
                positionModel.isfavorites = @"0";

                [[_dataArray objectAtIndex:_index] setValue:@"0" forKey:@"isfavorites"];
                if ([_delegate_collect respondsToSelector:@selector(afterCollectOperationDoneWithDataArray:)]) {
                    [_delegate_collect afterCollectOperationDoneWithDataArray:_dataArray];
                }
                
                //取消收藏成功
                UIButton *btn=(UIButton *)[bottomImage viewWithTag:1024];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"favourite_l.png"] forState:UIControlStateHighlighted];
                
                ghostView.message=@"取消成功";
                [ghostView show];
                positionModel.isfavorites=@"0";
                
            }else
            {
                //取消收藏失败
                ghostView.message=@"取消失败";
                [ghostView show];
            }
            
            return;
        }
    }else if (_typeItem==SiXin)
    {
        NSString * tPlid = [[NSString alloc]initWithData:receData encoding:NSUTF8StringEncoding];
        MessageDetailViewController *collectVC = [[MessageDetailViewController alloc] init];
        collectVC.isFromHr = YES;
        MessageListModel *m = [[MessageListModel alloc] init];
        m.plid = tPlid;
        m.soureId = positionModel.companyId;
        m.name = positionModel.companyName;
        collectVC.postName = positionModel.jobName;
        collectVC.jobId = positionModel.postId;
        collectVC.cityCode = positionModel.cityCode;
        collectVC.message = m;
        [self.navigationController pushViewController:collectVC animated:YES];
        [_sixinBtn setEnabled:YES];
    }
}

-(void)receiveASIRequestFail:(NSError *)error
{
    [loadView hide:YES];
    
    if (_typeItem==CollectJob) {
        
        ghostView.message=@"请检查网络";
        [ghostView show];
        
    }else  if(_typeItem==SiXin)
    {
        [_sixinBtn setEnabled:YES];
        ghostView.message=@"网络请求失败";
        [ghostView show];
    }else
    {
        ghostView.message=@"下载失败";
        [ghostView show];
    }
}

#pragma mark 屏幕下方按钮点击的方法实现

-(void)introView_backClick{
    introView_back.hidden = YES;
}

-(void)introView_2_backClick{
    introView_back_2.hidden = YES;
}

//上一条
-(void)lastBtnClick:(id)sender
{
    if (_index==0) {
        ghostView.message=@"已到第一条";
        [ghostView show];
        return;
    }
    
    --_index;
    
    positionModel=[_dataArray objectAtIndex:_index];
    
    positionModel.isRead=@"1";
    [self addTitleLabel:positionModel.companyName];
    
    
    if (positionModel.isfavorites.integerValue==0) {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favourite_l.png"] forState:UIControlStateHighlighted];
    }else
    {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateNormal];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateHighlighted];
    }
    
    [detailView removeFromSuperview];
    _jobScrollView.contentOffset= CGPointMake(0,0);
    detailView=[[HR_JobDetailView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200) WithJobDetail:positionModel];
    detailView.delegate=self;
    [_jobScrollView addSubview:detailView];
    
    [introduceView removeFromSuperview];
    _companyScrollView.contentOffset=CGPointMake(0,0);
    introduceView=[[HR_CompanyIntroView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200) withModel:positionModel];
    [_companyScrollView addSubview:introduceView];
    
    [otherView removeFromSuperview];
    
    otherView=[[HR_OtherJobListView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200) withModel:positionModel];
    
    [self resetJobScrollView];
}

//下一条
-(void)nextBtnClick:(id)sender
{
    if (_index==[_dataArray count]-1) {
        ghostView.message=@"已到最后一条";
        [ghostView show];
        return;
    }
    
    ++_index;
    
    positionModel=[_dataArray objectAtIndex:_index];
    positionModel.isRead=@"1";
    
    [self addTitleLabel:positionModel.companyName];
    
    if (positionModel.isfavorites.integerValue==0) {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favourite_l.png"] forState:UIControlStateHighlighted];
    }else
    {
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateNormal];
        [_collectionBtn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateHighlighted];
    }
    
    [detailView removeFromSuperview];
    _jobScrollView.contentOffset= CGPointMake(0,0);
    detailView=[[HR_JobDetailView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200) WithJobDetail:positionModel];
    detailView.delegate=self;
    [_jobScrollView addSubview:detailView];
    
    [introduceView removeFromSuperview];
    _companyScrollView.contentOffset=CGPointMake(0,0);
    introduceView=[[HR_CompanyIntroView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200) withModel:positionModel];
    [_companyScrollView addSubview:introduceView];
    
    
    [otherView removeFromSuperview];
    otherView=[[HR_OtherJobListView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, 200) withModel:positionModel];
    
    [self resetJobScrollView];
}

//明细按钮
-(void)mingxiBtnClick:(id)sender
{
    myButton *btn=(myButton *)sender;
    
    btn.isClicked=!btn.isClicked;
    
    UIImageView *imageView=(UIImageView *)[btn viewWithTag:101];
    
    if(btn.isClicked==YES)
    {
        imageView.image=[UIImage imageNamed:@"mingxi2.png"];
    }else
    {
        imageView.image=[UIImage imageNamed:@"mingxi.png"];
    }
    
    NSLog(@"明细按钮被点击了。。。。。");
    
    otherView.detail=!otherView.detail;
    [otherView.myTableView reloadData];
    [otherView setFooterView];
}

//收藏按钮
- (void)collectionBtnClick:(id)sender
{
    NSLog(@"收藏按钮被点击了。。。");
    /*
     1.点击收藏按钮之后将数据传给服务器，分为收藏和取消收藏
     2.按钮会换成和之前不同的颜色
     */
    
    _typeItem=CollectJob;
    
    _net=[[NetWorkConnection alloc]init];
    
    _net.delegate=self;
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (positionModel.isfavorites&&positionModel.isfavorites.integerValue==1) {  //当前职位已经收藏了
        
        //取消收藏接口
        NSString *url = kCombineURL(KXZhiLiaoAPI,HRCollectPosition);
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.postId,@"jobId",positionModel.cityCode,@"localcity",@"del",@"flag",nil];
        
//        [_net request:url param:paramDic andTime:10];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            
            NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"receStr in ReceiveDataFin is %@",receStr);

            NSLog(@"此处是取消收藏的返回值");
            
            NSLog(@"resultDic in JobReaderVC is %@",resultDic);
            
            /*
             1.下载数据之后，如果存在data，则说明是收藏按钮,否则为取消收藏
             2.相应的修改背景颜色
             */
            
            if (resultDic) {
                
            }else
            {
                ghostView.message=@"网络请求失败";
                [ghostView show];
                return;
            }
            
            NSDictionary *dataDic=[resultDic valueForKey:@"data"];
            
            NSString *errorStr=[resultDic valueForKey:@"error"];
            
            //data没数据，是取消收藏接口
            if (errorStr&&errorStr.integerValue==0) {
                positionModel.isfavorites = @"0";
                
                [[_dataArray objectAtIndex:_index] setValue:@"0" forKey:@"isfavorites"];
                if ([_delegate_collect respondsToSelector:@selector(afterCollectOperationDoneWithDataArray:)]) {
                    [_delegate_collect afterCollectOperationDoneWithDataArray:_dataArray];
                }
                
                //取消收藏成功
                UIButton *btn=(UIButton *)[bottomImage viewWithTag:1024];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"favourite_n.png"] forState:UIControlStateNormal];
                
                [btn setBackgroundImage:[UIImage imageNamed:@"favourite_l.png"] forState:UIControlStateHighlighted];
                
                ghostView.message=@"取消成功";
                [ghostView show];
                positionModel.isfavorites=@"0";
                
            }else
            {
                //取消收藏失败
                ghostView.message=@"取消失败";
                [ghostView show];
            }
            
            return;

        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            
            ghostView.message=@"请检查网络";
            [ghostView show];
            
        }];
        [request startAsynchronous];
    }else
    {
        //当前职位没有被收藏
        /*
         1.调用收藏接口
         */
        NSString *url = kCombineURL(KXZhiLiaoAPI,HRCollectPosition);
        NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.postId,@"jobId",positionModel.cityCode,@"localcity",@"",@"flag",nil];
//        [_net request:url param:paramDic andTime:10];
        NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
        [request setCompletionBlock:^{
            
            [loadView hide:YES];
            
            NSError *error;
            
            NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
            
            NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
            
            NSLog(@"receStr in ReceiveDataFin is %@",receStr);
            
            NSLog(@"此处是收藏的返回值");
            
            NSLog(@"resultDic in JobReaderVC is %@",resultDic);
            
            /*
             1.下载数据之后，如果存在data，则说明是收藏按钮,否则为取消收藏
             2.相应的修改背景颜色
             */
            
            if (resultDic) {
                
            }else
            {
                ghostView.message=@"网络请求失败";
                [ghostView show];
                return;
            }
            
            NSDictionary *dataDic=[resultDic valueForKey:@"data"];
            
            NSString *errorStr=[resultDic valueForKey:@"error"];
            
            if ([[NSString stringWithFormat:@"%@",positionModel.isfavorites] isEqualToString:@"0"]){
                //原来是0，说明未收藏，调用的是收藏接口
                
                if (errorStr&&errorStr.integerValue==0) {
                    
                    positionModel.isfavorites = @"1";
                    [[_dataArray objectAtIndex:_index] setValue:@"1" forKey:@"isfavorites"];
                    if ([_delegate_collect respondsToSelector:@selector(afterCollectOperationDoneWithDataArray:)]) {
                        [_delegate_collect afterCollectOperationDoneWithDataArray:_dataArray];
                    }
                    //收藏成功
                    UIButton *btn=(UIButton *)[bottomImage viewWithTag:1024];
                    [btn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateNormal];
                    
                    [btn setBackgroundImage:[UIImage imageNamed:@"favorite_sou.png"] forState:UIControlStateHighlighted];
                    
                    ghostView.message=@"收藏成功";
                    [ghostView show];
                    positionModel.isfavorites=@"1";
                    
                }else
                {
                    //收藏失败
                    ghostView.message=@"收藏失败";
                    [ghostView show];
                }
                
                return;
            }
            
        }];
        [request setFailedBlock:^{
            [loadView hide:YES];
            
            ghostView.message=@"请检查网络";
            [ghostView show];
            
        }];
        [request startAsynchronous];
    }
}

//投递
-(void)postBtnClick:(id)sender
{
    NSLog(@"推荐按钮被点击233333");
    NSUserDefaults * AppUD=[NSUserDefaults standardUserDefaults];
    
    NSString *hr_company_id = [AppUD valueForKey:@"company_pid"];
    if (hr_company_id) {
        if ([hr_company_id isEqualToString:positionModel.companyId]) {
            ghostView.message=@"您不能给自己的东家推荐人才哦~";
            [ghostView show];
            return;
        }
    }
    
    HR_ResumeRecommendListViewController *hr_ResumeRec = [[HR_ResumeRecommendListViewController alloc] init];
    hr_ResumeRec.model_job = positionModel;
    //        [self.navigationController pushViewController:hr_resume animated:YES];
    [self.navigationController pushViewController:hr_ResumeRec animated:YES];

}



//私信
-(void)sixinBtnClick:(id)sender
{
    [_sixinBtn setEnabled:NO];
    NSLog(@"私信按钮被点击了。。。。。");
    _typeItem=SiXin;
//    _net=[[NetWorkConnection alloc]init];
//    _net.delegate=self;
    NSDictionary *paramDic = [[NSDictionary alloc]initWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",positionModel.companyId,@"companyId",nil];
    NSString *url = kCombineURL(KXZhiLiaoAPI,kGetPlidWithCompanyId);
//    [_net request:url param:paramDic andTime:20];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *receStr=[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
        
        NSLog(@"receStr in ReceiveDataFin is %@",receStr);
        
        NSString * tPlid = [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
        MessageDetailViewController *collectVC = [[MessageDetailViewController alloc] init];
        collectVC.isFromHr = YES;
        MessageListModel *m = [[MessageListModel alloc] init];
        m.plid = tPlid;
        m.soureId = positionModel.companyId;
        m.name = positionModel.companyName;
        collectVC.postName = positionModel.jobName;
        collectVC.jobId = positionModel.postId;
        collectVC.cityCode = positionModel.cityCode;
        collectVC.message = m;
        [self.navigationController pushViewController:collectVC animated:YES];
        [_sixinBtn setEnabled:YES];

        
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        [_sixinBtn setEnabled:YES];
        ghostView.message=@"网络请求失败";
        [ghostView show];
        
    }];
    [request startAsynchronous];
}

//电话
-(void)telephoneBtnClick:(id)sender
{
    NSLog(@"电话按钮被点击了。。。");
    [self telephone:positionModel.companyTel];
}

#pragma mark 添加标题
-(void)addTitleLabel:(NSString*)title{
    NSLog(@"title in JobSeeVC  and addTitleLabel is %@",title);
    titleLabelx.text=title;
    titleLabely.text=title;
}

#pragma mark JobDetailView的代理方法
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

-(void)toBecomeEVIP{

    HR_ToBecomeVipViewController *web = [[HR_ToBecomeVipViewController alloc] init];
//    web.urlStr = [NSString stringWithFormat:@"http://api.xzhiliao.com/hr_api/buy/company_v? userToken=%@&userImei=%@",kUserTokenStr,IMEI];
//    web.floog = @"成为会员";
    web.salary = positionModel.salary;
    [self.navigationController pushViewController:web animated:YES];
}

//-(void)showResumeIntroInfo{
//    
//    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    loadView.userInteractionEnabled=NO;
//    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRShowResumeIntroInfo);
//    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",nil];
//    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
//    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:URL];
//    [request setCompletionBlock:^{
//        [loadView hide:YES];
//        NSError *error;
//        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
//        NSString *errorStr =[resultDic valueForKey:@"error"];
//        if(!resultDic){
//            HRLogin *vc = [HRLogin new];
//            vc.backType = @"BackPersonalVC";
//            [self.navigationController pushViewController:vc animated:YES];
//            return ;
//        }
//        if(errorStr.integerValue == 200){
//            NSLog(@"获取成功");
//            //TODO 修改列表查看数
//            
//            NSString *textA = [resultDic valueForKey:@"text_A"];
//            NSString *textB = [resultDic valueForKey:@"text_B"];
//            NSString *textC = [resultDic valueForKey:@"text_C"];
//            NSString *strA = [resultDic valueForKey:@"lastRecharge"];
//            NSString *strB = [resultDic valueForKey:@"bonusPercent"];
//            NSArray *arrayA = [strA componentsSeparatedByString:@","];
//            NSArray *arrayB = [strB componentsSeparatedByString:@","];
//            for (int i = 0; i<arrayA.count; i++) {
//                UILabel *labelA = [[UILabel alloc] initWithFrame:CGRectMake(0, 25*i, introView_list_back.frame.size.width-100, 25)];
//                [labelA setText:[arrayA objectAtIndex:i]];
//                [labelA setFont:[UIFont systemFontOfSize:13]];
//                [labelA setTextAlignment:NSTextAlignmentCenter];
//                UILabel *labelB = [[UILabel alloc] initWithFrame:CGRectMake(introView_list_back.frame.size.width-100, 25*i, 100, 25)];
//                [labelB setText:[arrayB objectAtIndex:i]];
//                [labelB setFont:[UIFont systemFontOfSize:13]];
//                [labelB setTextColor:XZhiL_colour];
//                [labelB setTextAlignment:NSTextAlignmentCenter];
//                [introView_list_back addSubview:labelA];
//                [introView_list_back addSubview:labelB];
//                
//            }
//            label_intro_A.text = textA;
//            [label_intro_A sizeToFit];
//            [introView_line setFrame:CGRectMake(20, label_intro_A.frame.origin.y+label_intro_A.frame.size.height +10, introView.frame.size.width-40, 1)];
//            
//            btn_last_title.frame = CGRectMake(20, introView_line.frame.origin.y + 10 +1, btn_last_title.frame.size.width, btn_last_title.frame.size.height);
//            btn_rate_title.frame = CGRectMake(btn_rate_title.frame.origin.x, introView_line.frame.origin.y + 10 +1, btn_rate_title.frame.size.width, btn_rate_title.frame.size.height);
//            introView_list_back.frame = CGRectMake(introView_list_back.frame.origin.x, btn_last_title.frame.origin.y+btn_last_title.frame.size.height, introView_list_back.frame.size.width, introView_list_back.frame.size.height);
//            
//            [label_intro_B setFrame:CGRectMake(label_intro_B.frame.origin.x, introView_list_back.frame.origin.y + introView_list_back.frame.size.height+10 , introView.frame.size.width-40, 100)];
//            label_intro_B.text = textB;
//            [label_intro_B sizeToFit];
//            
//            [label_intro_C setFrame:CGRectMake(label_intro_C.frame.origin.x, label_intro_B.frame.origin.y + label_intro_B.frame.size.height+10 , introView.frame.size.width-40, 100)];
//            label_intro_C.text = textC;
//            [label_intro_C sizeToFit];
//            
//            imagePointB.frame = CGRectMake(20, label_intro_B.frame.origin.y+5, 4, 4);
//            imagePointC.frame = CGRectMake(20, label_intro_C.frame.origin.y+5, 4, 4);
//            
//            [introView setFrame:CGRectMake(introView.frame.origin.x, introView.frame.origin.y, introView.frame.size.width,30*2+ 10*4 + label_intro_A.frame.size.height + label_intro_B.frame.size.height+label_intro_C.frame.size.height+introView_list_back.frame.size.height +btn_last_title.frame.size.height +1)];
//            introView.center = introView_back.center;
//            if ([self.view.subviews containsObject:introView_back]) {
//                introView_back.hidden = NO;
//            }else{
//                [self.view addSubview:introView_back];
//            }
//            
//            
//            
//        }
//        
//    }];
//    [request setFailedBlock:^{
//        [loadView hide:YES];
//        
//    }];
//    [request startAsynchronous];
//}

-(void)showResumeIntroInfo{
    
    introView.center = introView_back.center;
    if ([self.view.subviews containsObject:introView_back]) {
        introView_back.hidden = NO;
    }else{
        [self.view addSubview:introView_back];
    }
}

-(void)showRuzhiIntroInfo{
    
    introView_2.center = introView_back_2.center;
    if ([self.view.subviews containsObject:introView_back_2]) {
        introView_back_2.hidden = NO;
    }else{
        [self.view addSubview:introView_back_2];
    }
}


//地址搜索
-(void)address:(NSString *)addressStr
{
    NSLog(@"地址搜索的代理执行到了 is %@",addressStr);
    BaiduMapViewController *mapVC = [[BaiduMapViewController alloc] init];
    mapVC.address = addressStr;
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark OtherJobTableView代理方法
- (void)checkOtherJob:(NSMutableArray *)otherArray otherIndex:(NSInteger)index  AndJianzhi:(BOOL)jianzhi
{
    NSLog(@"jianzhi in checkOtherJob is %d",jianzhi);
    
    HR_JobDetailVC * jobDetailVC = [[HR_JobDetailVC alloc] init];
    jobDetailVC.dataArray=otherArray;
    jobDetailVC.index=index;
    jobDetailVC.isJianzhi=jianzhi;
    
    if (isJianzhi) {
        jobDetailVC.tag=4;
    }
    
    jobDetailVC.cityCode=_cityCode;
    
    [self.navigationController pushViewController:jobDetailVC animated:YES];
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

- (NSString *)messageContent
{
    ResumeOperation *resume = [ResumeOperation defaultResume];
    
    NSString *resumeId = [resume.resumeDictionary valueForKey:@"jlBianhao"];
    NSString *pn = [[NSUserDefaults standardUserDefaults] valueForKey:@"personName"];
    NSString *wy = [resume.resumeDictionary valueForKey:@"myWorkYear"];
    NSString *tel = [resume.resumeDictionary valueForKey:@"myTel"];
    NSString *infoString = [NSString stringWithFormat:@"您好，我是%@，应聘：%@",pn,positionModel.jobName];
    
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


//内部调用短信代理
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"取消");
            break;
        case MessageComposeResultSent:
            
            
            ghostView.message = @"短信发送成功!";
            [ghostView show];
            break;
        case MessageComposeResultFailed:
            ghostView.message = @"短信发送失败!";
            [ghostView show];
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/****************************微信分享*******************************/
- (void)sendTextContent:(NSString *)nsText
{
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.text = nsText;
        req.scene = _scene;
        [WXApi sendReq:req];
    }else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的职位分享给好友。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
        alView.tag = 1001;
        [alView show];
    }
}
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        
    }
    
}

-(void) changeScene:(NSInteger)scene{
    _scene = scene;
}


#pragma mark 返回按钮
- (void)backUp:(id)sender
{
    [self.delegate jobReaderDetailVC];
    
    NSLog(@"backUp被执行。。。。。");
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark 设置底部按钮的alpha值

-(void)setFirst
{
    if (_tag!=4){   //如果不是兼职
        
        _mingxiBtn.alpha=0;
        _telephoneBtn.alpha=0;
        
        _lastBtn.alpha=1;
        _nextBtn.alpha=1;
        _collectionBtn.alpha=1;
        _sixinBtn.alpha=1;
        _postBtn.alpha=1;
        
        _numberBtn.alpha = 0;
        
        _lastBtn.frame=CGRectMake(0,2, iPhone_width/5, 45);
        _nextBtn.frame=CGRectMake(iPhone_width*4/5 ,2, iPhone_width/5, 45);
        _postBtn.frame= CGRectMake(iPhone_width*2/5,2, iPhone_width/5, 45);
        _collectionBtn.frame=CGRectMake(iPhone_width/5,2, iPhone_width/5, 45);
        _sixinBtn.frame=CGRectMake(iPhone_width*3/5,2, iPhone_width/5, 45);
        
    }else
    {
        _lastBtn.alpha=1;
        _nextBtn.alpha=1;
        _telephoneBtn.alpha=1;
        
        _mingxiBtn.alpha=0;
        _postBtn.alpha=0;
        _sixinBtn.alpha=0;
        _collectionBtn.alpha=0;
        
        _lastBtn.frame=CGRectMake(0,2, iPhone_width/5, 45);
        _nextBtn.frame=CGRectMake(256 ,2, iPhone_width/5, 45);
        _telephoneBtn.frame= CGRectMake(128,2, iPhone_width/5, 45);
        
    }
}

-(void)setSecond
{
    if (_tag!=4) {
        
        _postBtn.alpha=1;
        _sixinBtn.alpha=1;
        
        _nextBtn.alpha=0;
        _lastBtn.alpha=0;
        _collectionBtn.alpha=0;
        _mingxiBtn.alpha=0;
        _telephoneBtn.alpha=0;
        _numberBtn.alpha = 0;
        _postBtn.frame=CGRectMake(64,2,iPhone_width/5,45);
        _sixinBtn.frame=CGRectMake(192,2,iPhone_width/5,45);
        
    }else
    {
        
        _nextBtn.alpha=0;
        _lastBtn.alpha=0;
        _postBtn.alpha=0;
        _collectionBtn.alpha=0;
        _mingxiBtn.alpha=0;
        _telephoneBtn.alpha=1;
        _telephoneBtn.frame=CGRectMake(128,2,iPhone_width/5,45);
    }
}

-(void)setThrid
{
    if (_tag!=4) {
        
        
        _nextBtn.alpha=0;
        _collectionBtn.alpha=0;
        _postBtn.alpha=0;
        _sixinBtn.alpha=1;
        _lastBtn.alpha=0;
        _mingxiBtn.alpha=1;
        _telephoneBtn.alpha=0;
        
        if ([otherView.selectArray count]!=0) {
            _numberBtn.alpha=1;
        }else
        {
            _numberBtn.alpha=0;
        }
        
        _mingxiBtn.frame=CGRectMake(64,2, iPhone_width/5, 45);
//        _postBtn.frame=CGRectMake(128,2,iPhone_width/5,45);
        _sixinBtn.frame=CGRectMake(192 ,2, iPhone_width/5, 45);
        
    }else
    {
        _nextBtn.alpha=0;
        _lastBtn.alpha=0;
        _postBtn.alpha=0;
        _sixinBtn.alpha=0;
        _collectionBtn.alpha=0;
        
        _mingxiBtn.alpha=1;
        _telephoneBtn.alpha=0;
        _mingxiBtn.frame=CGRectMake(128,2, iPhone_width/5, 45);
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


//设置职位信息
-(void)setPositionChoice
{
    if ([otherView.selectArray count]!=0) {
        [otherView.selectArray removeAllObjects];
        [otherView.myTableView reloadData];
        [_numberBtn setTitle:@"" forState:UIControlStateNormal];
        _numberBtn .alpha=0;
    }else
    {
        [otherView.myTableView reloadData];
        [_numberBtn setTitle:@"" forState:UIControlStateNormal];
        _numberBtn.alpha=0;
    }
}

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
