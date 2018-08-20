//
//  HR_CheckIDModelViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/8/14.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "HR_CheckIDModelViewController.h"

@interface HR_CheckIDModelViewController ()

@end

@implementation HR_CheckIDModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackBtn];
    [self addCenterTitle:@"身份证明材料模板"];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44 + (ios7jj), self.view.frame.size.width, 200)];
    imageV.image = [UIImage imageNamed:@"card_demo"];
    [self.view addSubview:imageV];
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
