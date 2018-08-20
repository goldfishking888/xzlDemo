//
//  SeniorJobRightViewController.h
//  JobKnow
//
//  Created by Suny on 15/9/8.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"


@interface SeniorJobRightViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

@end
