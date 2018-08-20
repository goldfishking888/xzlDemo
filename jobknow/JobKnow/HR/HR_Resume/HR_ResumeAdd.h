//
//  HR_ResumeAdd.h
//  JobKnow
//
//  Created by Suny on 15/8/3.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditReader.h"
#import "jobRead.h"
#import "nianxianViewController.h"
#import "HRReumeModel.h"
#import "HR_ResumeDetail.h"
@class HR_ResumeList;
#import "HR_ResumeShareTool.h"
#import "HR_ResumePriceEdit.h"
#import "xueliViewController.h"
#import "CustomSheet.h"
#import "HR_ResumeAddNext.h"
#import "KTSelectDatePicker.h"


@protocol HR_ResumeAddDelegate
@optional

-(void)addModelWithModel:(HRReumeModel *)model;

@end

@interface HR_ResumeAdd : UIViewController<UITextFieldDelegate,UITextViewDelegate,chuanzDeleat,HR_ResumePriceEditDelegate,ConditionDelegate>
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
    UILabel *label_ph;

    HRReumeModel *model ;
    
    KTSelectDatePicker *_datePicker;
    CustomSheet *m_sheet;
    UIAlertController *_alertController;
}

@property (nonatomic, strong) NSMutableDictionary *resumeDic;

@property(nonatomic,assign) id <HR_ResumeAddDelegate> delegate;//竟然用不了- -那我把整个viewcontroller传过去

@property(nonatomic,strong) HR_ResumeList *resumeListVC;



@end
