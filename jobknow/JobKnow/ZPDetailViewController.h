//
//  ZPDetailViewController.h
//  JobsGather
//
//  Created by faxin sun on 13-1-21.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPInfo.h"
@class JobFairViewController;
@interface ZPDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *myScroll;
    UIImageView *myImg ;
    UITableView *myTableView;
    NSArray *arry04;
    NSArray *arry03;
    NSArray *ary033;
    NSArray *ary044;
    
}
@property (strong, nonatomic) UILabel *zpSchool;
- (void)backZP:(id)sender;

@property (strong, nonatomic) UILabel *zpTitle;
@property (strong, nonatomic) UILabel *location;
@property (strong, nonatomic) NSString *myTitle;
@property (strong, nonatomic) UILabel *zpDate;
@property (strong, nonatomic) UILabel *zpCity;
@property (strong, nonatomic) UILabel *zpLocation;
@property (strong,nonatomic) ZPInfo *zpInfo;

@end
