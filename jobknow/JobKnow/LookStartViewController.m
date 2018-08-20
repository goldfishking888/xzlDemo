//
//  LookStartViewController.m
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "LookStartViewController.h"

@interface LookStartViewController ()

@end

@implementation LookStartViewController

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
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"起始页"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"起始页"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width, iPhone_height)];
    if (iPhone_5Screen) {
         img.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }else{
         img.image = [UIImage imageNamed:@"Default@2x.png"];
    }
   
    [self.view addSubview:img];
    
//    if (iPhone_5Screen) {
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-568h@2x.png"]];
//    }else{
//        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default@2x.png"]];
//    }
    //加手势退出
    UITapGestureRecognizer *twoFingersTwoTaps =
    	  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingersTwoTaps)] ;
   	[twoFingersTwoTaps setNumberOfTapsRequired:1];
  	[twoFingersTwoTaps setNumberOfTouchesRequired:1]; //一个指头
	[[self view] addGestureRecognizer:twoFingersTwoTaps];
}
- (void)twoFingersTwoTaps
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
