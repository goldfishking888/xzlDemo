//
//  HR_ResumeEdit.h
//  JobKnow
//
//  Created by Suny on 15/8/6.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditReader.h"
#import "jobRead.h"
#import "JobItemViewController.h"
#import "nianxianViewController.h"
//#import "HRResumeInfo_Base_Model.h"
#import "HRResumeInfoModel.h"
#import "HR_ResumeShareTool.h"
#import "HRReumeModel.h"
#import "HR_ResumePriceEdit.h"
#import "xueliViewController.h"
#import "CustomSheet.h"
#import "KTSelectDatePicker.h"

@protocol HR_ResumeEditDelegate<NSObject>
//简历基本信息修改后需要reset简历详情的model
- (void)resetRusumeModelWithBaseModel:(NSDictionary *)model_Base andJobString:(NSString *)jobString;

@end

@interface HR_ResumeEdit : UIViewController<UITextFieldDelegate,UITextViewDelegate,chuanzDeleat,HR_ResumePriceEditDelegate,ConditionDelegate>
{
    
    NSString *jobString;//头部标题
    
    NSString *allCount;
    
    NSMutableArray *dataArray;//数据源
    NSMutableArray *selectArray;//被选中的职业。
    
    //显示标题的label
    UILabel *titleLabelx;
    UILabel *titleLabely;
    NSInteger num;
    
    
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    
    UIView *viewTop;
    UIView *view_comment;
    UILabel *label_position;
    UILabel *label_birth;
    UILabel *label_edu;
    UILabel *label_price;
    UILabel *label_workyear;
    UIButton *btn_female;
    UIButton *btn_male;
    
    KTSelectDatePicker *_datePicker;
    CustomSheet *m_sheet;
    UIAlertController *_alertController;
    
}
@property (nonatomic,assign) id<HR_ResumeEditDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *resumeDic;

@property (nonatomic, strong) HRResumeInfoModel *model_Resume;//来自简历详情的base信息model

@property (nonatomic) BOOL isFromDetail;//用作viewWillAppear中判断是否是从详情跳入的标示

@end
