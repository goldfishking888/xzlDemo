//
//  HR_MyCardCell.h
//  JobKnow
//
//  Created by WangJinyu on 14/08/2015.
//  Copyright (c) 2015 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HR_MyCardViewController.h"

@interface HR_MyCardCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, assign) HR_MyCardViewController *vc;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *isOrage;
@property (nonatomic, strong) NSString *isLast;
@property (nonatomic, strong) NSString *isChangeData;

@end
