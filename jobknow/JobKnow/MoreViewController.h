//
//  MoreViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-19.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SinaWeibo.h"

#import "WBShareKit.h"

#import "WXApiObject.h"

#import "WXApi.h"

#import "TipView.h"

#import "AboutWeViewController.h"

#import "InfoPerfectViewController.h"

@protocol sendMsgToWeChatViewDelegate <NSObject>
@optional
- (void) sendMusicContent ;
- (void) sendVideoContent ;
- (void) sendTextContent:(NSString*)nsText;
- (void) changeScene:(NSInteger)scene;
@end

typedef enum {
    UserTypeGeren = 0,// 个人
    UserTypeHR = 1,// HR
    UserTypePTJHunter = 2,// 兼职猎手
    
}UserType;

@interface MoreViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SinaWeiboDelegate,SinaWeiboRequestDelegate,BackColor,WXApiDelegate,sendMsgToWeChatViewDelegate,UIAlertViewDelegate,upDatebb>
{
    int num;
    
    enum WXScene _scene;
    
    NSString *trackurl;
    
    NSUserDefaults *userDefaults;
    
    MBProgressHUD*loadView;
    
    OLGhostAlertView *ghostView;
    
    BOOL isHr;//是否是hr
    BOOL isPTJH;//是否是兼职猎手
    
    UserType userType;
}

@property (nonatomic, strong) NSMutableArray *moreArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) id<sendMsgToWeChatViewDelegate> delegate;

+ (void)removeAllInfo;

@end