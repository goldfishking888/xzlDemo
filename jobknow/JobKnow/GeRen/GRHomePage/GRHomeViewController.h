//
//  GRHomeViewController.h
//  JobKnow
//
//  Created by 孙扬 on 2017/4/24.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "SDCycleScrollView.h"

@interface GRHomeViewController : BaseViewController<CLLocationManagerDelegate>

@property (nonatomic,strong) UIView *menuBar;

@property (nonatomic,strong) UIView *view_back;

// 导航栏背景view
@property(nonatomic,strong)UIView *navigationBackView;
// tableView
@property(nonatomic,strong)UITableView *tableView;
// 记录tableView偏移量
@property (nonatomic, assign) CGFloat tableViewOffsetY;
// 定位view
@property (nonatomic, strong) UIView *locationView;
// navigationBar右侧按钮
@property (nonatomic, strong) UIButton *searchButton;
// navigationBar右侧按钮
@property (nonatomic, strong) UIButton *emailButton;
// 定位lable
@property(nonatomic,strong)UILabel *locationLabel;
// 定位地址size
@property(nonatomic,assign)CGSize locationSize;
// 定位地址
@property(nonatomic,copy)NSString *locationStr;
//CLLocationManager
@property (strong, nonatomic) CLLocationManager *locationManager;
// tablev的头视图
@property (nonatomic, strong) UIView *headerView;

// banerScrollView
@property (nonatomic, strong) UIScrollView *banerScrollView;
// collectionView
@property (nonatomic, strong) UICollectionView *collectionView;
// collectionView
@property (nonatomic, strong)  SDCycleScrollView *cycleScrollView;

@property (strong,nonatomic) XZLNoDataView *noDateView; //没有数据，哭脸
@end
