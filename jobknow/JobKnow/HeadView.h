//
//  HeadView.h
//  JobKnow
//
//  Created by Apple on 14-3-3.
//  Copyright (c) 2014年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myButton.h"
@class HeadView;

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view;
@end

@interface HeadView : UIView
{
    BOOL open;
    NSInteger section;
    myButton* backBtn;
}

@property(nonatomic,assign)BOOL open;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,strong)myButton* backBtn;
@property(nonatomic,assign)id<HeadViewDelegate> delegate;
@end