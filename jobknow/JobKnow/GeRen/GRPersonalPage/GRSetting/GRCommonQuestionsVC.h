//
//  GRCommonQuestionsVC.h
//  JobKnow
//
//  Created by WangJinyu on 2017/8/9.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFolderTableView.h"
#import "FeedbackVC.h"
@interface GRCommonQuestionsVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,SendRequest,BackColor02>
{
    OLGhostAlertView *ghostView;
}

@property (nonatomic,assign)BOOL isOpen;
@property (nonatomic,strong)NSIndexPath *selectIndex;
@property (nonatomic,strong)NSMutableArray *detailArray;
@property (nonatomic,strong)NSMutableArray * dataListArray;
@property (nonatomic,strong)UIFolderTableView *myTabView;
@end
