//
//  RootViewController.h
//  UI_Lesson
//
//  Created by Ibokan on 12-9-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRReumeModel.h"
#import "HR_ResumeDetail.h"

@protocol HR_ResumeDeleteDelegate <NSObject>
@optional

-(void)deleteResumeWithModel:(HRReumeModel *)model;

@end

@interface WebViewController : BaseViewController <UITextFieldDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>
{
    MBProgressHUD *loadView;//加载层
    NSInteger num;
    BOOL isFirst;
    NSString *currentSoundPathStr;
    UIImageView *moreView;
    OLGhostAlertView *ghostView ;
    int clickNum;
}
@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic,retain) NSString *floog;
@property (nonatomic) BOOL isFromResumeList;
@property (nonatomic) BOOL isHRSelf;

@property (nonatomic,strong) HRReumeModel *resumeModel;

@property(nonatomic,assign) id <HR_ResumeDeleteDelegate> delegate;//

@end
