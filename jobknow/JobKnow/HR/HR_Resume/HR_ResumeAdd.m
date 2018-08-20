//
//  HR_ResumeAdd.m
//  JobKnow
//
//  Created by Suny on 15/8/3.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_ResumeAdd.h"

#define cell_height 40
#define cell_space 10
#define cell_space_top 60

#define FONT_TITLE_RESUME_ADD [UIFont systemFontOfSize:15]
#define FONT_CONTENT_RESUME_ADD [UIFont systemFontOfSize:15]
#define COLOR_CONTENT_RESUME_ADD [UIColor blackColor]

@interface HR_ResumeAdd ()

@end

@implementation HR_ResumeAdd
//NSMutableDictionary*urlParamter = [NSMutableDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",@"resume_cn",@"table",jianliId,@"id",[save industryCode],@"trade",[EditReader jobCode],@"job_sort",xinzhi,@"hope_salary",leibie,@"work_type",[EditReader areaCode],@"hope_workarea", nil];

-(void)initData
{
    
    num=ios7jj;
    
    jobString=[[NSString alloc]init];
    
    dataArray=[[NSMutableArray alloc]init];//数据源
    
    selectArray = [[NSMutableArray alloc]init];//存储选择的positionModel职位的数组
    _resumeDic = [[NSMutableDictionary alloc] init];
    [_resumeDic setValue:@"" forKey:@"trueName"];
    [_resumeDic setValue:@"1" forKey:@"sex"];
    [_resumeDic setValue:@"" forKey:@"birthday"];
    [_resumeDic setValue:@"" forKey:@"mobile"];
    [_resumeDic setValue:@"" forKey:@"jobSort"];
    [_resumeDic setValue:@"" forKey:@"degree"];
    [_resumeDic setValue:@"" forKey:@"workYears"];
    [_resumeDic setValue:@"" forKey:@"resumePrice"];
    [_resumeDic setValue:@"" forKey:@"recommend"];
    
    [EditReader removeAllData];
    
    ghostView = [[OLGhostAlertView alloc] initWithTitle:nil message:nil timeout:0.5 dismissible:YES];
    ghostView.position = OLGhostAlertViewPositionCenter;
    
    self.view.backgroundColor = XZhiL_colour2;
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    if (_resumeDic.count == 0) {
        jobString = [EditReader jobStr];
        if ([jobString isEqualToString:@"选择职业"]) {
            jobString = @"";
        }else{
            [_resumeDic setValue:[EditReader jobCode] forKey:@"jobSort"];
        }
        [label_position setText:jobString];
//    }else
//    {
//        [_resumeDic removeAllObjects];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self addNav];
    
    [self initView];
    
//    NSString *jobcode = [_resumeDic valueForKey:@"positionClass_code"];
//    NSArray *names = [jobString componentsSeparatedByString:@","];
//    NSArray *codes = [jobcode componentsSeparatedByString:@","];
//    
//    EditReader *edit = [EditReader standerDefault];
//    [edit.jobArray removeAllObjects];
//    if (codes.count == names.count) {
//        for (NSInteger i = 0; i<codes.count; i++) {
//            jobRead *j = [[jobRead alloc] init];
//            j.name = [names objectAtIndex:i];
//            j.code = [codes objectAtIndex:i];
//            [edit.jobArray addObject:j];
//        }
//    }

}

-(void)addNav{
    self.view.backgroundColor = XZHILBJ_colour;
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
            [navTitle setText:@"被推荐人基本信息填写"];
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
                [btn setFrame:CGRectMake(10, Frame_Y+8, 50, 30)];
                [btn setEnabled:true];
                btn.titleLabel.font = [UIFont systemFontOfSize:18];
                [btn setTitleColor:[UIColor colorWithHex:0x2c2c2c alpha:1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(leftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //右按钮
//                 [btn setFrame:CGRectMake(iPhone_width-60, Frame_Y+7, 50, 30)];
//                
////                [btn setImage:[UIImage imageNamed:@"reader.png"] forState:UIControlStateNormal];
////                [btn setImage:[UIImage imageNamed:@"reader.png"] forState:UIControlStateHighlighted];
//                [btn setBackgroundColor:[UIColor clearColor]];
//                btn.titleLabel.font = [UIFont systemFontOfSize:17];
//                [btn setTitle:@"添加" forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [btn  addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
    }

}

-(void)initView{
    
    UILabel *label_Top = [[UILabel alloc] initWithFrame:CGRectMake(cell_space*2, cell_space, iPhone_width-4*cell_space, 40)];
    [label_Top setTextColor:[UIColor orangeColor]];
    [label_Top setText:@"Hi,小职了主要用于技术、营销等岗位中高级人才的推荐与招聘哦"];
    [label_Top setFont:[UIFont systemFontOfSize:14]];
    [label_Top setNumberOfLines:0];
    [label_Top setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSArray *arr = @[@"姓名",@"性别",@"出生日期",@"手机号码",@"职位类别",@"学历水平",@"工作年限",@"简历价格"];
    
    viewTop = [[UIView alloc] initWithFrame:CGRectMake(cell_space, cell_space_top, iPhone_width-2*cell_space, cell_height*arr.count)];
    [viewTop setBackgroundColor:[UIColor whiteColor]];
    [viewTop.layer setBorderWidth:1.0];//画线的宽度
    [viewTop.layer setBorderColor:color_view_line.CGColor];//颜色
    [viewTop.layer setCornerRadius:4.0];//圆角
    
    for (int i = 0; i<arr.count; i++) {
        UILabel *label_name = [[UILabel alloc] initWithFrame:CGRectMake(cell_space, cell_space+i*cell_height, 70, 24)];
        [label_name setFont:FONT_TITLE_RESUME_ADD];
        [label_name setTextColor:color_lightgray];
        [label_name setBackgroundColor:[UIColor clearColor]];
        [label_name setText:[arr objectAtIndex:i]];
        [viewTop addSubview:label_name];
        
        if (i!=(arr.count-1)) {
            UIView *view_line = [[UIView alloc] initWithFrame:CGRectMake(0, cell_height*(i+1), viewTop.frame.size.width, 1)];
            [view_line setBackgroundColor:color_view_line];
            [viewTop addSubview:view_line];
        }
        if (i==0) {
            UITextField *tf_name = [[UITextField alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2, cell_space, viewTop.frame.size.width - cell_space*3 -label_name.frame.size.width, 24)];
            [tf_name setPlaceholder:@"请输入人才姓名"];
            [tf_name setFont:FONT_CONTENT_RESUME_ADD];
//            [tf_name setBackgroundColor:color_view_line];
            [tf_name setTintColor:[UIColor orangeColor]];
            [tf_name setTextAlignment:NSTextAlignmentRight];
            [tf_name setTextColor:COLOR_CONTENT_RESUME_ADD];
            [tf_name setReturnKeyType:UIReturnKeyDone];
            tf_name.tag = 1;
            tf_name.delegate = self;
            [viewTop addSubview:tf_name];
        }else if (i == 1){
            btn_female = [[UIButton alloc] initWithFrame:CGRectMake(viewTop.frame.size.width - 40, cell_space/2+i*cell_height, 30, 30)];
            [btn_female setImage:[UIImage imageNamed:@"hr_gender_female_unselected"] forState:UIControlStateNormal];
            [btn_female setImage:[UIImage imageNamed:@"hr_gender_female"] forState:UIControlStateSelected];
            btn_female.tag = 2;
            [btn_female addTarget:self action:@selector(clickGender:) forControlEvents:UIControlEventTouchUpInside];
            
            btn_male = [[UIButton alloc] initWithFrame:CGRectMake(viewTop.frame.size.width - 100, cell_space/2+i*cell_height, 30, 30)];
            [btn_male setImage:[UIImage imageNamed:@"hr_gender_male_unselected"] forState:UIControlStateNormal];
            [btn_male setImage:[UIImage imageNamed:@"hr_gender_male"] forState:UIControlStateSelected];
            btn_male.tag = 1;
            [btn_male addTarget:self action:@selector(clickGender:) forControlEvents:UIControlEventTouchUpInside];
             
            btn_male.selected = YES;
            
            [viewTop addSubview:btn_female];
            [viewTop addSubview:btn_male];
        }else if (i == 2){
            label_birth = [[UILabel alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2,  cell_space+i*cell_height, viewTop.frame.size.width - cell_space*5 -label_name.frame.size.width, 20)];
            label_birth.textColor = color_lightgray;
//            [label_birth setText:@"未完善"];
            [label_birth setUserInteractionEnabled:YES];
            UITapGestureRecognizer *position = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate)];
            [label_birth addGestureRecognizer:position];
            [label_birth setTextAlignment:NSTextAlignmentRight];
            [label_birth setFont:FONT_CONTENT_RESUME_ADD];
            [label_birth setTextColor:COLOR_CONTENT_RESUME_ADD];
            [viewTop addSubview:label_birth];
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(iPhone_width-50,cell_space+i*cell_height -5, 30, 30)];
            [btn setTag:6];
            [btn setImage:[UIImage imageNamed:@"arrow_gray_right"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
            [viewTop addSubview:btn];
            
        }else if(i == 3){
            UITextField *tf_phone = [[UITextField alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2,  cell_space+i*cell_height, viewTop.frame.size.width - cell_space*3 -label_name.frame.size.width, 24)];
            [tf_phone setPlaceholder:@"请输入人才手机号码"];
//            [tf_phone setBackgroundColor:color_view_line];
            [tf_phone setTintColor:[UIColor orangeColor]];
            [tf_phone setFont:FONT_CONTENT_RESUME_ADD];
            [tf_phone setTextColor:COLOR_CONTENT_RESUME_ADD];
            [tf_phone setTextAlignment:NSTextAlignmentRight];
            [tf_phone setKeyboardType:UIKeyboardTypeNumberPad];
            [tf_phone setReturnKeyType:UIReturnKeyDone];
            tf_phone.tag = 2;
            tf_phone.delegate = self;
            [viewTop addSubview:tf_phone];
   
        }else if (i == 4){
            label_position = [[UILabel alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2,  cell_space+i*cell_height, viewTop.frame.size.width - cell_space*5 -label_name.frame.size.width, 20)];
            label_position.textColor = color_lightgray;
//            [label_position setText:@"未完善"];
            [label_position setUserInteractionEnabled:YES];
            UITapGestureRecognizer *position = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPosition)];
            [label_position addGestureRecognizer:position];
            [label_position setTextAlignment:NSTextAlignmentRight];
            [label_position setFont:FONT_CONTENT_RESUME_ADD];
            [label_position setTextColor:COLOR_CONTENT_RESUME_ADD];
            [viewTop addSubview:label_position];
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(iPhone_width-50,cell_space+i*cell_height -5, 30, 30)];
            [btn setTag:6];
            [btn setImage:[UIImage imageNamed:@"arrow_gray_right"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
            [viewTop addSubview:btn];
            
        }else if (i == 5){
            label_edu = [[UILabel alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2,  cell_space+i*cell_height, viewTop.frame.size.width - cell_space*5 -label_name.frame.size.width, 20)];
            label_edu.textColor = color_lightgray;
//            [label_edu setText:@"选择最高学历"];
            [label_edu setUserInteractionEnabled:YES];
            UITapGestureRecognizer *position = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDegree)];
            [label_edu addGestureRecognizer:position];
            [label_edu setTextAlignment:NSTextAlignmentRight];
            [label_edu setFont:FONT_CONTENT_RESUME_ADD];
            [label_edu setTextColor:COLOR_CONTENT_RESUME_ADD];
            [viewTop addSubview:label_edu];
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(iPhone_width-50,cell_space+i*cell_height -5, 30, 30)];
            [btn setTag:6];
            [btn setImage:[UIImage imageNamed:@"arrow_gray_right"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
            [viewTop addSubview:btn];
            
        }else if(i == 6){
            label_workyear = [[UILabel alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2,  cell_space+i*cell_height, viewTop.frame.size.width - cell_space*5 -label_name.frame.size.width, 20)];
            label_workyear.textColor = color_lightgray;
//            [label_workyear setText:@"选择工作年限"];
            [label_workyear setTextAlignment:NSTextAlignmentRight];
            [label_workyear setFont:FONT_CONTENT_RESUME_ADD];
            [label_workyear setTextColor:COLOR_CONTENT_RESUME_ADD];
            [label_workyear setUserInteractionEnabled:YES];
            UITapGestureRecognizer *workyear = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWorkYear)];
            [label_workyear addGestureRecognizer:workyear];
            [viewTop addSubview:label_workyear];
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(iPhone_width-50,cell_space+i*cell_height -5, 30, 30)];
            [btn setTag:6];
            [btn setImage:[UIImage imageNamed:@"arrow_gray_right"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
            [viewTop addSubview:btn];
        }else if (i == 7){
            label_price = [[UILabel alloc] initWithFrame:CGRectMake(label_name.frame.size.width + cell_space*2,  cell_space+i*cell_height, viewTop.frame.size.width - cell_space*5 -label_name.frame.size.width, 20)];
            label_price.textColor = color_lightgray;
//            [label_price setText:@"选择简历价格"];
            [label_price setUserInteractionEnabled:YES];
            UITapGestureRecognizer *position = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPrice)];
            [label_price addGestureRecognizer:position];
            [label_price setTextAlignment:NSTextAlignmentRight];
            [label_price setFont:FONT_CONTENT_RESUME_ADD];
            [label_price setTextColor:COLOR_CONTENT_RESUME_ADD];
            [viewTop addSubview:label_price];
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(iPhone_width-50,cell_space+i*cell_height -5, 30, 30)];
            [btn setTag:6];
            [btn setImage:[UIImage imageNamed:@"arrow_gray_right"] forState:UIControlStateNormal];
            [btn setEnabled:NO];
            [viewTop addSubview:btn];
            
        }
    }
    
    view_comment = [[UIView alloc] initWithFrame:CGRectMake(cell_space, viewTop.frame.origin.y+viewTop.frame.size.height + cell_space, iPhone_width-2*cell_space, 3*cell_height)];;
    [view_comment setBackgroundColor:[UIColor whiteColor]];
    [view_comment.layer setBorderWidth:1.0];//画线的宽度
    [view_comment.layer setBorderColor:color_view_line.CGColor];//颜色
    [view_comment.layer setCornerRadius:4.0];//圆角
    
    UILabel *label_comment = [[UILabel alloc] initWithFrame:CGRectMake(cell_space, cell_space, view_comment.frame.size.width - 2*cell_space, 20)];
    [label_comment setText:@"给他写推荐语"];
    [label_comment setFont:FONT_TITLE_RESUME_ADD];
    [label_comment setTextColor:color_lightgray];
    [view_comment addSubview:label_comment];
    
    label_ph = [[UILabel alloc] initWithFrame:CGRectMake(cell_space,20 +cell_space,view_comment.frame.size.width-2*cell_space,40)];
    [label_ph setTextColor:[UIColor colorWithHex:0xe0e0e0 alpha:1]];
    [label_ph setText:@"您可以对人才的工作经历、工作经验等进行描述，这些信息对用人单位十分重要"];
    [label_ph setFont:[UIFont systemFontOfSize:14]];
    [label_ph setLineBreakMode:NSLineBreakByWordWrapping];
    [label_ph setNumberOfLines:0];
    [view_comment addSubview:label_ph];
    
    UITextView *tv_comment = [[UITextView alloc] initWithFrame:CGRectMake(cell_space, 20 +cell_space,view_comment.frame.size.width-2*cell_space , view_comment.frame.size.height-cell_space -20)];
    [tv_comment setBackgroundColor:[UIColor clearColor]];
    [tv_comment setTintColor:[UIColor orangeColor]];
    [tv_comment setTextAlignment:NSTextAlignmentLeft];
    [tv_comment setDelegate:self];
    [tv_comment setTag:3];
    [tv_comment setFont:FONT_CONTENT_RESUME_ADD];
    [tv_comment setTextColor:COLOR_CONTENT_RESUME_ADD];
    [view_comment addSubview:tv_comment];
    
    //下一步
    UIButton *button_confirm = [[UIButton alloc] initWithFrame:CGRectMake(30, view_comment.frame.origin.y +view_comment.frame.size.height + cell_space, iPhone_width-2*30, 40)];
    [button_confirm setTitle:@"下一步" forState:UIControlStateNormal];
    [button_confirm setBackgroundColor:XZhiL_colour];
    [button_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_confirm addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIScrollView *scrollView_content = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    [scrollView_content addSubview:label_Top];
    [scrollView_content addSubview:viewTop];
    [scrollView_content addSubview:view_comment];
    [scrollView_content addSubview:button_confirm];
    [scrollView_content setContentSize:CGSizeMake(iPhone_width, viewTop.frame.size.height+view_comment.frame.size.height +button_confirm.frame.size.height +cell_space*3+cell_space_top)];
    [self.view addSubview:scrollView_content];
    
    UITapGestureRecognizer *singRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstResponder:)];
    [self.view addGestureRecognizer:singRecognizer];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark- 网络请求

-(void)sendRequest
{
    Net *n=[Net standerDefault];
    
    if (n.status ==NotReachable) {
        ghostView.message=@"无网络连接,请检查您的网络!";
        [ghostView show];
        return;
    }
    
    loadView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    loadView.userInteractionEnabled=NO;
    
    NSString *urlStr=kCombineURL(KXZhiLiaoAPI,HRCreateResume);
    
//    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:IMEI,@"userImei",kUserTokenStr,@"userToken",pageStr,@"page",@"20",@"count",nil];
    [_resumeDic setValue:IMEI forKey:@"userImei"];
    [_resumeDic setValue:kUserTokenStr forKey:@"userToken"];
    NSUserDefaults *AppUD=[NSUserDefaults standardUserDefaults];
    NSString *uid = [AppUD valueForKey:@"userUid"];
    [_resumeDic setValue:uid forKey:@"pid"];
    NSURL *URL=[NetWorkConnection dictionaryBecomeUrl:_resumeDic urlString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setCompletionBlock:^{
        
        [loadView hide:YES];
        
        NSError *error;
        
        //        NSLog(@"简历列表下载成功");
        
        NSDictionary *resultDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:&error];
        NSString *errorStr =[resultDic valueForKey:@"error"];
        
        if(!resultDic){
            
            ghostView.message=@"请重新登录";
            [ghostView show];
            return ;
        }
        if(errorStr.integerValue == 0){
            NSLog(@"添加简历成功");
            
//            ghostView.message=@"创建成功，马上去完善简历吧";
//            [ghostView show];
//            model = [[HRReumeModel alloc] initWithDictionary:resultDic];
            model = [[HRReumeModel alloc] init];
            model.resumeUid = [resultDic valueForKey:@"uid"];
            model.resumePid = [resultDic valueForKey:@"pid"];
            model.sex = [_resumeDic valueForKey:@"sex"];
            model.name = [_resumeDic valueForKey:@"trueName"];
            model.workYear = [_resumeDic valueForKey:@"workYears"];
            
            [_resumeListVC addModelWithModel:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetHeaderWhenAddedNewResume" object:nil];
            
            [self performSelector:@selector(jumpToResumeDetail) withObject:nil afterDelay:1];
            
        }else if (errorStr.integerValue == 2){
            ghostView.message=@"注册失败";
            [ghostView show];
            return;
        }else if (errorStr.integerValue == 3){
            ghostView.message=@"此份简历当前已经创建过";
            [ghostView show];
            return;
        }
        
    }];
    [request setFailedBlock:^{
        [loadView hide:YES];
        
    }];
    [request startAsynchronous];
    
}


#pragma mark- UserActions
-(void)jumpToResumeDetail{
    HR_ResumeAddNext *detail = [[HR_ResumeAddNext alloc] init];
    detail.isFromResumeAdd = YES;
    detail.resumeModelFromList = model;
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)clickGender:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        btn_male.selected = YES;
        btn_female.selected = NO;
        [_resumeDic setValue:@"1" forKey:@"sex"];
    }else{
        btn_male.selected = NO;
        btn_female.selected = YES;
        [_resumeDic setValue:@"2" forKey:@"sex"];
    }
}

-(void)clickPosition{
    JobItemViewController *jobVC = [[JobItemViewController alloc] init];
    jobVC.enter = NO;
    [self.navigationController pushViewController:jobVC animated:YES];
}

-(void)clickDegree{
    xueliViewController *xueli = [[xueliViewController alloc]init];
    xueli.selectDelegate = self;
    [self.navigationController pushViewController:xueli animated:YES];
}

-(void)clickWorkYear{
    nianxianViewController *nian =[[nianxianViewController alloc]init];
    nian.deleat =self;
    [self.navigationController pushViewController:nian animated:YES];
}

-(void)clickPrice{
    HR_ResumePriceEdit *priceList = [[HR_ResumePriceEdit alloc] init];
    priceList.isFromResumeList = NO;
//    priceList.resumeModel = resumeModel;
//    priceList.indexPath = nil;
    priceList.delegate = self;
    [self.navigationController pushViewController:priceList animated:YES];
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{
    
    [self.view endEditing:YES];
    
    if (![_resumeDic valueForKey:@"trueName"]||[[_resumeDic valueForKey:@"trueName"] isEqualToString:@""]) {
        ghostView.message=@"忘记填写姓名啦";
        [ghostView show];
        return ;
    }
    if (![_resumeDic valueForKey:@"birthday"]||[[_resumeDic valueForKey:@"birthday"] isEqualToString:@""]) {
        ghostView.message = @"忘记选择出生日期啦";
        [ghostView show];
        return;
    }
    if (![_resumeDic valueForKey:@"mobile"]||[[_resumeDic valueForKey:@"mobile"] isEqualToString:@""]) {
        ghostView.message=@"忘记填写手机号啦";
        [ghostView show];
        return ;
    }else if (![self isValidateMobile:[_resumeDic valueForKey:@"mobile"]]){
        ghostView.message = @"请输入正确手机号";
        [ghostView show];
        return;
    }else if ([self isUsedMobile:[_resumeDic valueForKey:@"mobile"]]){
        ghostView.message = @"该手机号已使用了哦";
        [ghostView show];
        return;
    }
    
    if (![_resumeDic valueForKey:@"jobSort"]||[[_resumeDic valueForKey:@"jobSort"] isEqualToString:@""]) {
        ghostView.message = @"忘记选择职位类别啦";
        [ghostView show];
        return;
    }
    if (![_resumeDic valueForKey:@"degree"]||[[_resumeDic valueForKey:@"degree"] isEqualToString:@""]) {
        ghostView.message = @"忘记选择学历水平啦";
        [ghostView show];
        return;
    }
    if (![_resumeDic valueForKey:@"workYears"]||[[_resumeDic valueForKey:@"workYears"] isEqualToString:@""]) {
        ghostView.message = @"忘记选择工作年限啦";
        [ghostView show];
        return;
    }
    if (![_resumeDic valueForKey:@"resumePrice"]||[[_resumeDic valueForKey:@"resumePrice"] isEqualToString:@""]) {
        ghostView.message = @"忘记选择简历价格啦";
        [ghostView show];
        return;
    }
    if (![_resumeDic valueForKey:@"recommend"]||[[_resumeDic valueForKey:@"recommend"] isEqualToString:@""]) {
        ghostView.message = @"忘记填写推荐语啦";
        [ghostView show];
        return;
    }
    
    [self sendRequest];
    
}

//选择日期
- (void)selectDate
{
    [self.view endEditing:YES];

    NSString *dateStr = [_resumeDic valueForKey:@"birthday"];
    if (!dateStr || [dateStr isEqualToString:@""]) {
        dateStr = @"1992-01-01";
    }
    NSDate *theDate = [XZLUtil changeStrToDate:dateStr];
    
    NSDate *minimunDate =[XZLUtil changeStrToDate:@"1970-01-01"];
    NSDate *maximunDate =[NSDate date];

    _datePicker = [[KTSelectDatePicker alloc] initWithMaxDate:maximunDate minDate:minimunDate currentDate:theDate datePickerMode:UIDatePickerModeDate];
    [_datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        NSString * dateStr = [XZLUtil changeDateToStr:selectedDate];
        label_birth.text = dateStr;
        [_resumeDic setValue:dateStr forKey:@"birthday"];
    }];

}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((1))\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

-(BOOL) isUsedMobile:(NSString *)mobile
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[HR_ResumeShareTool defaultTool].array_Resume];
    for (HRReumeModel *item in array) {
        if ([mobile isEqualToString:item.mobile]) {
            return YES;
        }
    }
    return NO;
}

- (void)chuanzhi:(NSString *)str{
    NSString *newWorkY = nil;
    if ([str integerValue]>0) {
        [_resumeDic setValue:str forKey:@"workYears"];
        newWorkY = [NSString stringWithFormat:@"%@年",str];
    }else{
        if ([str isEqualToString:@"-2"]) {
            newWorkY= [NSString stringWithFormat:@"不限"];
        }else if ([str isEqualToString:@"-1"]){
            newWorkY= [NSString stringWithFormat:@"在读学生"];
        }else if ([str isEqualToString:@"0"]){
            newWorkY= [NSString stringWithFormat:@"应届毕业生"];
        }
         [_resumeDic setValue:str forKey:@"workYears"];
    }
    label_workyear.text = newWorkY;
   
}
#pragma mark- ConditionDelegate
//获得学历code
- (void)selectValueToUp:(NSString *)select
{
    NSString *degreeCode  = [NSString stringWithFormat:@"%@",select];
    [_resumeDic setValue:degreeCode forKey:@"degree"];
    label_edu.text = [self changeCode:degreeCode];
    
}

//根据学历编码返回名字
-(NSString *)changeCode:(NSString *)xueliCode
{
    NSString *name = nil;
    switch ([xueliCode integerValue]) {
        case 0:
            name = @"不限";
            break;
        case 10:
            name = @"初中";
            break;
        case 11:
            name = @"高中";
            break;
        case 12:
            name = @"中技";
            break;
        case 13:
            name = @"中专";
            break;
        case 14:
            name = @"大专";
            break;
        case 15:
            name = @"本科";
            break;
        case 16:
            name = @"硕士";
            break;
        case 17:
            name = @"博士";
            break;
        case 18:
            name = @"博士后";
            break;
        case 99:
            name = @"其他";
            break;
        default:
            break;
    }
    
    
    
    return name;
}


#pragma mark- HR_ResumePriceEditDelegate

-(void)passPrice:(NSString *)price{
    [_resumeDic setValue:price forKey:@"resumePrice"];
    label_price.text = price;
}

//回收键盘
-(IBAction)resignFirstResponder:(id)sender
{
//    [textView_body resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark- UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 1) {
        [_resumeDic setValue:textField.text forKey:@"trueName"];
    }else{
        [_resumeDic setValue:textField.text forKey:@"mobile"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 2) {
        if (textField.text.length >10&&range.length != 1) {
            textField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

#pragma mark- UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{

    [label_ph setHidden:YES];
    CGRect frame = textView.frame;
//    int offset = frame.origin.y +viewTop.frame.size.height - cell_space*4 + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    int offset = frame.size.height + 216 - self.view.frame.size.height +65;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    else
        self.view.frame = CGRectMake(0.0f, offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

- (void)textViewDidChange:(UITextView *)textView{

    [_resumeDic setValue:textView.text forKey:@"recommend"];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [label_ph setHidden:NO];
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"RecoverView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
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
