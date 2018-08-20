//
//  HR_ResumeText.m
//  JobKnow
//
//  Created by Suny on 15/8/7.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeText.h"

@interface HR_ResumeText ()

@end

@implementation HR_ResumeText

-(void)initData
{
    
    num=ios7jj;
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
    //如果没有创建时间，就在此创建
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{
    [self.view endEditing:YES];
    [self sendRequest];
}

-(void)initNav{
    //顶部导航栏样式
    for (int i=0; i<4; i++) {
        if (i==0) {
            //图片
            UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+num)];
            titleIV.backgroundColor = RGBA(255, 115, 4, 1);
            [self.view addSubview:titleIV];
            
        }else if(i==3){
            //标题
            UILabel *navTitle =[[UILabel alloc] initWithFrame:CGRectMake(50, 0+Frame_Y, 210, 44)];
            [navTitle setText:@"文本简历"];
            [navTitle setTextAlignment:NSTextAlignmentCenter];
            [navTitle setBackgroundColor:[UIColor clearColor]];
            [navTitle setFont:[UIFont systemFontOfSize:18]];
            [navTitle setNumberOfLines:0];
            [navTitle setTag:999];
            [navTitle setTextColor:[UIColor whiteColor]];
            [self.view addSubview:navTitle];
            
        }else{
            //左右按钮
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            if (i==1) {
                //左按钮
                [btn setFrame:CGRectMake(10, Frame_Y+5, 50, 30)];
                [btn setEnabled:true];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                [btn setTitleColor:[UIColor colorWithHex:0x2c2c2c alpha:1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(leftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //右按钮
                
                [btn setFrame:CGRectMake(iPhone_width-60, Frame_Y+7, 50, 30)];
                
                //                [btn setImage:[UIImage imageNamed:@"reader.png"] forState:UIControlStateNormal];
                //                [btn setImage:[UIImage imageNamed:@"reader.png"] forState:UIControlStateHighlighted];
                [btn setBackgroundColor:[UIColor clearColor]];
                btn.titleLabel.font = [UIFont systemFontOfSize:17];
                [btn setTitle:@"保存" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn  addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
    }
}

-(void)initView{
    
    UILabel *label_title = [[UILabel alloc] initWithFrame:CGRectMake(12, 44+num+10, iPhone_width-2*10, 20)];
    [label_title setText:@"您可使用文本简历，粘贴或输入被推荐人简历信息。"];
    [label_title setTextColor:[UIColor grayColor]];
    [label_title setFont:[UIFont systemFontOfSize:12]];
    [self.view addSubview:label_title];
    
    UIView *view_content = [[UIView alloc] initWithFrame:CGRectMake(10, 44+num+40, iPhone_width-2*10, 150)];
    [view_content setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view_content];
    
    label_placeholder = [[UILabel alloc] initWithFrame:CGRectMake(4,5, view_content.frame.size.width , 20)];
    [label_placeholder setText:@"手动输入或粘贴被推荐人的文本简历"];
    [label_placeholder setTextColor:[UIColor darkGrayColor]];
    [label_placeholder setFont:[UIFont systemFontOfSize:13]];
    [view_content addSubview:label_placeholder];
    
    tv_content = [[UITextView alloc] initWithFrame:CGRectMake(10, 44+num+40, iPhone_width-2*10, 150)];
    [tv_content setBackgroundColor:[UIColor clearColor]];
    [tv_content setFont:[UIFont systemFontOfSize:13]];
    tv_content.delegate = self;
    if (_content&&![_content isEqualToString:@""]) {
        [tv_content setText:_content];
        [label_placeholder setHidden:YES];
    }
    [self.view addSubview:tv_content];
    
    UITapGestureRecognizer *singRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder:)];
    [self.view addGestureRecognizer:singRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initNav];
    
    self.view.backgroundColor = XZHILBJ_colour;
    
    [self initView];
    
}

//回收键盘
-(IBAction)resignFirstResponder:(id)sender
{
    //    [textView_body resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark 网络连接方法
-(void)sendRequest
{
    //    Net *n=[Net standerDefault];
    
    if ([tv_content.text isEqualToString:@""]) {
        ghostView.message=@"您啥都没写啊";
        [ghostView show];
        return;
    }
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HREditResumeText);
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",tv_content.text,@"content",_uid,@"uid",nil];
//    [paramDic setValue:tv_content.text forKey:@"content"];
//    [paramDic setValue:_uid forKey:@"uid"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            
            ghostView.message=@"请重新登录";
            [ghostView show];
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"保存成功");
            ghostView.message=@"保存成功";
            [ghostView show];
            [_delegate resetRusumeTextWithString:tv_content.text];
            [self performSelector:@selector(jumpToResumeDetail) withObject:nil afterDelay:1];
            
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
    
}

-(void)jumpToResumeDetail{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        [label_placeholder setHidden:YES];;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        [label_placeholder setHidden:NO];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        [label_placeholder setHidden:NO];;
    }
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
