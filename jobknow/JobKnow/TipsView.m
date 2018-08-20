//
//  TipsView.m
//  TestStatic
//
//  Created by faxin sun on 13-5-3.
//  Copyright (c) 2013年 zouyl. All rights reserved.
//

#import "TipsView.h"

@implementation TipsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (TipsView *)standerDefault
{
    static TipsView *tip = nil;
    if (tip == nil) {
        tip = [[TipsView alloc]initWithFrame:CGRectMake(70, (iPhone_height - 80)/2, iPhone_width - 120, 110)];
        
        tip.backgroundColor = [UIColor blackColor];
        tip.alpha = 0;
        tip.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0, 1.0);
        tip.layer.cornerRadius = 6.0;
        tip.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 36, iPhone_width - 140, 40)];
        tip.label.numberOfLines = 0;
       
        
        //tip.label.text = @"发送成功";
        tip.label.textAlignment = NSTextAlignmentCenter;
        tip.label.font = [UIFont boldSystemFontOfSize:16];
        tip.label.backgroundColor = [UIColor clearColor];
        tip.label.textColor= [UIColor whiteColor];
        [tip addSubview:tip.label];
        

    }
    return tip;
}

//根据宽度和字符串，返回所需要的高度
+ (CGSize)textLableHeightWithString:(NSString *)str Width:(CGFloat)width
{
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    CGSize expectedLabelSizeOne = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingMiddle];
    return expectedLabelSizeOne;
}



- (void)showTipString:(NSString *)string
{

    self.center = CGPointMake(iPhone_width/2,([[UIScreen mainScreen] bounds].size.height/2));
    self.label.text = string;
    [UIView animateWithDuration:0.2 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
         self.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                        [self bounceOutAnimationStoped];
                     }];
}

- (void)bounceOutAnimationStoped
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         
         self.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         //[self bounceInAnimationStoped];
                     }];
    [self performSelector:@selector(start) withObject:nil afterDelay:2];
    
}


- (void)start
{
    self.alpha = 0;
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.6, 0.6);
    
}

@end
