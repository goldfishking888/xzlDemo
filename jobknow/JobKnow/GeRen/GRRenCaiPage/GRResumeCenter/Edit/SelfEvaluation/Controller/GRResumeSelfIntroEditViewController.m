//
//  GRResumeSelfIntroEditViewController.m
//  JobKnow
//
//  Created by 孙扬 on 2017/8/15.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "GRResumeSelfIntroEditViewController.h"

#define MaxCount 200

@interface GRResumeSelfIntroEditViewController ()

@end

@implementation GRResumeSelfIntroEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtnGR];
    [self addTitleLabelGR:@"自我评价"];
    [self addRightButtonWithTitle:@"保存" Color:RGB(255, 163, 29)];
    [self initData];
    [self initView];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
-(void)initData{
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
}

-(void)initView{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    placeholderLabel =[[UITextView alloc] initWithFrame:CGRectMake(20, 64+10, kMainScreenWidth-20*2, 160)];
    placeholderLabel.backgroundColor = [UIColor clearColor];
    placeholderLabel.font = [UIFont systemFontOfSize:15];
    placeholderLabel.text = @"请输入您的自我评价";
    if (![_model.intro isNullOrEmpty]) {
        placeholderLabel.hidden = YES;
    }
    placeholderLabel.textColor = RGB(204, 203, 203);
    [self.view addSubview:placeholderLabel];
    
    tv_content = [[UITextView alloc] initWithFrame:CGRectMake(20, 64+10, kMainScreenWidth-20*2, 160)];
    tv_content.backgroundColor = [UIColor clearColor];
    tv_content.font = [UIFont systemFontOfSize:15];
    tv_content.textColor = RGB(74, 74, 74);
    tv_content.returnKeyType = UIReturnKeyDone;
    tv_content.delegate = self;
    tv_content.text = _model.intro;
    [self.view addSubview:tv_content];
    
    view_bottom = [[UIView alloc] initWithFrame:CGRectMake(0, kMainScreenHeight-37, kMainScreenWidth, 37)];
    view_bottom.backgroundColor = RGB(247, 247, 247);
    [self.view addSubview:view_bottom];
    
    label_count = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, 37)];
    label_count.text = [NSString stringWithFormat:@"%d/%d",_model.intro.length,MaxCount];
    label_count.textColor = RGB(170, 170, 170);
    label_count.font = [UIFont systemFontOfSize:15];
    label_count.textAlignment = NSTextAlignmentLeft;
    [view_bottom addSubview:label_count];
    
}

#pragma mark- 点击返回
- (void)backUp:(id)sender
{
    if(![_model.intro isEqualToString:tv_content.text]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有更改还未保存，是否保存" preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self saveChanges];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 点击保存
-(void)onClickRightBtn:(UIButton *)sender{
    [self saveChanges];
}

-(void)saveChanges{
    [self.view endEditing:YES];
    
    if([NSString isNullOrEmpty:tv_content.text]){
        ghostView.message = @"请输入自我评价";
        [ghostView show];
        return;
    }else if(tv_content.text.length<10){
        ghostView.message = @"自我评价最少10个字";
        [ghostView show];
        return;
    }else if(tv_content.text.length>MaxCount){
        ghostView.message = @"您输入的字符长度超过最大长度";
        [ghostView show];
        return;
    }
    
    
    
    [self saveingRequest];
}


#pragma mark- 保存修改网络请求
-(void)saveingRequest{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSString *tokenStr = kTestToken;
    [paramDic setValue:tokenStr forKey:@"token"];
    [paramDic setValue:tv_content.text forKey:@"self_evaluation"];
    [paramDic setValue:_model.resumeId forKey:@"id"];
    
    
    NSString * url = [NSString stringWithFormat:@"%@%@",kTestAPPAPIGR,@"/api/partner/resume/base/update"];
    [XZLNetWorkUtil requestPostURL:url params:paramDic success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]] ) {
            NSNumber *error_code = responseObject[@"error_code"];
            if (error_code.intValue == 0) {
                ghostView.message = @"保存成功";
                [ghostView show];
                [self performSelector:@selector(popView) withObject:nil afterDelay:1];
            }else{
                NSLog(@"register_do %@",@"fail");
                ghostView.message = responseObject[@"message"];
                [ghostView show];
            }
        }else{
            NSLog(@"register_do %@",@"fail");
            ghostView.message = @"保存失败";
            [ghostView show];
        }
    } failure:^(NSError *error) {
        ghostView.message = @"保存失败";
        [ghostView show];
    }];
}

-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 监听键盘高度
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{

    
    NSDictionary *userInfo = notification.userInfo;
    
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        // 工具条的Y值 == 键盘的Y值 - 工具条的高度
        if (keyboardF.origin.y > self.view.height) { // 键盘的Y值已经远远超过了控制器view的高度
            view_bottom.y = kMainScreenHeight - view_bottom.height; //这里的<span style="background-color: rgb(240, 240, 240);">self.toolbar就是我的输入框。</span>
            
        } else {
            view_bottom.y = keyboardF.origin.y - view_bottom.height;
        }
    }];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        placeholderLabel.hidden = YES;
    }else{
        placeholderLabel.hidden = NO;
    }
    label_count.text = [NSString stringWithFormat:@"%d/%d",textView.text.length,MaxCount];
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
