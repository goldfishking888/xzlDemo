//
//  CustomLabel.m
//  JobKnow
//
//  Created by faxin sun on 13-3-7.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)labelinitWithText:(NSString *)text X:(CGFloat)x Y:(CGFloat)y
{
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize autoSize = CGSizeMake(iPhone_width - x -10, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, size.width, size.height )];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    return label;
}

- (id)labelinitWithText2:(NSString *)text X:(CGFloat)x Y:(CGFloat)y
{
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    CGSize autoSize = CGSizeMake(iPhone_width - x -10, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y,iPhone_width, size.height + 10)];
    [label setTextColor:[UIColor redColor]];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    return label;
}

- (id)labelinitWithText3:(NSString *)text X:(CGFloat)x Y:(CGFloat)y fontSize:(CGFloat)sizeFont
{
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    CGSize autoSize = CGSizeMake(iPhone_width - x -10, MAXFLOAT);
    CGSize size = [text sizeWithFont:font constrainedToSize:autoSize lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y,iPhone_width, size.height + 10)];
    [label setTextColor:[UIColor redColor]];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = font;
    label.text = text;
    label.numberOfLines = 0;
    return label;
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
