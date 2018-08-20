//
//  test.h
//  canvas
//
//  Created by frank on 11-5-28.
//  Copyright 2011 wongf70@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface WProgressBar : UIView {
	UIView*outter;
	UIView*inner;
	float gap;
}
-(id)initWithFrame:(CGRect)aFrame frameColor:(UIColor*)aFrameColor barColor:(UIColor*)aBarColor;
-(void)setProgress:(float)progress;
@end
