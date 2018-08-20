//
//  BounsJobListViewController.h
//  JobKnow
//
//  Created by Jiang on 15/9/15.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol BounsJobListDelegate <NSObject>

- (void)didSelectBounsJob:(NSDictionary *)jobDic;

@end

@interface BounsJobListViewController : BaseViewController

@property (nonatomic, retain) NSMutableArray *jobList;
@property (nonatomic, weak) id<BounsJobListDelegate> delegate;

@end

