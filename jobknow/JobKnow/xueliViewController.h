//
//  xueliViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-6.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol ConditionDelegate <NSObject>
- (void)selectValueToUp:(NSString *)select;
@end
@interface xueliViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTabView;
    NSMutableArray *showArray;
    NSMutableArray *showArray_code;
}
@property (nonatomic,retain)id<ConditionDelegate>selectDelegate;

@end
