//
//  FileButton.m
//  JobKnow
//
//  Created by liuxiaowu on 13-9-12.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "FileButton.h"

@implementation FileButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 *option文件类型
 *bd判断是否绑定
 */
- (id)initWithFrame:(CGRect)frame fileType:(FileOption)option binding:(BOOL)bd resumeFile:(ResumeFile *)file type:(NSString *)myType
{
    self = [super initWithFrame:frame];
    if (self) {
        _option = option;
        //点击文件
        _fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fileBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [_fileBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_fileBtn.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_fileBtn setTitleEdgeInsets:UIEdgeInsetsMake(65, 0, 0, 0)];
        if ([myType isEqualToString:@"wai"]) {
            [_fileBtn setTitle:nil forState:UIControlStateNormal];
        }else{
            [_fileBtn setTitle:file.fileRealName forState:UIControlStateNormal];
       
        }
        [self addSubview:_fileBtn];

        //根据文件类型使用图片
        NSString *imageName = nil;
        switch (option) {
            case FileTxt:
                imageName = @"text_file.png";
                break;
            case FileWord:
                imageName = @"word_file.png";
                break;
            case FileExcel:
                imageName = @"excel_file.png";
                break;
            case FilePdf:
                imageName = @"pdf_file.png";
                break;
            case FileSound:
//                imageName = @"sound_file.png";
                imageName = @"filelook_icon_video.png";
                break;
            case FileImage:
                imageName = nil;
                break;
            default:
                imageName = @"";
                break;
        }
        
        [_fileBtn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        //背景
        _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10)];
        _bgView.contentMode = UIViewContentModeScaleAspectFit;
        if (file.fileItem == FileImage) {
            [self addSubview:_bgView];
            _bgView.image = file.myImage;
            [_fileBtn setBackgroundImage:[UIImage imageNamed:@"file_normal.png"] forState:UIControlStateNormal];
        }else if (file.fileItem == FileSound)
        {
            _bgView.frame = CGRectMake(5, 10, frame.size.width - 10, frame.size.height - 20);
        }
        _bindingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        if ([myType isEqualToString:@"wai"]) {
            
        }else{
            _bindingView.image = [UIImage imageNamed:@"binding_state.png"];
        }
        
        [self addSubview:_bindingView];
        //绑定显示否则隐藏
        if (file.binding) {
            _bindingView.alpha = 1;
        }else
        {
            _bindingView.alpha = 0;
        }
    }
    return self;
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_fileBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setBtnTag:(NSInteger)btnTag
{
    _fileBtn.tag = btnTag;
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
