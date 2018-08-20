//
//  Config.h
//  JobsGather
//
//  Created by faxin sun on 13-1-16.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

@interface Config

#define HRResumeReview @"api/hr_api/recommend_jianli/hrview?"//简历预览接口

//*********************兼职猎手圈接口***************************//
#define PTJHRegister @"hr_api/hrmanage/partTimeHrRegister?" //兼职猎手注册
//*********************兼职猎手圈接口***************************//
//********************功能接口***************************//
#define URLHideForCheck @"common/ios_app_store/personal?"//是否阉割
#define FuncGetAllDialogStates @"common/dialog/all_status?"//获取用户所有的dialog状态
#define FuncUpDialogStates @"common/dialog/up_status?"//更改用户某个dialog状态
#define FuncPersonalResumeScanLogin @":3000/login?"//个人简历PC端登陆


#pragma mark - 入职奖金接口
#define SeniorCWHHR @"http://api.xzhiliao.com/adminapi/user/company_v"//成为小职了人才合伙人
#define SeniorJobList @"api/new_api/job/senior_job_list?"
#define SeniorJobCityList @"new_api/user/senior_city_list"
#define SeniorMyBillApplyList @"new_api/senior/bill_list?"
#define SeniorJobDetail  @"new_api/senior/job_detail?"//职位详情
#define SeniorMyBillDetail @"new_api/senior/bill_status_list?"//申请详情

#pragma mark - 接口
//*********************HR圈接口***************************//
#define HRGetBannerData @"common/page_secret/getBannerData?"//获取广告位数据
#define HRUpIP @"hr_api/hr_operation/up_ip?"//记录IP

#define PCResumeTutor @"common/page_secret/resume_manage_tutorial?" //PC简历教程
#define BootDownloadCompany @"common/page_secret/boot_download_company?" //引导下载企业版

#define HRRegister @"hr_api/hrmanage/hrRegister?" //HR注册
#define HRIsRegister @"hr_api/hrmanage/isRegister?"//验证账号是否可注册

#define HRResumeList @"api/getResumeList?"//简历列表3.3.1 简历库
#define HRResumePriceList @"hr_api/hr_resume/price_list?"//简历价格列表
#define HRResumeSetResumePrice @"hr_api/hr_resume/set_price?"//设置简历价格
#define HRInvite @"hr_api/invite/family?"//邀请家族（我的人才经纪人家族）
#define HRPositonList @"api/hr_api/job/senior_job_list?"//HR主页
#define Test_HRPositonList @"/hr_api/job/senior_job_list_ios?"//招聘职位列表（测试用 勿用）
#define HRCreateResume @"hr_api/hr_resume/createResume?"//添加简历
#define HRResumeInfo @"/hr_api/hr_resume/getResumeInfo?"//简历详细信息
#define HREditResume @"hr_api/hr_resume/edit?"//修改简历
#define HRDeleteResume @"hr_api/hr_resume/delResume?"//删除简历
#define HREditResumeText @"hr_api/hr_resume/perfectInfo?"//修改简历文本
#define HRResumeAttachDelete @"hr_api/attach/attach_del" //删除简历附件
#define HRJobCollection @"hr_api/job/job_fav_list?"//职位收藏
#define HRResumeRecommend @"api/hr_api/recommend/deliver?"//简历推荐 3.3.1
#define HRJobDetail  @"hr_api/job/job_view?"//职位详情
#define HRShowResumeIntroInfo  @"common/tips/job_dialog_B?"//职位详情页中奖金点击
#define HRRecommendList @"api/job/recommend/show?"//推荐记录列表
#define HRRecommendState @"hr_api/recommend/recommendState?"//推荐状态
#define HRRecommendDynamicList @"hr_api/recommend/getDynamicList?"//推荐动态数据
#define HRRewardList @"hr_api/money/getMoneyList?" //我的奖金列表
#define HRBonusWallet @"common/page_secret/bonus_wallet?" //人才经济人家族（奖金web）
#define HRBonusBarData @"hr_api/money/count_bonus_bar?" //奖金条
#define HRResumeRecRewardList @"hr_api/money/getResumeMoneyList?" //我的简历推荐奖金列表 
#define HRRecommendApplyCash @"hr_api/money/applyMoney?" //推荐奖金申请提现
#define HRInviteApplyCash @"hr_api/invite/apply_cash?"//邀请奖金申请提现//已废弃
#define HRApplyCash @"hr_api/invite/apply_cash?"//奖金申请提现//（2.8.5提现统一调这个接口）
#define HRInviteCashList @"hr_api/invite/cash_list?"//邀请奖金提现记录
#define HRCollectPosition @"hr_api/job/job_fav?"//收藏/取消收藏 按钮接口
#define HRMyCardInfoMation @"hr_api/self_operation/getHrInfo?"//获取HR信息
#define HRAgentBonus @"common/page_all/agent_bonus"//代理奖金页
#define HRMyRewardWeb @"api/bonus/list/show?"//HR奖金web新界面

#define HRMyRecommendedRecordWeb @"api/job/recommend/show?"//HR推荐记录web新界面

#define HRChangeMyCard @"hr_api/hr_operation/renewCardInfo?"//修改我的名片

#define HRCommenQuestion @"hr_api/hrmanage/getQuestion?"//注销个人信息
#define SharePosition @"common/share/job?"//分享职位 u_type:1HR 2个人

//*********************HR圈接口***************************//


//#define kIosToken @"api/get_mod/get_iostoken?"
//*********************接口***************************//

#define  kGetStuInfo @"new_api/loginuser/student_info?"
#define kSaveStuInfo @"new_api/loginuser/save_student_info?"

/**********用户登录接口***********/
#define kNewUserLogin @"new_api/user/newlogin?"//用户登录
#define kNewIsRegister @"new_api/user/is_register?"//用户是否已经注册或者是是否注册超过两个
#define kNewUserRegister @"new_api/user/new_register?"//用户注册
#define kNewFindPassWord @"new_api/user/find_pass?"//找回密码

#define kNewPush @"new_api/loginuser/get_push?"  //得到推送字符串
#define kNewGetNew @"new_api/get/get_new?"

/************订阅************/
#define kBookerCreat @"new_api/booker?"
#define kBookerShow @"new_api/booker/booker_show?"
#define kEnterpriseShow @"new_api/loginuser/company_search?"

#define kJobSearch @"new_api/job/job_search?"
//取消公司订阅
#define kCancelReadCompany @"new_api/booker/booker_del?"


/************职位查看（新）************/
//职位列表查看
#define kNewPositionList @"new_api/job/job_list?"
#define kNewCompanyDetail @"new_api/company/company_show?"
#define kNewOtherJobs @"new_api/company/company_job?"

#define kWWWNewOtherJobs @"api/company_job?"
//收藏
#define kNewFavouriteJobListShow @"new_api/job/job_fav_list?"
#define kNewFavouriteJob @"new_api/job/job_fav1?"
//投递
#define  kNewJobDeliver @"new_api/deliver/deliver_new?"

/************职位查看（新）************/

#define kIosToken @"new_api/loginuser/get_ios_token?"
#define kAuthID @"authorization"
#define LocaCity @"localcity"

//用户信息15863215847
#define kUserShow @"api/usr_show?"//已废弃
// 用户信息完善
#define kUserInfoFinish @"api/usr_set?"//已废弃
//修改密码
#define kModifyPassWord @"api/modify_pass?"//已废弃

//意见反馈
#define kFeedBack @"api/setfeedback?"//已废弃
//获取邀请人
#define kInviteShow @"new_api/loginuser/usr_show?"
//更新邀请码
#define kInviteSet @"new_api/loginuser/usr_set?"

#define kAddCount @"api/index_load?"//已废弃

//应用推荐
#define KIntroduce @"api/tuijian?"
#define KIntroduceClick @"tuijian/click?"

//小职了正式站IP地址
//#define KXZhiLiaoAPI  @"http://122.4.79.213/"
//小职了正式站
#define KXZhiLiaoAPI  @"http://api.xzhiliao.com/"
#define KXZhiLiaoAPI  @"http://api.xzhiliao.com/"
#define KXZhiLiaoAPINo @"http://api.xzhiliao.com"

#define kGRApi @"http://api.xzhiliao.com"

#define KWWWXZhiLiaoAPI  @"http://www.xzhiliao.com/"

#define KAPPAPI  @"https://appapi.xzhiliao.com"

//#define kTestAPPAPIGR @"http://test.appapi.xzhiliao.com"

#define kTestAPPAPIGR KAPPAPI

#define kTestToken [XZLUserInfoTool getToken]

#define kTokenResume [XZLUserInfoTool getToken]
//小职了测试站
//#define KXZhiLiaoAPI  @"http://103.254.76.61/"
//#define KXZhiLiaoAPI  @"http://103.254.76.61/"
//#define KXZhiLiaoAPINo @"http://103.254.76.61"




//获取小职了最新版本信息及审核信息
#define kAppCheck @"/api/version/personnel/latest"

#define kUpdateFile @"http://timages.hrbanlv.com/pm2/upload"
//********************订阅

#define kUpdateFileZXB @"http://timages.hrbanlv.com/uploadimg/upload"

//********************邀请
#define kInviteNumber @"new_api/invite/my_invition?"
#define kInvitePerson @"new_api/invite/invition_list?"
#define kSaveInviteNumber @"new_api/send/send_Invitation_code?"

//********************职位和公司接口
//当前登录用户职位收藏
#define kJobDestroyJob @"api/job/job_fav_destroy1?"
//收藏某个职位
#define kJobCollection @"api/job/job_fav_create1?"
//当前登录用户职位收藏列表
#define kJobCollectionList @"api/job/job_fav_list1?"

#define kTestCache @"http://t.zhiliaoapi.com:88/test.php?"
#define kTestCachejian  @"http://t.zhiliaoapi.com:88/test_1.php?"


//********************招聘会和安卓招聘，猎头职位
//获取最新社会招聘会的列表
#define kZPListSociety @"new_api/recruitment?"



//***********************私信接口
//获取私信列表(私信一级列表)
#define kPersonalMessage @"new_api/pm/pm_list?"
//获取单个会话记录（私信二级列表）
#define kPersonalDetailMessage @"new_api/pm/session_list?"
//发送私信
#define kSendMessage @"new_api/pm/send?"
//删除私信
#define kDeleteMessage @"new_api/pm/pm_del?"
//请求附件信息
#define kSendFiles @"message.php?ac=attachmentlist"
//查询plid
#define kGetPlidWithCompanyId @"new_api/pm/pm_link?"
//*************************手机注册
//检测手机号是否可用
#define kCheckTelNumber @"api/check_mobile?"
//用手机号进行注册
#define kMobileRegister @"api/mobile/mobile_register?"
//找回密码
#define kFindPassWord @"api/check_mobile/check_mobile_pass?"

//***********************邮箱接口
#define kQQEnail @"m.mail.qq.com/"
#define kYahooEmail @"mail.cn.yahoo.com/"
#define k163Email @"mail.163.com/"
#define kSinaEmail @"mail.sina.com.cn/"
#define kSohuEmail @"mail.sohu.com/"
#define kGoogleEmail @"mail.google.com/mail/"
#define k139Email @"mail.10086.cn/"
#define kWangyi @"mail.163.com/"
#define kHotEmail @"login.live.com/"
#define k189Email @"webmail22.189.cn/webmail/"

//导航栏
#define kNavigation [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header2.png"]];
//导航栏标题
#define kNavTitle [UILabel ]
//返回
#define kBackNormalImage [UIImage imageNamed:@"back1.png"]

#define kBackHighLigthImage [UIImage imageNamed:@"back2.png"]

#define kSaveHighLigthImage [UIImage imageNamed:@"save2.png"]
#define kSaveNormalImage [UIImage imageNamed:@"save.png"]

//返回键的大小
#define kBackLeftFrame CGRectMake(5,7,50,30)
#define kNavigationFrame CGRectMake(0,0,iPhone_width,44)
#define KBackRightFrame CGRectMake(iPhone_width - 55,7,45,30)
//微博
#define SINAAPPKEY @"2252731642" //设置sina appkey
#define SINAAPPSECRET @"74f74c931bbdafdde213f75e126b3d27"
#define kAppRedirectURI @"http://www.sina.com"
#define XZhiL_colour RGBA(247, 105, 7, 1)

#define XZhiL_colour2 RGBA(240,239,244, 1)

#define XZHILBJ_colour RGBA(245, 245, 245, 1)

#define Frame_Y ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0 ? 20 : 0.0)

#define color_view_line RGBA(234, 234, 234, 1)

#define color_lightgray RGBA(145, 145, 145, 1)

//快捷订阅
#define KuaiJIeDingyue @"api/fast/fast_sub_create?"
//获取快捷订阅的列表
#define KuaijieList  @"api/fast/fast_booker_myshow?"
//删除订阅器
#define KuaijieDetaleat @"api/fast/fast_sub_delete?"

//兼职订阅
#define JianZhiDingyue @"api/parttime/parttime_sub_create?"
//获取兼职订阅的列表
#define JianzhiList @"api/parttime/parttime_booker_myshow?"
//删除订阅器
#define JianzhiDetaleat @"api/parttime/parttime_sub_delete?"
//兼职职位详情接口
#define  ZhiWeiXiangQing @"api/job/parttimeJob_detail?"
//兼职企业简介接口
#define EnterpriseIntroduce @"api/company/company_show?"
//兼职其他职位接口
#define OtherPosition @"api/job/parttimeJob_other_list?"

//*************简历
#define kResumeInfo @"api/resume_manage/resume_info?"
//保存编辑简历的信息
#define kSaveEducation @"new_api/resume/reedit?"
////保存编辑简历的信息
//#define kSaveEducation_P @"new_api/resume/reedit"
//删除简历的信息
#define kDeleEducation @"new_api/resume/del?"
//附件公开状态
#define FilePublic @"api/resume_manage/attachment_open?"
//保存工作经历
#define kWorkExperience @"api/resume_manage/work_list_save?"
//删除工作经历
#define kDeleteWorkExperience @"api/resume_manage/work_list_delete?"
//教育信息key
#define EducationKey @"educationList"
//工作经历key
#define WorkExperience @"worksList"
#define Language @"language2"
//求职意向
#define ApplyJob @"applyjob"
//基本信息完善工能
#define  jiben1 @"new_api/loginuser/renew_userInfo?"
//注销个人信息
#define  zhuxiao @"new_api/loginuser/loginout?"



//才币的来源列表
#define Myscore_list @"new_api/loginuser/my_score_list?"
//才币的消费列表
#define Myspend_list @"new_api/loginuser/my_spend_score_list?"
//才币的总量
#define My_score  @"new_api/loginuser/my_score?"
//分享获得才币
#define Shar_score @"new_api/loginuser/share?"

//涨薪宝用到的参数

#define ZhangXinBao @"raises/showView?"

#define SubmentCheck @"/raises/backGains?"

#define kHongbao @"/raises/getRedEnvelopes?"

#define kZhifubao @"/raisesapi/mypay/topay?"

#define kZXBAfterPay @"raises/weChat?"

#define kZXBGetStatus @"raises/getState?"



#pragma mark - 其他宏定义
#define RGB(r,g,b)      [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define Nav_Back_Font_M [UIFont systemFontOfSize:14]
#define Theme_Color_Pink [UIColor colorWithRed:R/255.0 green:G/83 blue:B/123 alpha:1.0f]
#define Theme_Color_White [UIColor whiteColor]
#define Theme_ContentColor_L RGB(17,17,17)     // #111111

//背景颜色
#define kFontColorGray [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8]
#define kChinaFont @"ArialRoundedMTBold"

//导航栏颜色
#define kNavigationBarBg  RGB(255,178,66) //

//小职了字体宏定义
#define Zhiti @"Courier"
#define kDeviceType [[UIDevice currentDevice] model]
#define kDeviceVersion [[UIDevice currentDevice] systemVersion]
#define kMainScreenFrame [[UIScreen mainScreen] bounds]
#define kMainScreenWidth kMainScreenFrame.size.width
#define kMainScreenHeight (kMainScreenFrame.size.height)
#define kApplicationFrame [[UIScreen mainScreen] applicationFrame]

#define ios7jj ([[UIDevice currentDevice].systemVersion floatValue] * 10000>=70000 ?20:0)

#define IOS7 [[UIDevice currentDevice].systemVersion floatValue] * 10000>=70000 ?YES:NO
#define ISIOS7 ([[UIDevice currentDevice].systemVersion floatValue]) * 10000>=70000 ?YES:NO

#define kBackgroundColor [UIColor colorWithRed:248.0/255.0f green:245.0/255.0f blue:244.0/255.0f alpha:1.0];

//判断是不是iphone5
#define iPhone_5Screen (([[UIScreen mainScreen] bounds].size.height > 481.0) ? YES:NO)

//如果屏幕宽度少于375
#define isScreenIPhone6Below (([[UIScreen mainScreen] bounds].size.width < 375.0) ? YES:NO)

//如果屏幕宽度大于375
#define isScreenIPhone6Upper (([[UIScreen mainScreen] bounds].size.width > 375.0) ? YES:NO)
//iPhone的高度
#define iPhone_height [[UIScreen mainScreen] bounds].size.height
//iPhone的宽度
#define iPhone_width [[UIScreen mainScreen] bounds].size.width
//iPhone的frame
#define iPhone_5Frame [[UIScreen mainScreen] bounds]
#define kWXAppid @"wx8840f26e9334b3d6"
#define kWXAppSecret @"ce674a092091c98ce9006939ce05170d"


//用于拼接两个字符串
#define kCombineURL(Host,url) [[NSString alloc] initWithFormat:@"%@%@",Host,url];

//取出auth串
#define kAUTHSTRING [[NSUserDefaults standardUserDefaults] valueForKey:@"userToken"]

// 获取登录用户的token
#define kUserTokenStr kTestToken
// 获取设备的IMEI
#define IMEI [XZLUtil getIMEI]
// 获取app的版本号
#define kAppVersion [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

#define mUserDefaults       [NSUserDefaults standardUserDefaults]
#define noNil(x) (x==nil)?@"":x
#define GRBToken [[NSUserDefaults standardUserDefaults] valueForKey:@"token"]

//颜色转换
#define mRGBColor(r, g, b)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define mRGBAColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//rgb颜色转换（16进制->10进制）
#define mRGBToColor(rgb) [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:1.0]

//设置app界面字体及颜色

#define kTitleFontLarge              [UIFont boldSystemFontOfSize:25]//一级标题字号
#define kTitleFontMiddle             [UIFont boldSystemFontOfSize:19]//二级标题字号
#define kTitleFontSmall              [UIFont boldSystemFontOfSize:16]//三级标题字号

#define kContentFontLarge            [UIFont systemFontOfSize:19]  //内容部分大字号
#define kContentFontMiddle           [UIFont systemFontOfSize:16]  //内容部分中字号
#define kContentFontSmall            [UIFont systemFontOfSize:13]  //内容部分小字号

#define kContentFontSmallSmall            [UIFont systemFontOfSize:11]  //内容部分小小字号

#define kContentFontBoldLarge            [UIFont boldSystemFontOfSize:19]  //内容部分加粗大字号
#define kContentFontBoldMiddle           [UIFont boldSystemFontOfSize:16]  //内容部分加粗中字号
#define kContentFontBoldSmall


#define kAccountTypeQQ @"qq"
#define kAccountTypeSina @"sina"
#define kAccountTypeWX @"wechat"

//验证串
#define kVerificationStr @"5320890307905054133"

#define kAreaCode [CityInfo standerDefault].cityCode
#define kAreaName [CityInfo standerDefault].cityName

#define UmengAppkey @"51a304545270157994000015"

//简单的以AlertView显示提示信息
#define mAlertView(title, msg) \
UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil \
cancelButtonTitle:@"确定" \
otherButtonTitles:nil]; \
[alert show];

//简单的GhostView显示提示信息
#define mGhostView(title,msg)\
OLGhostAlertView *ghost = [[OLGhostAlertView alloc] initWithTitle:title message:msg timeout:1 dismissible:YES];\
ghost.position = OLGhostAlertViewPositionCenter;\
[ghost show];

//设置 view 圆角和边框
#define mViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]


#define NOTI_ReloadResumeListFromWeb @"ReloadResumeListFromWeb"
#define NOTI_ReloadResumeList @"NOTI_ReloadResumeList"

// 接收到私信消息
#define kReceiveRemoteNotification @"ReceiveRemoteNotification"
#define kReceiveRemoteNotificationPMList @"ReceiveRemoteNotificationPMList"//pmlist单独刷新
//有未读消息
#define kHasMessageUnread @"kHasMessageUnread"

// 消息列表tableview reload
#define kMessageListTableReload @"kMessageListTableReload"

//审核隐藏字段名
#define HideForCheck @"HideForCheck"
#define HideForCheck_Value @"1"//1开启审核 0 关闭审核

//App审核账号
#define  AccountForCheck @"15806523467"

@end


