//
//  RecommendProcessViewController.h
//  FreeChat
//
//  Created by WangJinyu on 6/08/2015.
//  Copyright (c) 2015 WangJinyu. All rights reserved.
//

#import "BaseViewController.h"

@interface RecommendProcessViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
{
    OLGhostAlertView * ghostView;
}

@property (nonatomic,strong)NSString * uidStr;
@property (nonatomic,strong)NSString * companyIdStr;
@property (nonatomic,strong)NSString * jobIdStr;

@end
