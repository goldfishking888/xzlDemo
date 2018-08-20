//
//  OtherJobListView.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/25.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultModel.h"

@protocol OtherJobListDelegate
//进入职位查看界面
- (void)checkOtherJob:(NSMutableArray *)otherArray otherIndex:(NSInteger)index;

@end
@interface OtherJobListView : UIView

@property(nonatomic,assign)id <OtherJobListDelegate> otherDelegate;
- (id)initWithFrame:(CGRect)frame withPositionId:(NSString *)positionID;
@property (strong,nonatomic) XZLNoDataView *noDateView; //没有数据，哭脸

@end
