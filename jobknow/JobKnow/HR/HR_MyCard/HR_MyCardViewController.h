//
//  HR_MyCardViewController.h
//  JobKnow
//
//  Created by WangJinyu on 15/8/13.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface HR_MyCardViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendRequest, UITextFieldDelegate>
{
    OLGhostAlertView * ghostView;
}

@property (nonatomic,strong)NSString * hrStateStr;

@end
