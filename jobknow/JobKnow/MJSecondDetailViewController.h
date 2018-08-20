//
//  MJSecondDetailViewController.h
//  MJPopupViewControllerDemo
//
//  Created by Martin Juhasz on 24.06.12.
//  Copyright (c) 2012 martinjuhasz.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
@protocol MJSecondPopupDelegate;
@interface MJSecondDetailViewController : UIViewController<UIGestureRecognizerDelegate>
{
    UIButton *button01;
    UIButton *button02;
    BOOL isSchol;
    BOOL isXc;
    
}
@property (assign, nonatomic) id <MJSecondPopupDelegate>delegate;
@property (retain,nonatomic)UILabel *label_1;
@property (retain,nonatomic)UILabel *label_2;
@property (retain,nonatomic)UILabel *label2;
@property (retain,nonatomic)UILabel *label_3;
@property (retain,nonatomic)UILabel *label3;
@property (retain ,nonatomic) NSString *name_1;
@property (retain ,nonatomic) NSString *name_2;
@property (retain ,nonatomic) NSString *name_3;
@property (assign ,nonatomic) NSInteger butTag;
@property (nonatomic,retain)NSMutableArray *xcAry;
@property (nonatomic,retain)NSMutableArray *xyAry;
@property (nonatomic,retain)NSMutableArray *resouAty;

@end


@protocol MJSecondPopupDelegate<NSObject>
@optional
- (void)cancelButtonClicked:(MJSecondDetailViewController*)secondDetailViewController;
@end