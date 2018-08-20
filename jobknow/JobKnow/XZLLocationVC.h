//
//  XZLLocationVC.h
//  XzlEE
//
//  Created by ralbatr on 14-10-9.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import "BaseViewController.h"

@protocol XZLLocationVCDelegate <NSObject>

- (void)getLocationStr:(NSString *)locationstr;

@end

@interface XZLLocationVC : BaseViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, weak) id<XZLLocationVCDelegate> delegate;
@property (nonatomic, assign) BOOL isHomeVC;

@end
