//
//  HrApplyCashViewController.h
//  JobKnow
//
//  Created by admin on 15/8/4.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "HrSelectBankViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TPKeyboardAvoidingTableView.h"

typedef NS_ENUM(NSInteger, HrApplyCashType)
{    
    HrApplyCashTypeOfInvite = 0,//邀请奖金申请提现
    HrAppleCashTypeOfRecommend = 1,//推荐奖金申请提现
};

@interface HrApplyCashViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,HrSelectBankDelegate,UITextFieldDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
@property (nonatomic, strong) NSString *money;//现金数量
@property (nonatomic, assign) HrApplyCashType appleType;

@end


@interface HrApplyCashTableCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *detailTextField;

-(id)initCrashTableCell;
@end