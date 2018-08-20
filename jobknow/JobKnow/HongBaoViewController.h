//
//  HongBaoViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest/ASIHTTPRequest.h"

@protocol HongBaoDelegate<NSObject>

- (void)hongbao;

- (void)hongbaoChange;

@end

@interface HongBaoViewController : BaseViewController<UITextFieldDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int num;
    
    BOOL isFirst;
    
    NSString *textFieldStr;    //输入的编码
    
    UIButton *useBtn;          //使用按钮（用来选择使用还是不使用红包）
    
    UITextField*newTextfield;  //输入框

    UITableView *_tableView;
    
    OLGhostAlertView *ghostView;
    
    MBProgressHUD *loadView;
}

@property (nonatomic,strong)UIImageView*searchImage;

@property (nonatomic,strong)id<HongBaoDelegate>delegate;

@end