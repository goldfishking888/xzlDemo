//
//  XZLPMDetailViewController.h
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "BaseViewController.h"
#import "XZLPMListModel.h"
#import "HPGrowingTextView.h"
#import <AVFoundation/AVFoundation.h>
#import "TipView.h"
#import "XZLNewPMDetailCell.h"

@interface XZLPMDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,TipViewDelegate,NSURLConnectionDataDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,XZLPMDetailCellDelegate>

@property (nonatomic,strong) XZLPMListModel *pmlistModel;
@property (nonatomic,copy) NSString *preparedMsg;

@end
