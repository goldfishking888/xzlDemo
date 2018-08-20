//
//  FileView.m
//  JobKnow
//
//  Created by faxin sun on 13-5-3.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "FileView.h"

@implementation FileView
int _num;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _num = ios7jj;
    }
    return self;
}

- (id)initWithItems
{
    self = [[FileView alloc] initWithFrame:CGRectMake(0, iPhone_height - 216 , iPhone_width, 216)];
    self.click = YES;
    UIImage *rawEntryBackground = [UIImage imageNamed:@"filebg.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:40 topCapHeight:40];
    UIImageView *imagev = [[UIImageView alloc] initWithImage:entryBackground];
    imagev.frame = CGRectMake(0, 0, iPhone_width, 216);
    
    self.btns = [NSMutableArray array];
    [self addSubview:imagev];
//    [self defaultInit];
    return self;
}

- (void)defaultInit
{
    //背景图片数组
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"message_photo.png"],[UIImage imageNamed:@"message_crame.png"], [UIImage imageNamed:@"message_file.png"],nil];
    NSArray *limages = [NSArray arrayWithObjects:[UIImage imageNamed:@"message_photo_l.png"],[UIImage imageNamed:@"message_crame_l.png"], [UIImage imageNamed:@"message_file_l.png"],nil];
    //title数组
    NSArray *titles;
    if (_isFromHr) {
        titles = [NSArray arrayWithObjects:@"从相册选取",@"拍照",nil];
    }else{
        titles = [NSArray arrayWithObjects:@"从相册选取",@"拍照", @"发送简历",nil];
    }
    for (int i = 0; i< titles.count; i++) {
        UIImage *image = [images objectAtIndex:i];
        UIImage *limage = [limages objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = i+51;
        [btn addTarget:self action:@selector(sendFiles:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:limage forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        
        
        switch (i) {
            case 0:
            {
                btn.frame = CGRectMake(0, 0, 106, 216/2);
                UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linebg2.png"]];
                im.frame = CGRectMake(106, 0, 1, 216);
                [self addSubview:im];
            }
                break;
            case 1:
            {
                btn.frame = CGRectMake(107, 0, 106, 216/2);
                UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linebg2.png"]];
                im.frame = CGRectMake(213, 0, 1, 216);
                [self addSubview:im];
            }

                break;
            case 2:
            {
                btn.frame = CGRectMake(214, 0, 106, 216/2);
                UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linebg2.png"]];
                im.frame = CGRectMake(320, 0, 1, 216);
                [self addSubview:im];
            }
                
                break;
        }
        //title
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(1, 70, 105, 28)];
        
        lable.text = [titles objectAtIndex:i];
        
        [lable setTextColor:[UIColor whiteColor]];
        [lable setFont:[UIFont systemFontOfSize:14]];
        [lable setBackgroundColor:[UIColor clearColor]];
        lable.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:lable];
        [self addSubview:btn];

    }
    //横线
    UIImageView *m = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"linebg.png"]];
    m.frame = CGRectMake(0, 216/2, iPhone_width, 1);
    [self addSubview:m];
}


- (void)addFiles:(NSArray *)files
{
    
    [self.btns removeAllObjects];
    self.options = files;
    NSInteger count = 0;
    if (files.count > 3) {
        count = 3;
    }else
    {
        count = files.count;
    }
    for (int i = 0; i< count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:100+i];
        [btn removeFromSuperview];
    }
    
    UIImage *image = [UIImage imageNamed:@"filebgf.png"];
    UIImage *limage = [UIImage imageNamed:@"filebjlight.png"];
    for (int i = 0; i< files.count; i++) {
        File *f = [files objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(iPhone_width/3), 216, (iPhone_width - 6)/3-2, 107);
        btn.tag = i+100;
        //[btn addTarget:self action:@selector(sendFiles:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:limage forState:UIControlStateHighlighted];
        [btn setImage:image forState:UIControlStateNormal];
        //添加标题
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(1, 70, 105, 28)];
        //lable.text = f.fileName;
        //UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(1, 70, 105, 28)];
        if ((i+1)>count) {
            lable.text = @"暂未上传附件";
        }else
        {
            lable.text = f.fileName;
            [btn addTarget:self action:@selector(sendFiles:)
          forControlEvents:UIControlEventTouchUpInside];
        }
        [lable setTextColor:[UIColor whiteColor]];
        [lable setFont:[UIFont systemFontOfSize:14]];
        [lable setBackgroundColor:[UIColor clearColor]];
        lable.textAlignment = NSTextAlignmentCenter;
        [btn addSubview:lable];
        [self addSubview:btn];
        [self.btns addObject:btn];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i< files.count; i++) {
            UIButton *btn = (UIButton *)[self viewWithTag:100+i];
            switch (i) {
                case 0:
                {
                    btn.frame = CGRectMake(0, 108, 106, 216/2);
                }
                    break;
                case 1:
                {
                    btn.frame = CGRectMake(107, 108, 106, 216/2);
                }
                    
                    break;
                case 2:
                {
                    btn.frame = CGRectMake(214, 108, (iPhone_width - 6)/3, 216/2);
                    
                }
                    break;
            }
        }
        }];
}

- (void)deleteFile
{
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i< 3; i++) {
            UIButton *btn = (UIButton *)[self viewWithTag:100+i];
            btn.frame = CGRectMake(i*(iPhone_width/3), 216, (iPhone_width - 6)/3, 216/2);
        }
    }];
}

- (void)sendFiles:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 50:
        {
            if (self.click) {
                self.click = NO;
                [self.fileDelegate sendFile];//附件
            }else
            {
                self.click = YES;
                [self deleteFile];
            }
        }
            break;
        case 51:
        {
            [self.fileDelegate sendPhoto];//图片
        }
            break;
        case 52:
        {
            [self.fileDelegate sendCamer];//照相机
        }
            break;
        case 53:
        {
            [self.fileDelegate sendResume];//简历
        }
            break;
            default:
        {
            
            File *f = [self.options objectAtIndex:btn.tag - 100];
            BOOL result = [self.fileDelegate selectFile:f];
            if (result) {
                                UIImage *limage = [UIImage imageNamed:@"filebjlight.png"];
                [btn setImage:limage forState:UIControlStateNormal];
                [self setBtnImageWithTag:btn.tag];
            }
            else
            {
                UIImage *image = [UIImage imageNamed:@"filebgf.png"];
                [btn setImage:image forState:UIControlStateNormal];
            }
        }
            break;
    }
}

- (void)setBtnImageWithTag:(NSInteger)tag
{
    for (UIButton *btn in self.btns) {
        if (btn.tag != tag) {
            [btn setImage:[UIImage imageNamed:@"filebgf.png"] forState:UIControlStateNormal];
        }
    }
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
