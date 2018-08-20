//
//  ApplyStateDetailViewController.h
//  JobKnow
//
//  Created by WangJinyu on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyStateDetailViewController : BaseViewController
{
OLGhostAlertView * ghostView;
}
@property (nonatomic,strong)NSString * detailIDStr;
@property (nonatomic,strong)NSString * applyTimeStr;
@end
