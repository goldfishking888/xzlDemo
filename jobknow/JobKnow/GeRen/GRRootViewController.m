//
//  GRRootViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/4/24.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "GRRootViewController.h"
#import "GRHomeViewController.h"
#import "XZLPMListViewController.h"//私信
#import "GRPartnerViewController.h"//人才合伙人
#import "GRPersonalViewController.h"//个人中心
@interface GRRootViewController ()

@end

@implementation GRRootViewController{
    BOOL isMessageSelected;
    int count_unreadMessage;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    count_unreadMessage = 0;
    
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
    
//    UIViewController *controller1 = self.viewControllers[0];
//    UIViewController *controller2 = self.viewControllers[1];
//    UIViewController *controller3 = self.viewControllers[2];
//    UIViewController *controller4 = self.viewControllers[3];
//    controller1.yp_tabItem.badge = 8;
//    controller2.yp_tabItem.badge = 88;
//    controller3.yp_tabItem.badge = 120;
//    controller4.yp_tabItem.badgeStyle = YPTabItemBadgeStyleDot;
    
    isMessageSelected = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kReceiveRemoteNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:kHasMessageUnread object:nil];
    
    
}

- (void)initViewControllers {
    
    GRHomeViewController *controller1 = [[GRHomeViewController alloc] init];
    controller1.yp_tabItemTitle = @"首页";
    controller1.yp_tabItemImage = [UIImage imageNamed:@"tab"];
    controller1.yp_tabItemSelectedImage = [UIImage imageNamed:@"tab_selected"];
    
    GRPartnerViewController *controller2 = [[GRPartnerViewController alloc] init];
    controller2.yp_tabItemTitle = @"人才合伙人";
    controller2.yp_tabItemImage = [UIImage imageNamed:@"tab2"];
    controller2.yp_tabItemSelectedImage = [UIImage imageNamed:@"tab2_selected"];
    
    XZLPMListViewController *controller3 = [[XZLPMListViewController alloc] init];
    controller3.yp_tabItemTitle = @"私信";
    controller3.yp_tabItemImage = [UIImage imageNamed:@"tab3"];
    controller3.yp_tabItemSelectedImage = [UIImage imageNamed:@"tab3_selected"];
    
    GRPersonalViewController *controller4 = [[GRPersonalViewController alloc] init];
    controller4.yp_tabItemTitle = @"我的";
    controller4.yp_tabItemImage = [UIImage imageNamed:@"tab4"];
    controller4.yp_tabItemSelectedImage = [UIImage imageNamed:@"tab4_selected"];
    
    if ([XZLUtil isUnderCheck]) {
        self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller3, controller4, nil];
    }else{
       self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"viewWillAppear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)didSelectViewControllerAtIndex:(NSUInteger)index {
    if (index==2) {
        isMessageSelected = YES;
    }else{
        isMessageSelected = NO;
        
    }
}

#pragma mark - 收到推送消息

- (void)receiveRemoteNotification:(NSNotification *)noti{
    if (isMessageSelected) {
        UIViewController *controller3 = self.viewControllers[2];
        controller3.yp_tabItem.badge = nil;
        count_unreadMessage = 0;
        return;
    }
    NSNumber *count = noti.object;
    if(count){
        if (count.intValue==999) {
            //设置已读，去掉红点
            if (count_unreadMessage>0) {
                count_unreadMessage = 0;
            }
        }else{
            count_unreadMessage = count_unreadMessage+count.intValue;
        }
        
    }
    
    if (count_unreadMessage>0) {
        UIViewController *controller3 = self.viewControllers[2];
        controller3.yp_tabItem.badge = 1;
    }else{
        UIViewController *controller3 = self.viewControllers[2];
        controller3.yp_tabItem.badge = nil;
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
