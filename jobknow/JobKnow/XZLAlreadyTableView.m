//
//  XZLAlreadyTableView.m
//  XzlEE
//
//  Created by ralbatr on 14-9-23.
//  Copyright (c) 2014年 xzhiliao. All rights reserved.
//

#import "XZLAlreadyTableView.h"
@class XZLJobVC;

@implementation XZLAlreadyTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        self.allowsSelection = NO;

        self.separatorColor=[UIColor clearColor];
        self.separatorStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor lightGrayColor];

        
    }
    return self;
}
#pragma mark UITableViewDelegate

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selectArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else{
        
        NSArray *views = [cell.contentView subviews];
        
        for (UIView *v in views){
            [v removeFromSuperview];
        }
        
    }
    
    //删除按钮
    UIButton *deleteBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.tag = indexPath.row;
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CGFloat width = 0;
    
    //取出已选择的职业
    if (self.selectArray)
    {
        NSString *readStr = [_selectArray objectAtIndex:indexPath.row];
        [deleteBtn setTitle:readStr forState:UIControlStateNormal];
       // NSLog(@"button====%@",[deleteBtn titleLabel]);
        width = [self StringWidthWithStr:readStr];
    }
//    else
//    {
//        jobRead *read = [_selectArray objectAtIndex:indexPath.row];
//        [deleteBtn setTitle:read.name forState:UIControlStateNormal];
//        width = [self StringWidthWithStr:read.name];
//    }
    
    UIImage *bubble = [UIImage imageNamed:@"dictpicker_bg_selecteditem.png"];
    UIImage *bubbleImageView = [bubble stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [deleteBtn setBackgroundImage:bubbleImageView forState:UIControlStateNormal];
    deleteBtn.frame = CGRectMake(10, 2, width + 30, 40);
    [deleteBtn setTitleEdgeInsets:UIEdgeInsetsMake(7, 0, 0, 5)];
    [deleteBtn addTarget:self action:@selector(removeSelectJob:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteBtn];
    return cell;
}
#pragma mark 功能方法

- (CGFloat)StringWidthWithStr:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:14];
    
    CGSize size = CGSizeMake(iPhone_width, MAXFLOAT);
    
    CGSize expectedLabelSizeOne = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByTruncatingMiddle];
    
    return expectedLabelSizeOne.width;
}


//图片自适应

- (UIImage *) resizableImageWithCapInsets2: (UIEdgeInsets) inset fromImage:(UIImage *)image
{
    if ([image respondsToSelector:@selector(resizableImageWithCapInsets:)])
    {
        return [image resizableImageWithCapInsets:inset];
    }
    else
    {
        float left = (image.size.width-2)/2;//The middle points rarely vary anyway
        float top = (image.size.height-2)/2;
        return [image stretchableImageWithLeftCapWidth:left topCapHeight:top];
    }
}


- (void)removeSelectJob:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btnTag =(NSInteger *) btn.tag;
   // NSLog(@"btntag===%d",(int)btnTag);
    if (self.selectArray.count)
    {
        [self viewAnimation:btn frame:CGRectMake(330, btn.frame.origin.y, btn.bounds.size.width, btn.bounds.size.height) time:0.2 alph:1];
    }
    else
    {
        [self viewAnimation:btn frame:CGRectMake(330, btn.frame.origin.y, btn.bounds.size.width, btn.bounds.size.height) time:0.2 alph:1];
        
    }
}



//动画方法
- (void)viewAnimation:(UIView *)view frame:(CGRect)frame time:(float)time alph:(float)alpha
{
    [UIView beginAnimations:@"Curl" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(stopView)];
    view.frame = frame;
    view.alpha = alpha;
    [UIView commitAnimations];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:view cache:YES];
    
    
    
}

- (void)stopView
{
    
    if (self.selectArray)
    {
        NSString *jobstr = [_selectArray objectAtIndex:(int)btnTag];
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.XZLAlreadyDelegate removeSelectedjob:jobstr];
//            [self.AlreadyDelegate test];
           // NSLog(@"已执行");
        }];
    }
//    else
//    {
//        jobRead *job = [_selectArray objectAtIndex:btnTag];
//        [UIView animateWithDuration:0.3 animations:^{ [self.AlreadyDelegate removeSelected:job];}];
//    }
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
