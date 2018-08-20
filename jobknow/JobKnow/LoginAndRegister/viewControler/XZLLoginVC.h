//
//  XZLLoginVC.h
//  JobKnow
//
//  Created by WangJinyu on 2017/7/27.
//  Copyright © 2017年 lxw. All rights reserved.
//

#import "BaseViewController.h"

@interface XZLLoginVC : BaseViewController<UITextFieldDelegate>
{
    UIButton *weixin;
    UILabel *labelW;
    
    UIButton *qq;
    UILabel *labelQ;
    
    UIButton *sina;
    UILabel *labelS;
}

@property (nonatomic,strong)NSString * backType;//区别返回的地方

@end
