//
//  Dialogue.m
//  JobKnow
//
//  Created by faxin sun on 13-4-19.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "Dialogue.h"

@implementation Dialogue

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImage = [[UIImageView alloc] initWithFrame:frame];
        self.backgroundImage.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.backgroundImage.image = [UIImage imageNamed:@""];
        [self addSubview:self.backgroundImage];
        
        self.autoresizesSubviews = YES;
        
        //对话框背景
        self.inputbg = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, iPhone_width - 100, frame.size.height - 10)];
        self.inputbg.image = [UIImage imageNamed:@""];
        [self addSubview:self.inputbg];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 5, iPhone_width - 100, frame.size.height - 10)];
        self.textView.delegate = self;
        [self addSubview:self.textView];
        
    }
    return self;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
