//
//  AboutWeViewController.h
//  JobKnow
//
//  Created by faxin sun on 13-3-26.
//  Copyright (c) 2013年 lxw. All rights reserved.
//
//背景 f3f3f3   f28908
#import <UIKit/UIKit.h>
@protocol upDatebb <NSObject>

@optional
-(void)upDatebb01:(BOOL)flag;
@end

@interface AboutWeViewController : BaseViewController<UIScrollViewDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CGSize newSize; //滑动尺寸
    UIButton *button;
    UIImage *infoImg;
    UITableView *mytableView;
    int num;
}

@property (nonatomic,retain)id<upDatebb>deleat;
@end
