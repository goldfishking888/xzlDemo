//
//  FeedbackVC.m
//  JobKnow
//
//  Created by king on 13-4-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "FeedbackVC.h"
#import "TipsView.h"
#import "OLGhostAlertView.h"
@interface FeedbackVC ()

@end

@implementation FeedbackVC
int num;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
     myUser = [NSUserDefaults standardUserDefaults];
        num = ios7jj;
        olalterView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:1 dismissible:YES];
        olalterView.position = OLGhostAlertViewPositionCenter;
        self.view.backgroundColor = XZHILBJ_colour;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    scrollView = [ [UIScrollView alloc ] initWithFrame:CGRectMake(0, 44, 320, iPhone_height) ];
    scrollView.contentSize =CGSizeMake(iPhone_width, iPhone_height+1);
    [self.view addSubview:scrollView];
    [self addBackBtn];
    [self addTitleLabel:@"意见反馈"];
    //导航条下一条按钮
    UIButton *faBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    faBtn.frame = CGRectMake(250, 0, 70, 40);
    [faBtn addTarget:self action:@selector(iphone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:faBtn];
    UIButton *fasongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fasongBtn addTarget:self action:@selector(iphone:) forControlEvents:UIControlEventTouchUpInside];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"ip01.png"] forState:UIControlStateNormal];
    fasongBtn.frame = CGRectMake(iPhone_width-50, 7+num, 50, 50);
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"ip01.png"] forState:UIControlStateHighlighted];
    [fasongBtn setBackgroundImage:[UIImage imageNamed:@"ip01.png"] forState:UIControlStateNormal];
    [self.view addSubview:fasongBtn];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, -20, 290, 140)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"小职了致力于提供全城最新最全职位信息，欢迎您提出宝贵建议，我们将不断改进。";
    label.font = [UIFont fontWithName:Zhiti size:15];
    label.numberOfLines = 4;
    [scrollView addSubview:label];
    
    //添加文本框下面的图片
    tableViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, 280, 44*3+14)];
    tableViewImage.image = [UIImage imageNamed:@"textView_2.png"];
    [scrollView addSubview:tableViewImage];
    //添加文本框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 90, 280, 44*3+14)];
    self.textView.text = @"请输入您的反馈意见(300字以内)";
    self.textView.font=[UIFont fontWithName:Zhiti size:13];
    self.textView.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    self.textView.backgroundColor=[UIColor clearColor];
    //自动修改
    self.textView.autocorrectionType=UITextAutocorrectionTypeNo;
    //大写锁定
    self.textView.scrollEnabled = YES;
    self.textView.delegate=self;
    self.textView.showsVerticalScrollIndicator=YES;
    self.textView.returnKeyType = UIReturnKeyDone;
    
    [scrollView addSubview:self.textView];
    
    UILabel *label_info = [[UILabel alloc]initWithFrame:CGRectMake(20, 250, 200, 20)];
    label_info.text = @"您的电话,QQ或邮箱";
    label_info.backgroundColor = [UIColor clearColor];
     label_info.font = [UIFont fontWithName:Zhiti size:14];
    label_info.textColor = [UIColor darkGrayColor];
    [scrollView addSubview:label_info];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 270, 200, 20)];
    label1.font = [UIFont systemFontOfSize:13];
    label1.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    label1.text = @"(选填,以便我们给您回复)";
    label1.backgroundColor = [UIColor clearColor];
//    [scrollView addSubview:label1];
    
    tableViewImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 305-20-9, 280, 44)];
    tableViewImage1.image = [UIImage imageNamed:@"mimaimg.png"];
    [scrollView addSubview:tableViewImage1];
    tableViewImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 350-20-4, 280, 44)];
    tableViewImage2.image = [UIImage imageNamed:@"mimaimg.png"];
    [scrollView addSubview:tableViewImage2];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(30, 305-20-5, 260, 35)];
        [self.textField setBorderStyle:UITextBorderStyleNone]; //外框类型
    self.textField.font = [UIFont fontWithName:@"Arial" size:13.0f];
        self.textField.placeholder = @"请输入您的电话...";
    self.textField.clearButtonMode = UITextFieldViewModeAlways;
//    self.textField.clearButtonMode = UITextFieldViewModeAlways;
//    NSString *mytel = [myUser valueForKey:@"user_tel"];
//    if (mytel == nil) {
//        self.textField.text = @"";
//    }else{
//        self.textField.text = mytel;
//    }

        self.textField.delegate =self;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.returnKeyType =UIReturnKeyNext;
    self.textField.tag = 1000;
    self.textField.keyboardType = UIKeyboardTypePhonePad;
        [scrollView addSubview:self.textField];
 
    self.textField2 = [[UITextField alloc]initWithFrame:CGRectMake(30, 305+45-20, 260, 35)];
    [self.textField2 setBorderStyle:UITextBorderStyleNone]; //外框类型
    self.textField2.placeholder = @"请输入您的QQ或邮箱";
    self.textField2.clearButtonMode = UITextFieldViewModeAlways;
    self.textField2.font = [UIFont fontWithName:@"Arial" size:13.0f];
    self.textField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField2.keyboardType = UIKeyboardTypeDefault;
    self.textField2.delegate =self;
   
   // self.textField2.text = @"";
   
       

    self.textField2.tag = 1001;
    //self.textField.background = [UIColor clearColor];
    [self.textField clearButtonMode];
    self.textField2.returnKeyType =UIReturnKeyDone;
    
    [scrollView addSubview:self.textField2];
    
    
    //订阅按钮
    UIButton *readBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    readBtn.frame=CGRectMake(20,380,280,40);
    readBtn.backgroundColor=[UIColor clearColor];
    [readBtn setTitle:@"发  送" forState:UIControlStateNormal];
    [readBtn setTitle:@"发  送" forState:UIControlStateHighlighted];
    [readBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtn.png"] forState:UIControlStateNormal];
    [readBtn setBackgroundImage:[UIImage imageNamed:@"dingyueBtnShadow.png"] forState:UIControlStateHighlighted];
    [readBtn addTarget:self action:@selector(fasong:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView  addSubview:readBtn];


    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 410, 280, 40) ;
    [button addTarget:self action:@selector(fasong:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setBackgroundImage:[UIImage imageNamed:@"btn_big@2x.png"] forState:UIControlStateNormal];
    [button setTitle:@"发送" forState:(UIControlStateNormal)];
   // [scrollView addSubview:button];
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:gesture];
    
    //弹出view
    tchuView = [[UIView alloc]initWithFrame:CGRectMake(80, 160, 150, 80)];
    tchuView.backgroundColor = [UIColor blackColor];
    tchuView.alpha = 0;
	tchuView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
    tchuView.layer.cornerRadius = 6.0;
    
    
    UILabel *labela = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 130, 30)];
    labela.text = @"发送成功";
    labela.font = [UIFont boldSystemFontOfSize:14];
    labela.backgroundColor = [UIColor clearColor];
    labela.textColor= [UIColor whiteColor];
    [tchuView addSubview:labela];
    [scrollView addSubview:tchuView];
    
     self.textFields = [NSArray arrayWithObjects:self.textField,self.textField2, nil];
    
}
#pragma mark-UITextView的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入您的反馈意见(300字以内)"]) {
        self.textView.text=@"";
    }
    [self viewAnimation:self.view frame:CGRectMake(0, -40, 320, iPhone_height) time:0.3];
    self.textView.textColor=[UIColor blackColor];
    return YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        self.textView.text=@"请输入您的反馈意见(300字以内)";
    }
    self.textView.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.textField.textColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
    self.textField2.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.7];
}
#pragma mark-UITextField的代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self viewAnimation:self.view frame:CGRectMake(0, -200, iPhone_width, iPhone_height) time:0.3];
//    NSLog(@"+++++++++++%d",textField.tag);
//    switch (textField.tag) {
//        case 1000:
//            tableViewImage1.image = [UIImage imageNamed:@"textField_1.png"];
//             tableViewImage2.image = [UIImage imageNamed:@"textField_2.png"];
//            break;
//            case 1001:
//            tableViewImage2.image = [UIImage imageNamed:@"textField_1.png"];
//             tableViewImage1.image = [UIImage imageNamed:@"textField_2.png"];
//            break;
//            
//        default:
//            break;
//    }
  //  [self changeBackgroundColor:textField.tag];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    if (textField == self.textField) {
    [self.textField2 becomeFirstResponder];
    }else if (textField == self.textField2){
    [self hidenKeyboard];
    }
    
    return YES;
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range

 replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [self hidenKeyboard];
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    tableViewImage.image = [UIImage imageNamed:@"textView_1.png"];
}
//动画方法
- (void)viewAnimation:(UIView *)view frame:(CGRect)frame time:(float)time
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:time];
    view.frame = frame;
    [UIView commitAnimations];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:view cache:YES];
    
}
-(void)fasong:(id)sender
{
    [self hidenKeyboard];
    if ([self.textView.text isEqualToString:@"请输入您的反馈意见(300字以内)"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入反馈内容!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if (self.textField.text.length ==0 && self.textField2.text.length ==0){
        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你的联系方式为空,我们将无法联系到你!确定不留下一个你的联系方式吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert1.tag = 100;
        [alert1 show];
    }else{
        if(![self isValidateMobile:self.textField.text ]){
            olalterView.message = @"手机号码格式错误，请输入真实有效的信息";
            [olalterView show];
        }else{
            [self connection];
        }
    }
}
- (void)connection
{
    //创建并发送请求
//    NetWorkConnection *net = [[NetWorkConnection alloc] init];
//    net.delegate = self;
    NSString *url = kCombineURL(KXZhiLiaoAPI, @"new_api/loginuser/feedback?");
    NSString *contentStr = [NSString stringWithFormat:@"手机型号：%@ 系统版本号：%@ 反馈：%@",[XZLUtil deviceVersion],[[UIDevice currentDevice] systemVersion],self.textView.text];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:IMEI,contentStr,@"IOS",[mUserDefaults valueForKey:@"userToken"],nil] forKeys:[NSArray arrayWithObjects:@"userImei",@"contents",@"from",@"userToken", nil]];
    if (self.textField.text.length == 0 ) {
        [paramDic setObject:@"" forKey:@"mobile"];
    }else{
        [paramDic setObject:self.textField.text forKey:@"mobile"];
    }
    if (self.textField2.text.length == 0) {
        [paramDic setObject:@"" forKey:@"email"];
    }else{
        [paramDic setObject:self.textField2.text forKey:@"email"];
    }
    
    
//    [net request:url param:paramDic andTime:15];
    
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:paramDic urlString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSData *responseData = [request responseData];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error=___%@",@"反馈失败");
        
        [self.navigationController popToRootViewControllerAnimated:YES];

    }];
    [request startAsynchronous];
    
    olalterView.message = @"谢谢你的宝贵意见!";
    [olalterView show];
}


#pragma mark - 网络请求代理
-(void)receiveASIRequestFinish:(NSData *)receData
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)receiveASIRequestFail:(NSError *)error
{
    NSLog(@"error=___%@",error);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)backUpVC:(id)sender
{
    if (self.textField.text.length ==0 && self.textField2.text.length ==0 && [self.textView.text isEqualToString:@"请输入您的反馈意见(300字以内)"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"有信息尚未提交,确定要返回么?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 110;
        [alert show];
    }
}
//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.textField resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textView resignFirstResponder];
    tableViewImage.image = [UIImage imageNamed:@"textView_2.png"];
//    tableViewImage1.image = [UIImage imageNamed:@"textField_2.png"];
//    tableViewImage2.image = [UIImage imageNamed:@"textField_2.png"];
    [self viewAnimation:self.view frame:CGRectMake(0, 0, iPhone_width, iPhone_height) time:0.3];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
       
    }
    else {
        if (alertView.tag == 100) {
            [self connection];
            NSLog(@"5222");
        }else{
           // [self connection];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)bounceOutAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         tchuView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         tchuView.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped];
                     }];
    [self performSelector:@selector(start) withObject:nil afterDelay:2];
    
}

- (void)bounceInAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         tchuView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
         tchuView.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         [self animationStoped];
                     }];
}
- (void)animationStoped
{
    
}
- (void)start
{
    tchuView.alpha = 0;
    tchuView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
    
}
- (void)changeBackgroundColor:(NSInteger )textTag
{
    for (UITextField *textField in self.textFields) {
        if (textField.tag != textTag) {
            textField.background = [UIImage imageNamed:@"textField_2.png"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)iphone:(id)sender
{
    UIActionSheet *actionSheet;
    actionSheet = [[UIActionSheet alloc]
                   initWithTitle:@"拨打电话 "
                   delegate:self
                   cancelButtonTitle:@"取消"
                   destructiveButtonTitle:@"0532-80901998"
                   otherButtonTitles:nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    actionSheet.tag = 1010;
    [actionSheet showInView:self.view];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1010) {
        if (buttonIndex == 0) {
            NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:0532-80901998"];
            NSURL *url = [NSURL URLWithString:urlStr];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
- (BOOL)isValidateMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return  [phoneTest evaluateWithObject:mobile];
}
@end
