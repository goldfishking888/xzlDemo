//
//  LDProgressView.m
//  LDProgressView
//
//  Created by Christian Di Lorenzo on 9/27/13.
//  Copyright (c) 2013 Light Design. All rights reserved.
//

#import "LDProgressView.h"
#import "UIColor+RGBValues.h"
#import "GRBookerModel.h"
#import "GRCityInfoNumsModel.h"
#import "GRBookerAndCityInfo.h"

@interface LDProgressView ()
@property (nonatomic) CGFloat offset;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) CGFloat stripeWidth;
@property (nonatomic, strong) UIImage *gradientProgress;
@property (nonatomic) CGSize stripeSize;

@property (nonatomic, strong) NSString *progressTextOverride;
@property (nonatomic, strong) UIColor *progressTextColorOverride;

// Animation of progress
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic) CGFloat progressToAnimateTo;
@end

@implementation LDProgressView{
    GRCityInfoNumsModel *model_cityInfo;
    GRBookerModel *model_booker;
}
@synthesize animate=_animate, color=_color;
@synthesize sourceArray;
@synthesize strNum;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initialize];
        
        model_cityInfo= [GRBookerAndCityInfo standerDefault].model_cityInfo ;
        model_booker= [GRBookerAndCityInfo standerDefault].model_booker;

        sourceArray=[[NSArray alloc]init];
        
        
        NSString *cityNameStr=model_booker.bookLocationName;
        
        if (cityNameStr.length>=4) {
            
            cityNameStr=[cityNameStr substringWithRange:NSMakeRange(0,4)];
        }
        
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:
                                 
                                 [NSString stringWithFormat:@"正在搜索%@全部%@个招聘网站",cityNameStr,model_cityInfo.website],
                                 [NSString stringWithFormat:@"正在搜索%@全部%@个现场招聘",cityNameStr,model_cityInfo.fair],
                                 [NSString stringWithFormat:@"正在搜索%@全部%@个报纸",cityNameStr,model_cityInfo.newspaper],
                                 [NSString stringWithFormat:@"正在搜索%@全部%@个校园招聘",cityNameStr,model_cityInfo.school],
                                 [NSString stringWithFormat:@"正在搜索%@全部%@个猎头招聘",cityNameStr,model_cityInfo.company],
                                 [NSString stringWithFormat:@"正在搜索小职了·%@企业库全部",cityNameStr],
                                 
                                 nil];
        
        lab=[[UILabel alloc]init];
        lab.frame=CGRectMake(0,-31,self.frame.size.width,15);
        lab.backgroundColor=[UIColor clearColor];
        lab.font=[UIFont boldSystemFontOfSize:14];
        lab.textColor = RGB(72, 72, 72);
        lab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lab];
        
        for (int i =0; i<6; i++) {
            
            myLabel = [[RTLabel alloc]initWithFrame:CGRectMake(40, 35.5+i*30                                                                              , 250, 30)];
            myLabel.text = [array objectAtIndex:i];
            myLabel.backgroundColor = [UIColor clearColor];
            myLabel.font = [UIFont systemFontOfSize:14];
            myLabel.tag = i*((int)(100/6))+(int)(100/6);
            myLabel.alpha = 0.7;
            [self addSubview:myLabel];
            
            
            
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 36+i*30, 16, 16)];
            imgView.image = [UIImage imageNamed:@"weiwancheng"];
            imgView.tag =i*((int)(100/6))+(int)(100/6)+200;
            [self addSubview:imgView];
            
            UIView *view_line=[[UIView alloc]init];
            view_line.frame=CGRectMake(imgView.frame.origin.x+imgView.frame.size.width/2-1,imgView.bottom+2,2,8);
            view_line.backgroundColor=RGB(255, 163, 29);
            view_line.tag = i*((int)(100/6))+(int)(100/6) +300;
            view_line.hidden = YES;
            [self addSubview:view_line];
        }
        
    }
    return self;
}

- (void)drawRightAlignedLabelInRect:(CGRect)rect {
    
    if (rect.size.width > 40) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont boldSystemFontOfSize:17];
        UIColor *baseLabelColor = self.color? [UIColor blackColor] : [UIColor whiteColor];
        label.textColor = [baseLabelColor colorWithAlphaComponent:1.0];
        [label drawTextInRect:CGRectMake(6, 0, rect.size.width-12, rect.size.height)];
        
        int num = self.progress*100;
        
        RTLabel *la01 = (RTLabel *)[self viewWithTag:num];
        NSString *str=model_booker.bookLocationName;
        if (str.length>=4) {
            str =[str substringWithRange:NSMakeRange(0,4)];
        }
        UIView *view_line;
        switch (num) {
            case (int)(100/6):
                la01.frame=CGRectMake(40, 35.5, 250, 30);
                la01.text = [NSString stringWithFormat:@"%@全部<font color='#f76806'>%@</font>个招聘网站已搜索完成",str,model_cityInfo.website];
                
                break;
            case (int)(100/6)*2:
                la01.frame=CGRectMake(40, 35.5+30, 250, 30);
                la01.text = [NSString stringWithFormat:@"%@全部<font color='#f76806'>%@</font>个现场招聘已搜索完成",str,model_cityInfo.fair];
                view_line = [self viewWithTag:(100/6)+300];
                view_line.hidden = NO;
                break;
            case (int)(100/6)*3:
                la01.frame=CGRectMake(40, 35.5+2*30, 250, 30);
                la01.text = [NSString stringWithFormat:@"%@全部<font color='#f76806'>%@</font>个报纸已搜索完成",str,model_cityInfo.newspaper];
                view_line = [self viewWithTag:(100/6)*2+300];
                view_line.hidden = NO;
                break;
            case (int)(100/6)*4:
                la01.frame=CGRectMake(40, 35.5+3*30, 255, 30);
                la01.text = [NSString stringWithFormat:@"%@全部<font color='#f76806'>%@</font>个校园招聘已搜索完成",str,model_cityInfo.school];
                view_line = [self viewWithTag:(100/6)*3+300];
                view_line.hidden = NO;
                break;
            case (int)(100/6)*5:
                la01.frame=CGRectMake(40, 35.5+4*30, 255, 30);
                la01.text = [NSString stringWithFormat:@"%@全部<font color='#f76806'>%@</font>个猎头招聘已搜索完成",str,model_cityInfo.company];
                view_line = [self viewWithTag:(100/6)*4+300];
                view_line.hidden = NO;
                break;
            case (int)(100/6)*6:
                la01.frame=CGRectMake(40, 35.5+5*30, 250, 50);
                la01.text = [NSString stringWithFormat:@"小职了·%@企业库全部<font color='#f76806'>%@</font>企业招聘<br>已搜索完成",str,model_cityInfo.com_num];
                view_line = [self viewWithTag:(100/6)*5+300];
                view_line.hidden = NO;
                break;
            default:
                break;
        }
        
        if (num>=0&&num<100) {
            lab.text=@"正在按照您的指令搜遍全城职位！";
        }else if(100==num) {
            lab.text=@"已经按照您的指令搜遍全城职位!";
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"toScanningVC2" object:self userInfo:nil];
        }
        
        la01.alpha = 1;
        
        //对号图片
        UIImageView *imgView = (UIImageView *)[self viewWithTag:num+200];
        
        [imgView setImage:[UIImage imageNamed:@"wancheng"]];
    }
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.backgroundColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentRight;
}

- (void)setAnimate:(NSNumber *)animate {
    _animate = animate;
    if ([animate boolValue]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(incrementOffset) userInfo:nil repeats:YES];
    } else if (self.timer) {
        [self.timer invalidate];
    }
}


- (void)setProgress:(CGFloat)progress {
    self.progressToAnimateTo = progress;
    if ([self.animate boolValue]) {
        if (self.animationTimer) {
            [self.animationTimer invalidate];
        }
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(incrementAnimatingProgress) userInfo:nil repeats:YES];
    } else {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)incrementAnimatingProgress {
    if (_progress >= self.progressToAnimateTo-0.01 && _progress <= self.progressToAnimateTo+0.01) {
        _progress = self.progressToAnimateTo;
        [self.animationTimer invalidate];
        [self setNeedsDisplay];
    } else {
        _progress = (_progress < self.progressToAnimateTo) ? _progress + 0.01 : _progress - 0.01;
        [self setNeedsDisplay];
    }
}

- (void)incrementOffset {
    if (self.animateDirection == LDAnimateDirectionForward) {
        if (self.offset >= 0) {
            self.offset = -self.stripeWidth;
        } else {
            self.offset += 1;
        }
    } else {
        if (self.offset <= -self.stripeWidth) {
            self.offset = 0;
        } else {
            self.offset -= 1;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([self.showBackground boolValue]) {
        [self drawProgressBackground:context inRect:rect];
    }
    
    if (self.outerStrokeWidth) {
        [self drawOuterStroke:context inRect:rect];
    }
    
    if (self.progress > 0) {
        float inset = self.progressInset.floatValue;
        [self drawProgress:context withFrame:self.progressInset ? CGRectInset(rect, inset, inset) : rect];
    }
}

- (void)drawProgressBackground:(CGContextRef)context inRect:(CGRect)rect {
    CGContextSaveGState(context);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius.floatValue];
    CGContextSetFillColorWithColor(context, self.background.CGColor);
    [roundedRect fill];
    
    UIBezierPath *roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect:CGRectMake(-10, -10, rect.size.width+10, rect.size.height+10)];
    [roundedRectangleNegativePath appendPath:roundedRect];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;

    if ([self.showBackgroundInnerShadow boolValue]) {
        CGSize shadowOffset = CGSizeMake(0.5, 1);
        CGContextSaveGState(context);
        CGFloat xOffset = shadowOffset.width + round(rect.size.width);
        CGFloat yOffset = shadowOffset.height;
        CGContextSetShadowWithColor(context,
                CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)), 5, [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor);
    }

    [roundedRect addClip];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rect.size.width), 0);
    [roundedRectangleNegativePath applyTransform:transform];
    [RGB(243, 243, 243) setFill];
    [roundedRectangleNegativePath fill];
    CGContextRestoreGState(context);

    // Add clip for drawing progress
    [roundedRect addClip];
}

- (void)drawOuterStroke:(CGContextRef)context inRect:(CGRect)rect {
    float outerStrokeWidth = self.outerStrokeWidth.floatValue;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, outerStrokeWidth / 2, outerStrokeWidth / 2) cornerRadius:self.borderRadius.floatValue];
    [self.color setStroke];
    bezierPath.lineWidth = outerStrokeWidth;
    [bezierPath stroke];
}

- (void)drawProgress:(CGContextRef)context withFrame:(CGRect)frame {
    CGRect rectToDrawIn = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width * self.progress, frame.size.height);
    CGRect insetRect = CGRectInset(rectToDrawIn, self.progress > 0.03 ? 0.5 : -0.5, 0.5);
    if (![self.showText boolValue]) {
        insetRect = rectToDrawIn;
    }
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:self.borderRadius.floatValue];
    if ([self.flat boolValue]) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
        [roundedRect fill];
    } else {
        CGContextSaveGState(context);
        [roundedRect addClip];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0.0, 1.0};
        NSArray *colors = @[(__bridge id)self.color.CGColor, (__bridge id)self.color.CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(insetRect.size.width / 2, 0), CGPointMake(insetRect.size.width / 2, insetRect.size.height), 0);
        CGContextRestoreGState(context);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }

    if (self.progress != 1.0) {
        switch (self.type) {
            case LDProgressGradient:
                [self drawGradients:context inRect:insetRect];
                break;
            case LDProgressStripes:
                [self drawStripes:context inRect:insetRect];
                break;
            default:
                break;
        }
    }
    if ([self.showStroke boolValue]) {
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        [roundedRect stroke];
    } else {
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        [roundedRect stroke];
    }

    if ([self.showText boolValue]) {
        [self drawRightAlignedLabelInRect:insetRect];
    }
}

- (void)drawGradients:(CGContextRef)context inRect:(CGRect)rect {
    self.stripeSize = CGSizeMake(self.stripeWidth, rect.size.height);
    CGContextSaveGState(context);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius.floatValue] addClip];
    CGFloat xStart = self.offset;
    while (xStart < rect.size.width) {
        [self.gradientProgress drawAtPoint:CGPointMake(xStart, 0)];
        xStart += self.stripeWidth;
    }
    CGContextRestoreGState(context);
}

- (void)drawStripes:(CGContextRef)context inRect:(CGRect)rect {
    CGContextSaveGState(context);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.borderRadius.floatValue] addClip];
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor);
    CGFloat xStart = self.offset, height = rect.size.height, width = self.stripeWidth, y = rect.origin.y;
    while (xStart < rect.size.width) {
        CGContextSaveGState(context);
        CGContextMoveToPoint(context, xStart, height + y);
        CGContextAddLineToPoint(context, xStart + width * 0.25, 0);
        CGContextAddLineToPoint(context, xStart + width * 0.75, 0);
        CGContextAddLineToPoint(context, xStart + width * 0.50, height + y);
        CGContextClosePath(context);
        CGContextFillPath(context);
        CGContextRestoreGState(context);
        xStart += width;
    }
    CGContextRestoreGState(context);
}


#pragma mark - Accessors

- (UIImage *)gradientProgress {
    if (!_gradientProgress) {
        UIGraphicsBeginImageContext(self.stripeSize);
        CGContextRef imageCxt = UIGraphicsGetCurrentContext();

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0.0, 0.5, 1.0};
        NSArray *colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[self.color colorWithAlphaComponent:0.3].CGColor, (__bridge id)[UIColor clearColor].CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

        CGContextDrawLinearGradient(imageCxt, gradient, CGPointMake(0, self.stripeSize.height / 2), CGPointMake(self.stripeSize.width, self.stripeSize.height / 2), 0);

        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);

        _gradientProgress = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return _gradientProgress;
}

- (NSNumber *)animate {
    if (_animate == nil) {
        return @YES;
    }
    return _animate;
}

- (NSNumber *)showText {
    if (_showText == nil) {
        return @YES;
    }
    return _showText;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.gradientProgress = nil;
}

- (UIColor *)color {
    if (!_color) {
        return RGB(255, 163, 29);
    }
    return _color;
}

- (CGFloat)stripeWidth {
    switch (self.type) {
        case LDProgressGradient:
            _stripeWidth = 1;
            break;
        default:
            _stripeWidth = 50;
            break;
    }
    return _stripeWidth;
}

- (NSNumber *)borderRadius {
    if (!_borderRadius) {
        return @(self.frame.size.height / 2.0);
    }
    return _borderRadius;
}

- (UIColor *)background {
    if (!_background) {
        return RGB(243, 243, 243);
    }
    return _background;
}

- (NSNumber *)showStroke {
    if (!_showStroke) {
        return @YES;
    }
    return _showStroke;
}

- (NSNumber *)showBackground {
    if (!_showBackground) {
        return @YES;
    }
    return _showBackground;
}

- (NSNumber *)showBackgroundInnerShadow {
    if (!_showBackgroundInnerShadow) {
        return NO;
    }
    return _showBackgroundInnerShadow;
}

- (void)overrideProgressText:(NSString *)progressText {
    self.progressTextOverride = progressText;
    [self setNeedsDisplay];
}

- (void)overrideProgressTextColor:(UIColor *)progressTextColor {
    self.progressTextColorOverride = progressTextColor;
    [self setNeedsDisplay];
}



@end
