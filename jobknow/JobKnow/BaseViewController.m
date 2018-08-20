//
//  BaseViewController.m
//  JobKnow
//
//  Created by Zuo on 13-8-9.
//  Copyright (c) 2013年 zuojia. All rights reserved.
//

#import "BaseViewController.h"
#import "Config.h"
@interface BaseViewController ()
{
    UIButton * titleBtn;//头部btn
    UIButton * rightBtn;
}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
        isRead = NO;
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(first) name:@"backfirst" object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    float topdistance = 0;
    long losVersion = [[UIDevice currentDevice].systemVersion floatValue] * 10000;
    if (losVersion >= 70000) {
        topdistance = 20;
    }
    self.num =topdistance;
}

- (void)addBackBtn
{
    [self configHeadView];
    self.view.backgroundColor = XZHILBJ_colour;
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,50,30);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 44);
    [button addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:_backBtn];
}

- (void)addBackBtnGROnly
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,50,30);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
}

- (void)addBackBtnGR
{
    [self configHeadViewGR];
    self.view.backgroundColor = XZHILBJ_colour;
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,50,30);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back_gray"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
}

- (void)addBackBtnGRWithText
{
    [self configHeadViewGR];
    self.view.backgroundColor = XZHILBJ_colour;
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10,5+self.num,120,56);
    [_backBtn.titleLabel setFont:[UIFont fontWithName:Zhiti size:15]];
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"backBtn_title"] forState:UIControlStateNormal];
    [self.view addSubview:_backBtn];
}


#pragma mark - 增加仅为图标的leftBarBtnItem
- (void)addBarButtonItemWithLeftImageName:(NSString *)imageNameLeftStr WithX:(float)X WithWidth:(float)Width WithHeight:(float)Height
{
    [self configHeadView];
    self.view.backgroundColor = XZHILBJ_colour;
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(X,5+self.num,Width,Height);
    [_backBtn addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameLeftStr]] forState:UIControlStateNormal];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 44);
    [button addTarget:self action:@selector(backUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:_backBtn];
}
#pragma mark - 增加仅为图标的rightBarBtnItem
- (void)addRightBarBtnItem:(NSString*)imageNameRightStr WithXtoRight:(float)X WithWidth:(float)Width WithHeight:(float)Height
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(iPhone_width - X, ios7jj+(44-Height)/2, Width, Height);
    //[_rightBtn.titleLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
    [_rightBtn addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imageNameRightStr]] forState:UIControlStateNormal];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(iPhone_width- 80, 0, 80, 44);
    [button addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:_rightBtn];
    
}

- (void)configHeadView
{
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+self.num)];
    titleIV.userInteractionEnabled = YES;
    titleIV.backgroundColor = RGBA(255, 115, 4, 1);
    titleIV.tag = 601;
    [self.view addSubview:titleIV];
}

- (void)configHeadViewGR
{
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+self.num)];
    titleIV.userInteractionEnabled = YES;
    titleIV.backgroundColor = [UIColor whiteColor];
    titleIV.tag = 601;
    
    UIView *vl = [[UIView alloc] initWithFrame:CGRectMake(0, titleIV.frame.size.height-1, [[UIScreen mainScreen] bounds].size.width, 1)];
    vl.backgroundColor = RGB(231, 231, 231);
    [titleIV addSubview:vl];
    
    [self.view addSubview:titleIV];
}

- (void)configHeadView:(UIColor *)color
{
    UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+self.num)];
    titleIV.userInteractionEnabled = YES;
    titleIV.backgroundColor = color;
    titleIV.tag = 601;
    
    
    [self.view addSubview:titleIV];
}

#pragma mark - 父类方法 如果自雷有新功能那么在子类中重写
- (void)backUp:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickRightBtn:(UIButton *)sender
{
    NSLog(@"点击右边调到方法");
}

-(void)addTitleLabelGR:(NSString*)title{
    
    UILabel *titleLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(50, 10+20, kMainScreenWidth-50*2, 25)] ;
    [titleLabel4 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel4 setBackgroundColor:[UIColor clearColor]];
    [titleLabel4 setTextColor:RGB(74, 74, 74)];
    [titleLabel4 setFont:[UIFont fontWithName:Zhiti size: 18]];
    [titleLabel4 setText:title];
    [self.view addSubview:titleLabel4];
}

-(void)addTitleLabel:(NSString*)title{
    
    UILabel *titleLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(50, 10+20, kMainScreenWidth-50*2, 25)] ;
    [titleLabel4 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel4 setBackgroundColor:[UIColor clearColor]];
    [titleLabel4 setTextColor:[UIColor whiteColor]];
    [titleLabel4 setFont:[UIFont fontWithName:Zhiti size: 17]];
    [titleLabel4 setText:title];
    [self.view addSubview:titleLabel4];
}

-(void)addTitleLabel:(NSString*)title color:(UIColor *)color{
    
    UILabel *titleLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(50, 10+20, kMainScreenWidth-50*2, 25)] ;
    [titleLabel4 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel4 setBackgroundColor:[UIColor clearColor]];
    [titleLabel4 setTextColor:color];
    [titleLabel4 setFont:[UIFont fontWithName:Zhiti size: 17]];
    [titleLabel4 setText:title];
    [self.view addSubview:titleLabel4];
}

-(UILabel *)addTitleLabel3:(NSString*)title{
    
    UILabel *titleLabel10 = [[UILabel alloc]initWithFrame:CGRectMake(30,10+self.num, 220, 25)] ;
    [titleLabel10 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel10 setBackgroundColor:[UIColor clearColor]];
    [titleLabel10 setTextColor:RGBA(209, 120, 4, 1)];
    [titleLabel10 setFont:[UIFont systemFontOfSize:17]];
    [titleLabel10 setText:title];
    [self.view addSubview:titleLabel10];
    
    UILabel *titleLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(29,9+self.num, 220, 25)] ;
    [titleLabel4 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel4 setBackgroundColor:[UIColor clearColor]];
    [titleLabel4 setTextColor:[UIColor whiteColor]];
    [titleLabel4 setFont:[UIFont systemFontOfSize:17]];
    [titleLabel4 setText:title];
    [self.view addSubview:titleLabel4];
    
    return titleLabel10;
    return titleLabel4;
}

- (void)addHomeTitleLabel:(NSString*)title secTitle:(NSString *)str{
    
    titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(77, 9+self.num, 120, 25)] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:Zhiti size: 17]];
    [titleLabel setText:title];
    [self.view addSubview:titleLabel];
    
    if (str.length==2) {
         titleLabel3  = [[UILabel alloc]initWithFrame:CGRectMake(168, 9+self.num, 50, 25)] ;
    }else{
       
         titleLabel3  = [[UILabel alloc]initWithFrame:CGRectMake(168, 9+self.num, 65, 25)] ;
    }
    
    [titleLabel3 setTextAlignment:NSTextAlignmentCenter];
    [titleLabel3 setBackgroundColor:[UIColor clearColor]];
    [titleLabel3 setTextColor:[UIColor whiteColor]];
    [titleLabel3 setFont:[UIFont fontWithName:Zhiti size: 15]];
    [titleLabel3 setText:str];
    titleLabel3.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:titleLabel3];
}

- (void)addQuanchengTitleLabel:(NSString*)title secTitle:(NSString *)str
{
    titleLabel= [[UILabel alloc]initWithFrame:CGRectMake(77, 9+self.num, 120, 25)] ;
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont fontWithName:Zhiti size: 18]];
    [titleLabel setText:title];
    [self.view addSubview:titleLabel];
    
    if (str.length==2) {
        titleLabel3  = [[UILabel alloc]initWithFrame:CGRectMake(185, 8+self.num, 50, 25)] ;
    }else{
        titleLabel3  = [[UILabel alloc]initWithFrame:CGRectMake(185, 8+self.num, 65, 25)] ;
    }
    
    [titleLabel3 setTextAlignment:NSTextAlignmentLeft];
    [titleLabel3 setBackgroundColor:[UIColor clearColor]];
    [titleLabel3 setTextColor:[UIColor whiteColor]];
    [titleLabel3 setFont:[UIFont fontWithName:Zhiti size: 15]];
    [titleLabel3 setText:str];
    [self.view addSubview:titleLabel3];
}

- (void)changeTExt:(NSString *)str secText:(NSString *)str2
{
    [titleLabel1 setText:str];
    [titleLabel setText:str];
    [titleLabel2 setText:str2];
    [titleLabel3 setText:str2];
}
#pragma mark - 右边按钮不带image,带文字的
- (void)addRightkBtn:(NSString*)imageName
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(iPhone_width-45,25,40,40);
    [_rightBtn.titleLabel setFont:[UIFont fontWithName:@"Courier" size:15]];
    [_rightBtn addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [_rightBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_rightBtn setTitle:imageName forState:UIControlStateNormal];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(iPhone_width-80, 0, 80, 44);
    [button addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [self.view addSubview:_rightBtn];
}

- (void)addRightkBtnGR:(NSString*)name{
    [self addRightButtonWithTitle:name Color:RGB(255, 163, 29)];
}

#pragma mark - 添加居中的标题（最多9个字）
- (void)addCenterTitle:(NSString *)titleString{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-162)*0.5, 10+self.num, 162, 25)] ;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:Zhiti size: 18]];
    [label setText:titleString];
    [self.view addSubview:label];
}

#pragma mark - 添加文字形式的右按钮
- (void)addRightButtonWithTitle:(NSString *)title{
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [rightBtn.titleLabel setTextColor:[UIColor whiteColor]];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    rightBtn.frame = CGRectMake(iPhone_width-70, ios7jj, 60, 44);
    [rightBtn addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)addRightButtonWithTitle:(NSString *)title Color:(UIColor *)color{
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    rightBtn.frame = CGRectMake(iPhone_width-70, ios7jj, 60, 44);
    [rightBtn addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)addRightButtonWithTitle:(NSString *)title Color:(UIColor *)color Font:(UIFont *)font{
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:font];
    [rightBtn setTitleColor:color forState:UIControlStateNormal];
    [rightBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    rightBtn.frame = CGRectMake(iPhone_width-20*title.length-10, ios7jj, 20*title.length, 44);
    [rightBtn addTarget:self action:@selector(onClickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
}

- (void)setRightBtnTitle:(NSString *)title
{
    [rightBtn setTitle:title forState:UIControlStateNormal];
}
- (void)first
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"backfirst" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
