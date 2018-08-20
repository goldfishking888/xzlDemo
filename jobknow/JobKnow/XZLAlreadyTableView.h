//
//  XZLAlreadyTableView.h
//  XzlEE
//
//  Created by ralbatr on 14-9-23.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XZLAlreadyDelegate <NSObject>

@optional

-(void)removeSelectedjob:(NSString *)jobstr;

@end

@interface XZLAlreadyTableView : UITableView<UITableViewDataSource,UITableViewDelegate,XZLAlreadyDelegate>
{
    NSInteger *btnTag;

}
//tableview数据源
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, weak) id <XZLAlreadyDelegate>XZLAlreadyDelegate;

@end









