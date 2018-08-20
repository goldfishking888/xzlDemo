//
//  AccountsViewController.h
//  JobKnow
//
//  Created by Apple on 14-7-28.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "myButton.h"
#import "HongBaoViewController.h"
#import "ASIHTTPRequest.h"

@interface AccountsViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,HongBaoDelegate,ASIHTTPRequestDelegate,UIWebViewDelegate>
{
    int num;
 
    int moneyy;
    
    int moneyy2;
    
    BOOL isAgree;          //判断是否阅读
    
    NSString *_redEnvelopeStr;  //第二个cell上显示的字符串
    
    NSString *_redEnvelopeID;   //所选红包的ID
    
    NSDictionary *resDic;       //红包返回的字典数据
    

    myButton *firstBtn;         //判断是微信支付还是支付宝支付

    myButton *secondBtn;        
    
    UIButton *accountBtn;       //结算按钮
    
    UIButton *agreeBtn;         //是否阅读涨薪宝购买协议
    
    UIButton *protocolBtn;      //进入涨薪宝协议按钮
    
    UITableView *_tableView;
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
}

@property (nonatomic,strong)NSString *gainStr;      //涨幅

@property (nonatomic,strong) NSString *nameStr;      //用来判断是小宝，二宝还是三宝

@end