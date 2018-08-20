//
//  JobDescriptionView.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRJobDetailModel.h"
//#import "GRCompanyInfoModel.h"
#import "GRJobDetail_CompanyModel.h"
//@protocol GR_JobDescriptionViewDelegate
//@optional
//@end
@interface JobDescriptionView : UIView
{
    UIScrollView * scrollbgView;
    UIView * bgHeaderView;
//    UILabel * jobtitleLab;
    UILabel * typeImageLab;
    UILabel * isFastLab;
    UILabel * salaryLab;
    UILabel * detailLab;
//    UILabel * companyNameLab;
    UILabel * jobTypeLab;
    UILabel * needCountLab;
    UILabel * publicLab;
    UILabel * refreshLab;
    
    
    UIView * bgMiddleView;
    UILabel * companyDesContentLab;
    
    UIView * bgBottomView;
    UILabel * personNameLab;
    UILabel * AddressNameLab;
}
@property (nonatomic,strong)UILabel * jobtitleLab;
//@property (nonatomic,strong)id<GR_JobDescriptionViewDelegate> delegate;
@property (nonatomic,strong)GRJobDetailModel * positionModel;
@property (nonatomic,strong) UILabel * companyNameLab;;
@property (nonatomic,strong)GRJobDetail_CompanyModel * companyDetailModel;
- (id)initWithFrame:(CGRect)frame WithJobDescripView:(GRJobDetailModel *)JobModel andCompanyDetailModel:(GRJobDetail_CompanyModel *)comDetailModel andCompanyName:(NSString *)companyName;
@end
