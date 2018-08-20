//
//  HR_ResumePriceEdit.h
//  JobKnow
//
//  Created by Suny on 15/8/27.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HR_ResumeShareTool.h"
#import "HRReumeModel.h"
@protocol HR_ResumePriceEditDelegate <NSObject>
@optional
- (void)afterPriceEditSucceed;//从简历或推荐列表进入，完成后更新列表

-(void)passPrice:(NSString *)price;
@end

@interface HR_ResumePriceEdit : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger num;
    NSMutableArray *dataArray;//简历数据源
    NSMutableArray *selectArray;
    MBProgressHUD *loadView;
    
    OLGhostAlertView *ghostView;
    UILabel *navTitle;
    
    NSString *price;
}
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) HRReumeModel *resumeModel;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic) BOOL isFromResumeList;

@property (nonatomic,assign) id<HR_ResumePriceEditDelegate>delegate;

@end
