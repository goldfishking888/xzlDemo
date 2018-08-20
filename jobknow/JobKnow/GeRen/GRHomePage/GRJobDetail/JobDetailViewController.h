//
//  JobDetailViewController.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"
#import "WBShareKit.h"
#import "GRJobDetailModel.h"
#import "GRCompanyInfoModel.h"
#import "GRJobDetail_CompanyModel.h"
#import "OtherJobListView.h"
@interface JobDetailViewController : BaseViewController<SinaWeiboDelegate,SinaWeiboRequestDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate,OtherJobListDelegate,WBHttpRequestDelegate>
{
    GRJobDetailModel *positionModel;
    GRCompanyInfoModel * comInfoModel;
    GRJobDetail_CompanyModel * comDetailModel;
}
@property (nonatomic, strong)NSString * positionID;
@property (nonatomic, strong)NSString * companyName;
//@property (nonatomic, strong)NSString * companyID;

@end
