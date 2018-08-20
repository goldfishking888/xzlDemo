//
//  jingli2ViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomSheet.h"
#import "pingjiaViewController.h"
#import "JobItemViewController.h"
#import "KTSelectDatePicker.h"
@interface jingli2ViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,miaosuDeleat>
{
    UITableView *myTabView;
    UITextField *companyName;
    KTSelectDatePicker *_datePicker;
    NSString *dateStr;//开始时间
    NSString *dateStr02;//结束时间
    NSString *labelCount;//描述字数
    NSString *destring;//描述
    NSString *tipString;//提示文字
    NSString *jobString;
    NSString *jobcode;
    BOOL start;
    OLGhostAlertView *alert;
}

@property (nonatomic, strong) NSMutableDictionary *workDic;

@property (nonatomic, copy) NSString *workId;
@end
