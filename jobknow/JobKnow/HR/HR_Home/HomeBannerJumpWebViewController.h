//
//  HomeBannerJumpWebViewController.h
//  JobKnow
//
//  Created by Suny on 15/12/25.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeBannerJumpWebViewController : BaseViewController<UITextFieldDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>
{
    MBProgressHUD *loadView;//加载层
    NSInteger num;
    BOOL isFirst;
    OLGhostAlertView *ghostView ;

}
@property (nonatomic, retain) UIWebView *myWebView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic,retain) NSString *floog;



@end
