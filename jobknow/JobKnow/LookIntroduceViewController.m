//
//  LookIntroduceViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "LookIntroduceViewController.h"

@interface LookIntroduceViewController ()

@end

@implementation LookIntroduceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"介绍页"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"介绍页"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:RGBA(255, 115, 4, 1)];
    scrolView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, 320, iPhone_height)];
    [scrolView setContentSize:CGSizeMake(320*2, iPhone_width)];
    scrolView.pagingEnabled = YES;
    scrolView.bounces = NO;
    scrolView.delegate= self;
    scrolView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrolView];
    
    for (int i=0; i<2; i++) {
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(320*i,0, 320, iPhone_height)];
        if (i == 0) {
            
            [imageview setBackgroundColor:[UIColor whiteColor]];
            if (iPhone_5Screen) {
                [imageview setImage:[UIImage imageNamed:@"default1-568h@2x.png"]];
            }else{
                [imageview setImage:[UIImage imageNamed:@"default1.png"]];
            }
            
        }else if (i == 1){
            [imageview setBackgroundColor:[UIColor whiteColor]];
            if (iPhone_5Screen) {
                [imageview setImage:[UIImage imageNamed:@"default2-568h@2x.png"]];
            }else{
                [imageview setImage:[UIImage imageNamed:@"default2.png"]];
            }
            
        }
        [scrolView addSubview:imageview];
    }
    
    
    // UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(1050, 370, 150, 55)];
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
   button.frame = CGRectMake(320*1+20, iPhone_height-90, 280, 40);
    [scrolView addSubview:button];
  //  [button setTitle:@"开启神器" forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(removefuwu:) forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
}
-(void)removefuwu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
