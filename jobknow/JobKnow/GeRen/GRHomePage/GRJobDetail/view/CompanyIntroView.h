//
//  CompanyIntroView.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRJobDetail_CompanyModel.h"
@interface CompanyIntroView : UIView

@property (nonatomic,strong)GRJobDetail_CompanyModel * companyDetailModel;
- (id)initWithFrame:(CGRect)frame WithCompDescripView:(GRJobDetail_CompanyModel *)model;
@end
