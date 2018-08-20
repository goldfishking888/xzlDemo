//
//  InfoPerfectViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-1.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackColor <NSObject>
-(void)changeColur1;
@end

typedef enum request
{
    request01,
    request02
}requestN;

@interface InfoPerfectViewController : BaseViewController <UITextFieldDelegate,SendRequest>
{
    BOOL empty;
    
    UIImageView *img_un;
    UIImageView *img_per;
    UIImageView *img_tel;
    UIImageView *imageV;
    NSUserDefaults *myUser;
    OLGhostAlertView *olalterView;
    
    OLGhostAlertView *alert;
    UILabel *subLabel;
    UILabel *moneyLabel;
    UILabel *name;
    UILabel *sex;
    UIImageView *image;
    
    UIButton *menBtn;
    UIButton *womenBtn;
    UILabel *tel;
    UILabel *tip;
    UIButton *saveBtn;
    
    UISegmentedControl *seg;
    UILabel *men;
    UILabel *women;
    
    int num;
    
    UIImageView *subMv;
    UIImageView *moneyMv;
    
    UIButton *schoolBtn;
    UILabel *label03;
    MBProgressHUD *loadView;
}

@property (nonatomic ,assign)requestN myRe;
//大学名称
@property (nonatomic, strong) UITextField *univercity;
//姓名
@property (nonatomic, strong) UITextField *personName;
//手机号码
@property (nonatomic, strong) UITextField *telNumber;

@property (nonatomic, strong) UITextField *subUnivercity;

@property (nonatomic, strong) UITextField *money;

@property (nonatomic, strong) UITextField *invite;
@property (nonatomic,strong)id<BackColor>deleate;
@property (nonatomic, copy) NSString *personType;
@property (nonatomic, copy) NSString *tipString;

@property (nonatomic, strong) NSArray *textFields;

@property (nonatomic, strong) NSString *sexStr;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong)UIScrollView *myScrollow;
@property (nonatomic, assign) BOOL enter;
@property (nonatomic,retain)NSString *myType;


@end
