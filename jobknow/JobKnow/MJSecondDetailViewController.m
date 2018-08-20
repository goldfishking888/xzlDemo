//
//  MJSecondDetailViewController.m
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import "MJSecondDetailViewController.h"
#import "MapViewController.h"
#import "UIViewController+MJPopupViewController.h"
@interface MJSecondDetailViewController ()

@end

@implementation MJSecondDetailViewController

@synthesize delegate;
-(void)viewDidLoad{
   
    isSchol = YES;
    isXc = YES;
//    NSLog(@"tag =======%d",self.butTag);
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    imgview.image = [UIImage imageNamed:@"tan_bg.png"];
    imgview.userInteractionEnabled = YES;
    [self.view addSubview:imgview];
    self.label_1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 300, 25)];
    self.label_1.backgroundColor = [UIColor clearColor];
    [self.label_1 setFont:[UIFont boldSystemFontOfSize:17]];
    [self.label_1 setTextColor:[UIColor whiteColor]];
    
   // self.xcAry
    //self.xyAry
  
  
    
    NSString *name = [self.resouAty objectAtIndex:self.butTag];
    
    for (NSString *str in self.xyAry) {
        if ([name isEqualToString:str]) {
            
            isSchol = NO;
            break;
        }else{
            
            isSchol = YES;
        }
    }
    
    // 电话  就业办
    NSString *laa = [[NSString alloc]init];
    if ([self.name_2 isEqualToString:@""]) {
        laa = @"";
    }else{
        if (!isSchol ) {
            laa = @"就业办:";
        }else{
            laa = @"电话:";
        }
    }
    self.label2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, laa.length*20, 25)];
    self.label2.backgroundColor = [UIColor clearColor];
    self.label2.text = laa;
    
    [self.view addSubview:self.label2];
    
    
    self.label_2 = [[UILabel alloc]initWithFrame:CGRectMake(laa.length*20, 50, 280, 25)];
    self.label_2.backgroundColor = [UIColor clearColor];
    [self.label2 setFont:[UIFont boldSystemFontOfSize:16]];
    self.label_2.userInteractionEnabled = YES;
    self.label_2.tag = 1000;
//开始截取
    NSString *la = [[NSString alloc]init];
    if ([self.name_2 isEqualToString:@""]) {
       la = @"";
    }else{
        la= self.name_2;
    }
    self.label_2.text = la;
    
    [self.label_2 setTextColor:[UIColor blueColor]];
    [self.label_2 setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:self.label_2];
    
   
    
    for (NSString *str in self.xcAry) {
        if ([name isEqualToString:str]) {
//            NSLog(@"在里面");
            isXc = NO;
            break;
        }else{
//            NSLog(@"不在里面");
            isXc = YES;
        }
    }
    
    //网址 地址
    NSString *laa1 = [[NSString alloc]init];
    if ([self.name_3 isEqualToString:@""]) {
        laa1 = @"";
    }else{
        if (!isXc) {
            laa1 = @"地址:";
        }else if (!isSchol){
            laa1 = @"学校主页:";
        }else{
            laa1= @"网址:";
        }
    }

    self.label3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 85, laa1.length*20, 25)];
    self.label3.backgroundColor = [UIColor clearColor];
    self.label3.text = laa1;
    [self.label3 setFont:[UIFont boldSystemFontOfSize:16]];
    [self.view addSubview:self.label3];
    
    NSString *la2 = [[NSString alloc]init];
    if ([self.name_3 isEqualToString:@""]) {
        la2 = @"";
    }else{
       
        la2= self.name_3;
    }
    
    self.label_3 = [[UILabel alloc]initWithFrame:CGRectMake(laa1.length*20, 70, 290-laa1.length*20, 55)];
    self.label_3 .backgroundColor = [UIColor clearColor];
    self.label_3.userInteractionEnabled = YES;
    
    self.label_3.text = la2;
    [self.label_3 setTextColor:[UIColor grayColor]];
    [self.label_3 setFont:[UIFont systemFontOfSize:15]];
    self.label_3.numberOfLines = 0;
    self.label_3.tag = 2000;
    [self.view addSubview:self.label_3];
    [imgview addSubview:self.label_1];
    self.label_1.text = self.name_1;
    
  
   UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    [self.label_2 addGestureRecognizer:singleRecognizer];

    UITapGestureRecognizer* singleRecognizer2;
    singleRecognizer2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SingleTap2:)];
    singleRecognizer2.numberOfTapsRequired = 1;
    [self.label_3 addGestureRecognizer:singleRecognizer2];
    
}
//电话方法
- (void)SingleTap:(UITapGestureRecognizer *)sender  
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    UILabel *label = (UILabel *)[self.view viewWithTag:[singleTap view].tag];
    if (![label.text isEqualToString:@""]) {
        NSString *urlStr = [[NSString alloc] initWithFormat:@"tel:%@",label.text];
        NSURL *url = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication] openURL:url];
    }else{}
}
//网址 定位 
- (void)SingleTap2:(UITapGestureRecognizer *)sender
{
    UITapGestureRecognizer *singleTap1 = (UITapGestureRecognizer *)sender;
    UILabel *label2 = (UILabel *)[self.view viewWithTag:[singleTap1 view].tag];
    NSLog(@"++++++++%@",label2);
    if ( [self.label3.text isEqualToString:@"地址:"]) {
        MapViewController *mapVC = [[MapViewController alloc] init];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:label2.text forState:(UIControlStateNormal)];
        mapVC.address = button;
        //[self presentModalViewController:mapVC animated:YES];
    }else{
        if (![label2.text isEqualToString:@""]) {
            WebViewController *webVC = [[WebViewController alloc] init];
           
            webVC.urlStr = label2.text;
          //  [self presentModalViewController:webVC animated:YES];

        }else{
        }
              
    }
}

- (void)dismisViewCon
{
   
   // [self dismissModalViewControllerAnimated:YES];
   // [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomBottom];
   // [self removeFromParentViewController];
}

@end
