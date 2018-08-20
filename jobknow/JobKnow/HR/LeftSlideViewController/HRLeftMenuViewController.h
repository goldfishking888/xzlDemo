//
//  HRLeftMenuViewController.h
//  JobKnow
//
//  Created by admin on 15/7/31.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HR_SettingViewController.h"
#import "HR_JobCollectionViewController.h"
@interface HRLeftMenuViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendRequest>
{
    UIImageView *payVipImageView;
    UIView *tapView_vip ;//企业认证的空白view
    UILabel *industryLabel;
}

@property (nonatomic,strong) UITableView *menuTableView;

@end

@interface HRLeftMenuTableCell : UITableViewCell

-(id)initWithImage:(UIImage *)img title:(NSString *)title;

@end