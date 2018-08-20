//
//  HR_SettingViewController.h
//  JobKnow
//
//  Created by Suny on 15/8/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"

#import "WBShareKit.h"

#import "WXApiObject.h"

#import "WXApi.h"

#import "TipView.h"

#import "AboutWeViewController.h"

#import "InfoPerfectViewController.h"

#import "WebViewController.h"

#import "HRQuestionFeedbackViewController.h"

#import "PassWordViewController.h"

#import "HR_ResumeShareTool.h"


@protocol sendMsgToWeChatViewDelegate <NSObject>
@optional
- (void) sendMusicContent ;
- (void) sendVideoContent ;
- (void) sendTextContent:(NSString*)nsText;
- (void) changeScene:(NSInteger)scene;
@end

@interface HR_SettingViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,BackColor,WXApiDelegate,sendMsgToWeChatViewDelegate,UIAlertViewDelegate,upDatebb>
{
    int num;
    
    enum WXScene _scene;
    
    NSString *trackurl;
    
    NSUserDefaults *userDefaults;
    
    MBProgressHUD*loadView;
    
    OLGhostAlertView *ghostView;
    
    BOOL isHr;//是否是hr
}

@property (nonatomic, strong) NSMutableArray *moreArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;

+ (void)removeAllInfo;


@end
