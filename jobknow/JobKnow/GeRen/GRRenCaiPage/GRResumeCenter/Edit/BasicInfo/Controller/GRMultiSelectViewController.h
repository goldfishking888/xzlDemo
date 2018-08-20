//
//  GRMultiSelectViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "BaseViewController.h"
#import "GRReadModel.h"

typedef enum
{
    MultiSelectENUMPosition = 1,
    MultiSelectENUMIndustry = 2,
}MultiSelectENUM;

@protocol GRMultiSelectViewControllerDelegate <NSObject>

@optional
- (void)onMultiSelectPositionWithArray:(NSMutableArray *)array_selected;

@optional
- (void)onMultiSelectIndustryWithArray:(NSMutableArray *)array_selected;

@end

@interface GRMultiSelectViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *saveArray;  //保存选中的数据，GRReadModel
    NSMutableArray *dataArray;  //tableview的数据源
    UILabel *scoreLabel;
    UIImageView *jiantouImage;
    OLGhostAlertView *ghostView;
}
@property(nonatomic) MultiSelectENUM type;
@property(nonatomic,strong) NSString *titleString;
@property(nonatomic,strong) UITableView *myTableView;
@property(nonatomic,strong) GRReadModel *model;
@property(nonatomic) NSInteger maxNum;
@property(nonatomic,strong) id<GRMultiSelectViewControllerDelegate>delegate;

@end
