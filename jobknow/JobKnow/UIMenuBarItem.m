//
//  UIMenuItem.m
//  TesdXcodeUserGuideDemo
//
//  Created by xd.su on 13-2-19.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "UIMenuBarItem.h"
#import <QuartzCore/QuartzCore.h>

@interface UIMenuBarItem ()

- (void)setup;
- (void)layOutSubviews;

@end

@implementation UIMenuBarItem

@synthesize title = _title,number = _number;

- (id)initWithTitle:(NSString *)title
             target:(id)target
              image:(UIImage *)image
             action:(SEL)action
{
    if(self = [super initWithFrame:CGRectZero]){
        
        _title = [NSString stringWithFormat:@"%@", title] ;
        _image = [UIImage imageWithCGImage:image.CGImage] ;
        _action = action;
        _target = target ;
        
        _containView = [[UIControl alloc] initWithFrame:CGRectZero];
        
        
        _imageView = [[UIImageView alloc] initWithImage:image];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.text = title;
        
        [self addSubview:_imageView];
        [self addSubview:_titleLabel];
        
        _sizeValue = ([UIScreen mainScreen].bounds.size.width - 40.0f)/3.0f;
        
        [self setup];
        
    }
    return self;
}

- (void)setup
{
    _containView.backgroundColor = [UIColor clearColor];
    
    [_containView addTarget:self
                     action:@selector(addHighlight)
           forControlEvents: UIControlEventTouchDown];
    
    [_containView addTarget:self
                     action:@selector(removeHighlight)
           forControlEvents: UIControlEventTouchCancel | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self layOutSubviews];
    
}

- (void)addHighlight
{
    _containView.backgroundColor = [UIColor colorWithRed:1. green:.5 blue:0. alpha:.8];
}

- (void)removeHighlight
{
    _containView.backgroundColor = [UIColor clearColor];
}



- (void)layOutSubviews
{
    _containView.frame = CGRectMake(0, 0, _sizeValue, _sizeValue);
    self.frame = CGRectMake(10, 0, _sizeValue, _sizeValue);
    _imageView.center = CGPointMake(_containView.center.x,
                                    _containView.center.y-10.f);
    
    _titleLabel.frame = CGRectMake(2,
                                   _containView.bounds.size.height-25.0f,
                                   _containView.bounds.size.width-4,
                                   25.0f);
    
}


@end
