    //
//  test.m
//  canvas
//
//  Created by frank on 11-5-28.
//  Copyright 2011 wongf70@gmail.com All rights reserved.
//

#import "WProgressBar.h"

@implementation WProgressBar

-(id)initWithFrame:(CGRect)aFrame frameColor:(UIColor*)aFrameColor barColor:(UIColor*)aBarColor
{
	self=[super initWithFrame:aFrame];
	if (self) 
	{
		gap=aFrame.size.height/6.0;
		self.backgroundColor=[UIColor clearColor];
		inner=[[UIView alloc]initWithFrame:CGRectMake(gap, gap, aFrame.size.width-gap*2.0, aFrame.size.height-gap*2.0)];
		inner.layer.cornerRadius=aFrame.size.height/2.0-gap;
		inner.layer.borderColor=[UIColor clearColor].CGColor;
		inner.backgroundColor=[aBarColor colorWithAlphaComponent:.5];
		inner.frame=CGRectMake(gap, gap, 0, aFrame.size.height-gap*2.0);
		outter=[[UIView alloc]initWithFrame:CGRectMake(0, 0, aFrame.size.width, aFrame.size.height)];
		outter.backgroundColor=[UIColor clearColor];
		outter.layer.cornerRadius=aFrame.size.height/2.0;
		outter.layer.borderWidth=2.0;
		outter.layer.borderColor=[aFrameColor colorWithAlphaComponent:.6].CGColor;
		[self addSubview:inner];
		[self addSubview:outter];
		
	}
	return self;
}

-(void)setProgress:(float)progress
{
	progress=progress<0?0:progress;
	progress=progress>1?1:progress;
	inner.frame=CGRectMake(gap, gap, progress*(self.frame.size.width-gap*2.0), self.frame.size.height-gap*2.0);
}

- (void)dealloc {
	[inner removeFromSuperview];
	[outter removeFromSuperview];
}


@end
