//
//  SelectIdentityViewController.m
//  JobKnow
//
//  Created by Jiang on 15/10/19.
//  Copyright © 2015年 lxw. All rights reserved.
//

#import "SelectIdentityViewController.h"
#import "VerifyPhoneViewController.h"

#define ApplicantBtnTag 91038
#define HrBtnTag 91039
#define HunterBtnTag 91040
#define TypeBtnWidth 150

@interface SelectIdentityViewController (){
    UIButton *_applicantBtn;// 求职者
    UIButton *_hrBtn;// HR
    UIButton *_hunterBtn;// 兼职猎手
    OLGhostAlertView *_ghost;
}

@end

@implementation SelectIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBtn];
    [self addCenterTitle:@"选择身份"];
    self.view.backgroundColor = kBackgroundColor;
    
    _registerModel = [[RegisterModel alloc]init];
    _ghost = [[OLGhostAlertView alloc] init];
    
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ios7jj+44, iPhone_width, 80)];
    explainLabel.text = @"请选择您的身份";
    [explainLabel setFont:[UIFont systemFontOfSize:16]];
    explainLabel.textColor = kFontColorGray;
    [explainLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:explainLabel];
    
    // 求职者
    _applicantBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_applicantBtn setFrame:CGRectMake((iPhone_width-TypeBtnWidth)/2, ios7jj+44+80, TypeBtnWidth, 40)];
    NSAttributedString *normalAppAttrStr = [[NSAttributedString alloc] initWithString:@"我是求职者" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor orangeColor],NSForegroundColorAttributeName,nil]];
    NSAttributedString *selectAppAttrStr = [[NSAttributedString alloc] initWithString:@"我是求职者 ✓" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor orangeColor],NSForegroundColorAttributeName,nil]];
    [_applicantBtn setAttributedTitle:normalAppAttrStr forState:UIControlStateNormal];
    [_applicantBtn setAttributedTitle:selectAppAttrStr forState:UIControlStateSelected];
    [_applicantBtn setBackgroundColor:[UIColor whiteColor]];
    [_applicantBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _applicantBtn.tag = ApplicantBtnTag;
    [_applicantBtn.layer setCornerRadius:5];
    [_applicantBtn.layer setBorderWidth:1];
    [_applicantBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.view addSubview:_applicantBtn];
    
    // HR
    _hrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hrBtn setFrame:CGRectMake((iPhone_width-TypeBtnWidth)/2, ios7jj+44+80+60, TypeBtnWidth, 40)];
    NSAttributedString *normalHRAttrStr = [[NSAttributedString alloc] initWithString:@"我是人事经理" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor orangeColor],NSForegroundColorAttributeName,nil]];
    NSAttributedString *selectHRAttrStr = [[NSAttributedString alloc] initWithString:@"我是人事经理 ✓" attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,[UIColor orangeColor],NSForegroundColorAttributeName,nil]];
    [_hrBtn setAttributedTitle:normalHRAttrStr forState:UIControlStateNormal];
    [_hrBtn setAttributedTitle:selectHRAttrStr forState:UIControlStateSelected];
    [_hrBtn setBackgroundColor:[UIColor whiteColor]];
    [_hrBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _hrBtn.tag = HrBtnTag;
    [_hrBtn.layer setCornerRadius:5];
    [_hrBtn.layer setBorderWidth:1];
    [_hrBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.view addSubview:_hrBtn];
    
    // 下一步
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, ios7jj+44+80+60+60+10, iPhone_width-20, 40);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor orangeColor]];
    [nextBtn.layer setCornerRadius:5];
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - 选择身份
- (void)buttonClick:(UIButton *)sender{
    if (sender.tag == ApplicantBtnTag) {
        if (_applicantBtn.isSelected == NO) {
            _applicantBtn.selected = YES;
            [_applicantBtn.layer setBorderColor:[[UIColor orangeColor] CGColor]];
            _hrBtn.selected = NO;
            [_hrBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            _hunterBtn.selected = NO;
            [_hunterBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        }else{
            _applicantBtn.selected = NO;
            [_applicantBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        }
    }else if(sender.tag == HrBtnTag){
        if (_hrBtn.isSelected == NO) {
            _applicantBtn.selected = NO;
            [_applicantBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            _hrBtn.selected = YES;
            [_hrBtn.layer setBorderColor:[[UIColor orangeColor] CGColor]];
            _hunterBtn.selected = NO;
            [_hunterBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        }else{
            _hrBtn.selected = NO;
            [_hrBtn.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        }

    }
}

#pragma mark - 下一步
- (void)nextBtnClick{
    if (!(_applicantBtn.isSelected||_hrBtn.isSelected||_hunterBtn.isSelected)) {
        _ghost.message = @"请选择您的身份";
        _ghost.position = OLGhostAlertViewPositionCenter;
        [_ghost show];
        return;
    }
    if (_applicantBtn.isSelected) {
        _registerModel.registType = @"1";
    }else if(_hrBtn.isSelected){
        _registerModel.registType = @"2";
    }
    
    VerifyPhoneViewController *vc = [[VerifyPhoneViewController alloc]init];
    vc.registerModel = _registerModel;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
