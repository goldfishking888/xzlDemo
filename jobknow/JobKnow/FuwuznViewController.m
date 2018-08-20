//
//  FuwuznViewController.m
//  JobKnow
//
//  Created by king on 13-4-3.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "FuwuznViewController.h"

@interface FuwuznViewController ()
//iPhone的高度
#define NUM_PAGE 1

@end
@implementation FuwuznViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
    }
    
    return self;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
    scrolView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, 320, iPhone_height)];
    scrolView.contentSize=CGSizeMake(320*NUM_PAGE, iPhone_width);
    scrolView.pagingEnabled = YES;
    scrolView.bounces = NO;
    scrolView.delegate= self;
    scrolView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrolView];
    for (int i=0; i<NUM_PAGE; i++) {
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(320*(NUM_PAGE-1)+20, iPhone_height-90, 280, 40);
    [button setBackgroundColor:[UIColor orangeColor]];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.layer setCornerRadius:6];
    [button.layer setMasksToBounds:YES];
    [scrolView addSubview:button];
    [button addTarget:self action:@selector(removefuwu:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)removefuwu:(id)sender
{
    HomeViewController *homeVC = [[HomeViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [self.navigationController pushViewController:homeVC animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
