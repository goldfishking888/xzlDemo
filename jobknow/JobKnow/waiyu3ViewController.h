//
//  waiyu3ViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol chuanDeleat<NSObject>
- (void)chuanzhi:(NSString*)str myType:(NSString*)type;
@end
@interface waiyu3ViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTabView;
    NSMutableArray *yuzhAry;
    NSMutableArray *jibeAry;
}
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)id<chuanDeleat>delaet;
@end
