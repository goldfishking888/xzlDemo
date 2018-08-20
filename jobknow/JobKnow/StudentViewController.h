//
//  StudentViewController.h
//  JobKnow
//
//  Created by Zuo on 14-3-27.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "allCViewController.h"
#import "BiyeqxViewController.h"
@interface StudentViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ChuancityDelegate>
{
    int num;
    UITableView *mytableView;
    UITextField *textField01;//姓名
    UITextField *textField02;//院系
    UITextField *textField03; //学号
    UITextField *textField04; //联系电话
    UITextField *zhuanyeField;//未录入专业
    NSString *majorStr;//专业
    NSString *majorCode;//专业代码
    UISwitch *swith;
    NSString *sexStr;
    NSString *sexCode;
    NSString *cityStr;  //城市
    NSString *cityCode;
    NSString *flag;
    //学校
    NSString*schoolStr;
    //专业
    NSString*zhuanye;
    //生原地
    NSString*homeStr;
    //毕业去向
    NSString*biyeqxStr;
    
}

@property (nonatomic, copy) NSString *majorStr;
@property (nonatomic, strong) NetWorkConnection *netWork;//网络请求对象
@end
