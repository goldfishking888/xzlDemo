//
//  leixingViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol chuanlx<NSObject>
- (void)chuanzhilv:(NSString *)str;
@end

@interface leixingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTabView;
    NSArray *myAry;
}
@property (nonatomic,retain)id<chuanlx>deleat;
@end
