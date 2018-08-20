//
//  HR_JobDetailVC.h
//  JobKnow
//
//  Created by Suny on 15/8/10.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "HR_OtherJobListView.h"
#import "UIMenuBar.h"
#import "SinaWeibo.h"
#import "WBShareKit.h"
#import "SinaWeiboRequest.h"
#import "TipView.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "JobDetailInfo.h"
#import "HR_CompanyIntroView.h"
#import "JobReaderDetailViewController.h"

#import "HRHomeIntroduceModel.h"
#import "HR_JobDetailView.h"

#import "HR_ResumeRecommendListViewController.h"
#import "HR_CompanyVipViewController.h"
#import "HR_ToBecomeVipViewController.h"


@class AppDelegate;

/*
 RequestOption主要有3种不同的请求方式
 1.公司信息接口
 2.其他职位信息
 3.职位收藏
 */

//typedef enum TypeOption
//{
//    CompanyIntro,//企业简介
//    OtherJob,
//    CollectJob,     //收藏
//    SiXin
//}TypeItem;
//
//typedef enum PostOption
//{
//    PostOne,
//    PostOther
//}PostItem;          //投递类型

@protocol HR_JobDetailVCDelegate
@optional
-(void)jobReaderDetailVC;

@end

@protocol HR_JobDetailVCCollectDelegate<NSObject>
@optional

-(void)afterCollectOperationDoneWithDataArray:(NSMutableArray *)array;//详细页面收藏操作执行后 修改列表页数据

@end

@interface HR_JobDetailVC : BaseViewController <SendRequest,HR_OtherJobListViewDelegate,HR_JobDetailViewDelegate,UIMenuBarDelegate,UIScrollViewDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate>
{
    enum WXScene _scene;
    
    NSInteger num;
    
    NSString *telStr; //电话号码数量为1的时候，截取
    
    NSString *telStr01; //电话号码数量为2的时候，截取
    NSString *telStr02;
    
    NSString *title01;//电话号码是3的时候，截取
    NSString *title02;
    NSString *title03;
    
    HRHomeIntroduceModel *positionModel;
    
    UILabel *titleLabelx;
    UILabel *titleLabely;
    
    UIImageView *line;
    UIView *bottomImage;
    
    UIButton *jobDetailBtn;
    UIButton *companyBtn;
    UIButton *otherBtn;
    
    UIScrollView *rootScrollView;
    
    MBProgressHUD *loadView;
    OLGhostAlertView *ghostView;
    
    HR_JobDetailView *detailView;
    HR_CompanyIntroView *introduceView;
    HR_OtherJobListView *otherView;
    
//    分享按钮
    UIButton *shareBtn;
    
    NSString *shareLink;
    
    NSDictionary *shareDic;
    
    UIView * introView_back;
    UIView * introView;
    UILabel *label_intro_A;
    UILabel *label_intro_B;
    UILabel *label_intro_C;
    UIImageView *imagePointB;
    UIImageView *imagePointC;
    UIView * introView_line;
    UIButton *btn_last_title;
    UIButton *btn_rate_title;
    UIImageView * introView_list_back;
    
    UIView * introView_back_2;
    UIView * introView_2;
    UILabel *label_intro_A_1;
    UILabel *label_intro_A_2;
    UILabel *label_intro_B_2;
    UILabel * label_intro_B_3;
    UILabel *label_intro_C_1;
    UILabel *label_intro_C_2;
    
    
    
    UIImageView *imagePointA_2;
    UIImageView *imagePointB_2;
    UIImageView *imagePointB_3;
    UIImageView *imagePointC_1;
    UIImageView *imagePointC_2;
    UIView * introView_line_2;
}

@property(nonatomic,assign)PostItem postItem;      //投递类型

@property(nonatomic,assign)TypeItem typeItem;       //不同的网络请求类型

@property(nonatomic,assign)BOOL isJianzhi;//也是判断是否是兼职

@property(nonatomic,strong)NSString *cityCode;

@property(nonatomic,assign)NSInteger tag;//用来判断是不是兼职

@property(nonatomic,assign)NSInteger index;//index表示数据源中索引

@property(nonatomic,strong)NSMutableArray *dataArray;//数据源

@property(nonatomic,strong)NSDictionary *otherDic;//其他职位中的数据源

@property(nonatomic,strong)NSMutableDictionary *companyDic;//企业简介中的数据源

@property(nonatomic,strong)UIMenuBar *bar;//发邮箱的时候用到

@property(nonatomic,strong)NSString *position_id;//jobid,私信中使用到

@property(nonatomic,strong)UIScrollView *jobScrollView;//职位详情

@property(nonatomic,strong)UIScrollView *companyScrollView;//公司简介

@property(nonatomic,strong)UIButton *lastBtn;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UIButton *collectionBtn;
@property(nonatomic,strong)UIButton *sixinBtn;
@property(nonatomic,strong)UIButton *postBtn;
@property(nonatomic,strong)UIButton *telephoneBtn;
@property(nonatomic,strong)myButton *mingxiBtn;
@property(nonatomic,strong)UIButton *numberBtn;

@property(nonatomic,strong)NetWorkConnection *net;
@property(nonatomic,assign)id<HR_JobDetailVCDelegate>delegate;

@property(nonatomic,assign)id<HR_JobDetailVCCollectDelegate>delegate_collect;

-(void)resetJobScrollView;

@end
