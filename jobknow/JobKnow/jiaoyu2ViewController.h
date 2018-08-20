//
//  jiaoyu2ViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-5.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomSheet.h"
#import "xueliViewController.h"
#import "KTSelectDatePicker.h"
@interface jiaoyu2ViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ConditionDelegate,ASIHTTPRequestDelegate>
{
    UIScrollView *myScrollow;
    CustomSheet *m_sheet;
    KTSelectDatePicker *_datePicker;
    NSString *dateStr; //毕业时间
    NSString *xueliStr; //学历
    NSString *schoolStr;//毕业学校
    NSString *majorStr;//专业
    NSString *majorCode;//专业代码
    UITextField *companyName;
    NSString *eduid;
    UITextField *zhuanyeField;//未录入专业
    UISwitch *swith;
    NSString *tipStr;
    OLGhostAlertView *alert;
    NSMutableDictionary *paramters;
}

@property (nonatomic, copy) NSString *schoolStr;//毕业学校
@property (nonatomic, copy) NSString *majorStr;

@property (nonatomic, retain)UITableView *myTableView;
@property (nonatomic, retain)NSMutableArray *moreArray;
@property (nonatomic, retain)NSMutableArray *selects;
@property (nonatomic, strong)NSDictionary *eduDic;

+ (NSArray *)jsonEducation:(NSArray *)educationArray;
@end
