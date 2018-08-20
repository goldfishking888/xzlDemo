//
//  jiben2ViewController.h
//  JobKnow
//
//  Created by Zuo on 13-9-16.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "BaseViewController.h"
@protocol chuancDeleat<NSObject>
- (void)chuanzhi:(NSString*)str ty:(NSString *)type;
@end
@interface jiben2ViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *myTabView;
    NSArray *myAry;
    NSArray *myAryCode;
}
@property (nonatomic,retain)NSString *myType;
@property (nonatomic,assign)id<chuancDeleat>deleat;
@end
