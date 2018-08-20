//
//  HRRootTabBarViewController.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/25.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "HRRootTabBarViewController.h"
#import "HRHomeViewController.h"
#import "HRPersonalCenterVC.h"
#import "HRLieTouResumeListViewController.h"
#import "HRLieTouIncomeViewController.h"
#import "HRHomeViewController.h"//首页
#import "HRPersonalCenterVC.h"//个人中心
@interface HRRootTabBarViewController ()

@end

@implementation HRRootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViewControllers];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    // 设置数字样式的badge的位置和大小
    [self.tabBar setNumberBadgeMarginTop:2
                       centerMarginRight:20
                     titleHorizonalSpace:8
                      titleVerticalSpace:2];
    // 设置小圆点样式的badge的位置和大小
    [self.tabBar setDotBadgeMarginTop:5
                    centerMarginRight:15
                           sideLength:10];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kReceiveRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kHasMessageUnread object:nil];
}

- (void)initViewControllers {
    
        HRHomeViewController *controller1 = [[HRHomeViewController alloc] init];
        controller1.yp_tabItemTitle = @"首页";
        controller1.yp_tabItemImage = [UIImage imageNamed:@"HR_tab"];
        controller1.yp_tabItemSelectedImage = [UIImage imageNamed:@"HR_tab_select"];
        
        HRLieTouIncomeViewController *controller2 = [[HRLieTouIncomeViewController alloc] init];
        controller2.yp_tabItemTitle = @"收入";
        controller2.yp_tabItemImage = [UIImage imageNamed:@"HR_tab2"];
        controller2.yp_tabItemSelectedImage = [UIImage imageNamed:@"HR_tab2_select"];
    
    
        HRLieTouResumeListViewController *controller3 = [[HRLieTouResumeListViewController alloc] init];
        controller3.yp_tabItemTitle = @"简历库";
        controller3.yp_tabItemImage = [UIImage imageNamed:@"HR_tab3"];
        controller3.yp_tabItemSelectedImage = [UIImage imageNamed:@"HR_tab3_select"];
        
        HRPersonalCenterVC *controller4 = [[HRPersonalCenterVC alloc] init];
        controller4.yp_tabItemTitle = @"我";
        controller4.yp_tabItemImage = [UIImage imageNamed:@"HR_tab4"];
        controller4.yp_tabItemSelectedImage = [UIImage imageNamed:@"HR_tab4_select"];
         
        self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    //获取审核更新状态
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"AppStoreCheck" object:@1];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"viewWillAppear");
}

#pragma mark - 收到推送消息

- (void)receiveRemoteNotification:(NSNotification *)noti{
    NSNumber *count = noti.object;
    if(count){
        if (count.intValue==999) {
            UIViewController *controller3 = self.viewControllers[3];
            controller3.yp_tabItem.badgeStyle = YPTabItemBadgeStyleNumber;
            controller3.yp_tabItem.badge = nil;
        }else{
            UIViewController *controller3 = self.viewControllers[3];
            controller3.yp_tabItem.badgeStyle = YPTabItemBadgeStyleDot;
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
