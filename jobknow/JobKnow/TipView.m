//
//  TipView.m
//  JobKnow
//
//  Created by faxin sun on 13-4-11.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "TipView.h"

@implementation TipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (TipView *)defaultStander
{
    TipView *tips = nil;
    if (tips == nil) {
        tips = [[TipView alloc]initWithFrame:CGRectMake(0, 0, iPhone_width , iPhone_height)];
        tips.alpha = 0;
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(80, (iPhone_height - 200)/2, iPhone_width - 160, 150)];
        [v setBackgroundColor:[UIColor blackColor]];
        v.layer.cornerRadius = 6.0;
        [tips addSubview:v];
        
        
        UIImageView *ly = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recording_recording_indicator.png"]];
        ly.frame = CGRectMake(50, 20, 60, 60);
        
        //语音
        tips.label = [[UILabel alloc]initWithFrame:CGRectMake(15, 110, 130, 40)];
        tips.label.text = @"上滑取消发送";
        tips.label.textAlignment = NSTextAlignmentCenter;
        tips.label.font = [UIFont systemFontOfSize:12];
        tips.label.backgroundColor = [UIColor clearColor];
        tips.label.textColor= RGBA(220, 220, 220, 1);
        [v addSubview:ly];
        [v addSubview:tips.label];
        
        //时间
        tips.time = 0;
        tips.s =  [[UILabel alloc]initWithFrame:CGRectMake(30, 80,  100, 40)];
        tips.s.text = @"00\"/60\"";
        tips.s.textAlignment = NSTextAlignmentCenter;
        tips.s.font = [UIFont boldSystemFontOfSize:17];
        tips.s.backgroundColor = [UIColor clearColor];
        tips.s.textColor= [UIColor whiteColor];

        
        [v addSubview:tips.s];
        [v addSubview:ly];
        [v addSubview:tips.label];
        
    }
    return tips;
    
}

- (void)recordTime:(id)sender
{
    self.time ++;
    NSString *t = nil;
    if (self.time >= 10) {
        t = [[NSString alloc] initWithFormat:@"%d\"/60\"",self.time];
    }else
    {
         t = [[NSString alloc] initWithFormat:@"0%d\"/60\"",self.time];
    }
    
    self.s.text = t;
    if (self.time == 60) {
        [self.timer invalidate];
        [self.delegate recordTimeOut];
        //[self hidden];
    }
}

- (void)show
{
    
     self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordTime:) userInfo:nil repeats:YES];
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0, 1.0);
         self.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         //[self hidden];
                     }];
    
}

- (void)hidden
{
    self.time = 0;
    self.s.text = @"00\"/60\"";
    [self.timer invalidate];
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0, 1.0);
         self.alpha = 0;
     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (id)initFinishRecord
{
    self = [super initWithFrame:CGRectMake(0, 0, iPhone_width, iPhone_height)];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(60, (iPhone_height - 150)/2, 200, 150)];
    v.backgroundColor = RGBA(70, 70, 70, 1);
    v.layer.cornerRadius = 6.0;
    self.alpha = 0;
    [self addSubview:v];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn.frame = CGRectMake(27, 100, 60, 30);
    [self.leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.leftBtn setBackgroundImage:[UIImage imageNamed:@"sendly.png"] forState:UIControlStateNormal];
    
    self.p = YES;
    //[self.leftBtn setBackgroundImage:[UIImage imageNamed:@"button_big_grey_highlighted.png"] forState:UIControlStateHighlighted];
    [self.leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(cancelSend:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:self.leftBtn];
    
    _play = [UIButton buttonWithType:UIButtonTypeCustom];
    [_play setBackgroundImage:[UIImage imageNamed:@"recording_playbutton_background.png"] forState:UIControlStateNormal];
    [_play.titleLabel setFont:[UIFont systemFontOfSize:15]];
    _play.frame = CGRectMake(70, 20, 60, 60);
    [_play setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_play addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:_play];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"sendcancel.png"] forState:UIControlStateNormal];
    [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.rightBtn.frame = CGRectMake(114, 100, 60, 30);
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(sendly:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:self.rightBtn];
    
    return self;
}

- (void)cancelSend:(id)sender
{
    [self.delegate leftBtnAndRightClick];
}

- (void)sendly:(id)sender
{
    [self.delegate rightBtnAndRightClick];
}

- (void)playRecord:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.p) {
        [self.delegate clickPlayBtn:YES];
        [btn setBackgroundImage:[UIImage imageNamed:@"recording_stopplayingbutton_background.png"] forState:UIControlStateNormal];
        self.p = NO;
    }
    else
    {
        [self.delegate clickPlayBtn:NO];
         [btn setBackgroundImage:[UIImage imageNamed:@"recording_playbutton_background.png"] forState:UIControlStateNormal];
        self.p = YES;
    }
}

- (id)initWithTitleLoad
{
    self = [super initWithFrame:CGRectMake(0, 0, iPhone_width, iPhone_height)];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(100, (iPhone_height - 100)/2, iPhone_width - 200, 100)];
    v.backgroundColor = [UIColor blackColor];
    v.layer.cornerRadius = 6.0;
    self.alpha = 0;
    [self addSubview:v];
    
    
    self.actiview = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.actiview.frame = CGRectMake(45, 20, 30, 30);
    
    _load = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, 60, 20)];
    _load.text = @"加载中...";
    _load.textAlignment = NSTextAlignmentCenter;
    [_load setTextColor:[UIColor whiteColor]];
    _load.font = [UIFont boldSystemFontOfSize:14];
    [_load setBackgroundColor:[UIColor clearColor]];
    [v addSubview:_load];
    [v addSubview:self.actiview];
    
    return self;
}

- (void)showPlay
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0, 1.0);
         self.alpha = 1.0;
     }
    ];
}

- (void)showTipView
{
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         //self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1, 1.1);
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         self.alpha = 0.7;
     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self.actiview startAnimating];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.5 animations:
    ^(void){
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1, 1.1);
        self.alpha = 0;
    }
completion:^(BOOL finished){
    
}];

    [self.actiview stopAnimating];
}

- (double)widthWithString:(NSString *)str width:(double)width
{
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    CGSize expectedLabelSizeOne = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingMiddle];
    return expectedLabelSizeOne.height;
}


@end
