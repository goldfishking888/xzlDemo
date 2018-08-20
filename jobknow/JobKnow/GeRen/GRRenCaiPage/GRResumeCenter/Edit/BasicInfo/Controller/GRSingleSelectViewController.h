//
//  GRSingleSelectViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/10.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "GRReadModel.h"

typedef enum
{
    SingleSelectENUMSalary = 1,
    SingleSelectENUMWorkYears = 2,
    SingleSelectENUMEduQualification = 3,//学历
    SingleSelectENUMPosition = 4,//职业
    SingleSelectENUMNowStatus = 5,//目前状态
    SingleSelectENUMMarriage = 6,//婚姻状况
    SingleSelectENUMCorpNature = 7,//公司性质
    SingleSelectENUMCorpScale = 8,//公司规模
    SingleSelectENUMWorkCrop = 9,//工作性质(全职兼职)
    SingleSelectENUMGender = 10,//性别
    SingleSelectENUMLanguageLevel = 11,//语言等级
    SingleSelectENUMIndustry = 12,//行业
}SingleSelectENUM;

@protocol GRSingleSelectViewControllerDelegate <NSObject>

@optional
- (void)onSelectSalaryWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectWorkYearsWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectEduQualificationWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectPositionWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectNowStatusWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectMarriageWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectCorpNatureWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectCorpScaleWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectWorkCropWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectGenderWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectLanguageLevelWithModel:(GRReadModel *)model_selected;

@optional
- (void)onSelectIndustryWithModel:(GRReadModel *)model_selected;

@end

@interface GRSingleSelectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *saveArray;  //保存选中的数据，GRReadModel
    NSMutableArray *dataArray;  //tableview的数据源
    UILabel *scoreLabel;
    UIImageView *jiantouImage;
    OLGhostAlertView *ghostView;
}
@property(nonatomic) SingleSelectENUM type;
@property(nonatomic,strong) NSString *titleString;
@property(nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong) GRReadModel *model;
@property(nonatomic,strong) id<GRSingleSelectViewControllerDelegate>delegate;

@end
