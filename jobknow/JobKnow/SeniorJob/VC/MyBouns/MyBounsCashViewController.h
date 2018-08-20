//
//  MyBounsCashViewController.h
//  JobKnow
//
//  Created by Jiang on 15/9/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@protocol MyBounsCashViewControllerDelegate <NSObject>

- (void)myBounsCashSuccess;

@end

@interface MyBounsCashViewController : BaseViewController

@property (nonatomic, strong) NSString *cashMoney;
@property (nonatomic, weak) id<MyBounsCashViewControllerDelegate> delegate;

@end

