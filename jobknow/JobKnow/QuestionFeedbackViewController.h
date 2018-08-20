//
//  QuestionFeedbackViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
#import "FeedbackVC.h"
@interface QuestionFeedbackViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest,BackColor02>
{
    OLGhostAlertView *ghostView;
}

@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,strong)NSIndexPath *selectIndex;
@property (nonatomic,strong)NSMutableArray *detailArray;
@property (nonatomic,strong)NSMutableArray * dataListArray;
@property (nonatomic,strong)UIFolderTableView *myTabView;
@end
