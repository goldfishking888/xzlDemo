//
//  GRRegisterViewController.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/27.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"
#import "GRRegisterModel.h"//新注册model

@interface GRRegisterViewController : BaseViewController<CLLocationManagerDelegate>
@property (nonatomic, strong) GRRegisterModel *registerModel;//注册model
//CLLocationManager
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
