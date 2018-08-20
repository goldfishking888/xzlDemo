//
//  nianxianViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol chuanzDeleat<NSObject>
- (void)chuanzhi:(NSString *)str;
@end

@interface nianxianViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    int num;
    UITableView *myTabView;
    NSMutableArray *myAry;
}
@property(nonatomic,assign)id<chuanzDeleat>deleat;
@end
