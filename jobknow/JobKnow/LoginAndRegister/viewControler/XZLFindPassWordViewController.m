//
//  XZLFindPassWordViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/9/14.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "XZLFindPassWordViewController.h"

@interface XZLFindPassWordViewController ()<UITextFieldDelegate>

@end

@implementation XZLFindPassWordViewController{
    OLGhostAlertView *ghostView;
    MBProgressHUD *loadView;
    
    UITextField *tf_content;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"忘记密码"];
    [self initData];
    [self initView];
}
    
-(void)initData{
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)initView{
    UIView *viewBack = [[UIView alloc] initWithFrame:CGRectMake(27, 64+26, kMainScreenWidth-37*2, 47)];
    mViewBorderRadius(viewBack, 2, 0.5, RGB(216, 216, 216));
    [self.view addSubview:viewBack];
    
    UIImageView *imagePhone = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 12, 15, 22)];
    [imagePhone setImage:[UIImage imageNamed:@"icon_phone"]];
    [viewBack addSubview:imagePhone];
    
    tf_content = [[UITextField alloc] initWithFrame:CGRectMake(38, 15, viewBack.width-37.5-10, 17)];
    tf_content.backgroundColor = [UIColor clearColor];
    tf_content.font = [UIFont systemFontOfSize:15];
    tf_content.textColor = RGB(74, 74, 74);
    tf_content.returnKeyType = UIReturnKeyDone;
    tf_content.placeholder = @"请输入注册时使用的手机号";
    tf_content.delegate = self;
    [viewBack addSubview:tf_content];
    
    UIButton *btn_Confirm = [[UIButton alloc] initWithFrame:CGRectMake(48,viewBack. bottom+ 36, kMainScreenWidth-48*2, 50)];
    btn_Confirm.backgroundColor = RGB(251, 144, 2);
    [btn_Confirm setTitle:@"找回" forState:UIControlStateNormal];
    [btn_Confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mViewBorderRadius(btn_Confirm, btn_Confirm.height/2, 1, [UIColor clearColor]);
    [btn_Confirm addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Confirm];

}

-(void)request{
    if (tf_content.text.length == 0) {
        mGhostView(nil, @"请输入手机号");
        return;
    }else{
        if (![XZLUtil isValidateMobile:tf_content.text]) {
            mGhostView(nil, @"手机号格式不正确");
            return;
        }
    }
    //token是token规则：md5($mobile前3位+t+‘xzl1998’)
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*tStr = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSString * mobilrStr = [tf_content.text substringToIndex:3];
    NSString * tokenStr = [NSString stringWithFormat:@"%@%@%@",mobilrStr,tStr,@"xzl1998"];
    tokenStr = [NSString md5:tokenStr];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tf_content.text,@"mobile",tStr,@"t",tokenStr,@"token", nil];
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/account/reset_password"];
    [XZLNetWorkUtil requestPostURLWithoutAddingParams:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                mGhostView(nil, @"新密码已发送到您的手机，请注意查收");
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                mGhostView(nil, responseObject[@"message"]);

            }
            
        }else{
            NSLog(@"register_do %@",@"fail");
            mGhostView(nil, @"操作失败");
        }
    } failure:^(NSError *error) {
        mGhostView(nil, @"操作失败");

    }];
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
