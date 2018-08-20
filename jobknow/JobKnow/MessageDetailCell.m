//
//  MessageDetailCell.m
//  JobKnow
//
//  Created by faxin sun on 13-4-18.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "MessageDetailCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Photo.h"
#import "SDDataCache.h"
#import "UIImageView+WebCache.h"
#import "File.h"
#define ORIGIN_Y_BTN_RESEND 45

@implementation MessageDetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier detailMessage:(MessageDetailModel *)message companyName:(NSString *)cname
{
    _mes = message;
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //日期
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, iPhone_width - 180, 20)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.layer.cornerRadius = 6;
        [self.dateLabel setTextColor:[UIColor whiteColor]];
        self.dateLabel.text = [[NSString alloc] initWithFormat:@"%@",message.dateline];
        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self.dateLabel setBackgroundColor:RGBA(200, 200, 200, 1)];
        [self.contentView addSubview:self.dateLabel];
        
        //计算大小
        NSString *text = message.msg;
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
        
        fromSelf = ([message.isself integerValue] == 1);
        
        head = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"com_head.png"]];
        [head setFrame:CGRectMake(fromSelf?(iPhone_width-60):10, 48, 50, 50)];

        [self addSubview:head];
        
        //添加文本信息
        UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?57:87.0f, 45.0f, size.width+10, size.height+10)];
        if (message.sendStatus == MessageSendStatusSending) {
//            bubbleText.backgroundColor = [UIColor orangeColor];
        }else if(message.sendStatus == MessageSendStatusFail){
            bubbleText.backgroundColor = [UIColor redColor];
        }else{
            bubbleText.backgroundColor = [UIColor clearColor];
        }
        
        bubbleText.font = font;
        bubbleText.numberOfLines = 0;
        bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
        bubbleText.text = text;
        
        //背影图片
        UIImage *bubble;
        
        if(fromSelf){
            bubble = [UIImage imageNamed:@"rightSpeak.png"];
            head.image = [self headImage];
            
        }else{
            bubble = [UIImage imageNamed:@"leftSpeak.png"];
            head.image = [UIImage imageNamed:@"com_head.png"];
        }
        
        self.bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2)  topCapHeight:floorf(bubble.size.height/2) ]];
        
        if (!_button_status) {
            if (fromSelf) {
                _button_status = [[UIButton alloc] initWithFrame:CGRectMake(self.bubbleImageView.frame.origin.x - 30, ORIGIN_Y_BTN_RESEND, 24, 24)];
            }else{
                _button_status.hidden = YES;
            }
        }
        _button_status.hidden = YES;
        [_button_status setImage:[UIImage imageNamed:@"liaotian_notsend_ico"] forState:UIControlStateNormal];
        if (message.sendStatus == MessageSendStatusFail) {
            _button_status.hidden = NO;
        }else{
            _button_status.hidden = YES;
        }
        [_button_status addTarget:self action:@selector(resendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button_status];
        if ([message.pmtype intValue] == 1)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            self.messageLabel.alpha = 0;
            //发送的图片
            self.sendImageView = [[UIImageView alloc] init];
            self.sendImageView.layer.cornerRadius = 5;
            self.sendImageView.layer.masksToBounds = YES;
            self.sendImageView.userInteractionEnabled = YES;
            if(message.pmid > 0&&![message.download_url isEqualToString:@""]){
                [self.sendImageView sd_setImageWithURL:[NSURL URLWithString:message.download_url_mini]];
            }else{
                 NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                [self.sendImageView setImage:[UIImage imageWithContentsOfFile:[cachesPath stringByAppendingPathComponent:message.file_real_name]]];
            }
            [tap addTarget:self action:@selector(seeImage:)];
            [self.sendImageView addGestureRecognizer:tap];
            //计算坐标
            _sendImageView.alpha = 1;
            self.messageLabel.alpha = 0;
            if (_sendImageView.image.size.height > _sendImageView.image.size.width) {
//                self.sendImageView.frame = CGRectMake(fromSelf?160:87.0f,45.0f, 75, 100);
//            self.bubbleImageView.frame = CGRectMake(fromSelf?140:65, 39.0f, self.sendImageView.frame.size.width+50.0f, self.sendImageView.frame.size.height+20.0f);
                self.sendImageView.frame = CGRectMake(fromSelf?135:87.0f, 45.0f,100, 75);
                self.bubbleImageView.frame = CGRectMake(fromSelf?113:65, 39.0f, self.sendImageView.frame.size.width+50.0f, self.sendImageView.frame.size.height+20.0f);
            }else
            {
                self.sendImageView.frame = CGRectMake(fromSelf?135:87.0f, 45.0f,100, 75);
                self.bubbleImageView.frame = CGRectMake(fromSelf?113:65, 39.0f, self.sendImageView.frame.size.width+50.0f, self.sendImageView.frame.size.height+20.0f);
            }
            if (fromSelf) {
                [_button_status setFrame:CGRectMake(self.bubbleImageView.frame.origin.x - 30, ORIGIN_Y_BTN_RESEND, 24, 24)];
            }else{
                _button_status.hidden = YES;
            }
            [self addSubview:self.bubbleImageView];
            [self addSubview:self.sendImageView];
            
        }else if([message.pmtype intValue] == 2){
           
            self.sendImageView = [[UIImageView alloc] init];
            self.sendImageView.userInteractionEnabled = YES;
            self.sendImageView.contentMode = UIViewContentModeRight;
            
            if (fromSelf) {
                self.sendImageView.image = [UIImage imageNamed:@"play_3.png"];
                self.sendImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"play_1.png"],[UIImage imageNamed:@"play_2.png"],[UIImage imageNamed:@"play_3.png"], nil];
            }else{
                self.sendImageView.image = [UIImage imageNamed:@"play_3_left.png"];
                self.sendImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"play_1_left.png"],[UIImage imageNamed:@"play_2_left.png"],[UIImage imageNamed:@"play_3_left.png"], nil];
            }
            
            
            self.sendImageView.frame = CGRectMake(fromSelf?185:87.0f,45.0f, 48, 37);
            self.bubbleImageView.frame = CGRectMake(fromSelf?165:65, 39.0f, self.sendImageView.frame.size.width+50.0f, self.sendImageView.frame.size.height+20.0f);
            if (fromSelf) {
                [_button_status setFrame:CGRectMake(self.bubbleImageView.frame.origin.x - 40, ORIGIN_Y_BTN_RESEND, 24, 24)];
            }else{
                _button_status.hidden = YES;
            }
            
            UILabel *TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?self.bubbleImageView.frame.origin.x -20: self.bubbleImageView.frame.origin.x+self.bubbleImageView.frame.size.width+5, self.bubbleImageView.frame.origin.y, 20, 15)];
            TimeLabel.text = [NSString stringWithFormat:@"%@\"",message.soundTime];
            TimeLabel.font = [UIFont systemFontOfSize:12];
            [TimeLabel setBackgroundColor:[UIColor clearColor]];
            [TimeLabel setTextAlignment:NSTextAlignmentRight];
            [self addSubview:TimeLabel];

            
            [self addSubview:self.bubbleImageView];
            [self addSubview:self.sendImageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(playSound:)];
            [self.sendImageView addGestureRecognizer:tap];
        }else{
            int x = 190 - bubbleText.frame.size.width;
            
            if(fromSelf){
                CGRect r = bubbleText.frame;
                r.origin.x += x;
                bubbleText.frame = r;
            }
             self.bubbleImageView.frame = CGRectMake(fromSelf?(42+x):65, 39.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
            if (fromSelf) {
                [_button_status setFrame:CGRectMake(self.bubbleImageView.frame.origin.x - 30, ORIGIN_Y_BTN_RESEND, 24, 24)];
            }else{
                _button_status.hidden = YES;
            }
            [self addSubview:self.bubbleImageView];
            [self addSubview:bubbleText];
        }
        if ([message.pmtype intValue] == 4) {
            //推荐简历
//            _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            self.bubbleImageView.frame = CGRectMake(self.bubbleImageView.frame.origin.x,
//                                               self.bubbleImageView.frame.origin.y,
//                                               self.bubbleImageView.frame.size.width,
//                                               self.bubbleImageView.frame.size.height+17);
//            _soundBtn.frame = CGRectMake(50,self.bubbleImageView.frame.size.height+10 ,self.bubbleImageView.frame.size.width,15 );
//            [_soundBtn setTitle:@"点击查看简历" forState:UIControlStateNormal];
//            [_soundBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            [_soundBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
//            [_soundBtn addTarget:self action:@selector(seeResume:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [self addSubview:_soundBtn];
        }
        CGRect r = head.frame;
        r.origin.y += self.bubbleImageView.frame.size.height - 60;
        head.frame = r;
        
    }
 
    return self;
}

- (UIImage *)headImage
{
    SDDataCache *imageCache = [SDDataCache sharedDataCache];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *sss = [user valueForKey:@"UserName"];
    NSData *imageData = [imageCache dataFromKey:[NSString stringWithFormat:@"%@.png",sss] fromDisk:YES];
    UIImage *image = [UIImage imageWithData:imageData];
    if (!image) {
        return [UIImage imageNamed:@"header_default.png"];
    }
    return image;
}

#pragma mark- 重新发送
-(void)resendMessage{
    if ([_delegate respondsToSelector:@selector(resendMessageWithModel:)]) {
        _mes.sendStatus = MessageSendStatusSending;
        [_delegate resendMessageWithModel:_mes];
    }
}

#pragma mark 查看图片
- (void)seeImage:(id)sender
{
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *url_image = [cachesPath stringByAppendingPathComponent:_mes.file_real_name];
    BOOL isExist_image = [[NSFileManager defaultManager] fileExistsAtPath:url_image];
    NSDictionary *paramter;
    if (isExist_image) {
        paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type",@"1",@"localImage",url_image,@"url",_sendImageView,@"rect", nil];
    }else{
        paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"image",@"type", @"0",@"localImage",_mes.download_url,@"url",_sendImageView,@"rect", nil];
    }
    
    NSNotification *notification = [NSNotification notificationWithName:@"play" object:nil userInfo:paramter];
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

#pragma mark 播放语音
- (void)playSound:(id)sender
{
    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"sound",@"type",_mes.file_real_name,@"name",_mes.download_url,@"url", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"play" object:nil userInfo:paramter];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    _sendImageView.animationDuration = 1.0;
    [_sendImageView startAnimating];
    [self performSelector:@selector(stopAnimating) withObject:nil afterDelay:[_mes.soundTime intValue]];
   
}

#pragma mark 查看简历
- (void)seeResume:(id)sennder
{
    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:@"resume",@"type",_mes.query_string,@"query_string", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"play" object:nil userInfo:paramter];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)stopAnimating
{
    [_sendImageView stopAnimating];
}

- (void)senondCellInitWithMessage:(MessageDetailModel *)message
{
    if (!fromSelf) {
        if (_headerUrlString&&![_headerUrlString isEqualToString:@""]) {
            [head setImageURL:[NSURL URLWithString:_headerUrlString]];
        }else{
            head.image = [UIImage imageNamed:@"com_head.png"];
        }

        
    }else{
       NSString *headurl =  [[NSUserDefaults standardUserDefaults] valueForKey:@"headUrl"];
        if (headurl&&![headurl isEqualToString:@""]) {
            [head setImageURL:[NSURL URLWithString:headurl]];
        }else{
            head.image = [UIImage imageNamed:@"com_head.png"];
        }
        
    }
    
    self.dateLabel.text = [[NSString alloc] initWithFormat:@"%@",message.dateline];
    CGSize size = [MessageDetailCell widthCell:message.msg];
    self.messageLabel.frame = CGRectMake(10, 7, size.width, size.height);
    self.messageLabel.text = message.msg;
    [self.messageLabel setTextColor:[UIColor blackColor]];
    NSString *pid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    self.messageLabel.alpha = 1;
    
    if ([message.pmtype intValue] == 1)
    {
       
    }else if([message.pmtype intValue] == 0)// 文件？
    {
        self.messageLabel.frame = CGRectMake(10, 10, size.width, size.height);
        if ([message.isself intValue] == 1)
        {
            self.backgroundImage.frame = CGRectMake(iPhone_width - size.width - 70, 35, size.width + 20, size.height + 15);
            
        }else
        {
            self.backgroundImage.frame = CGRectMake(50, 35, size.width + 20, size.height +  15);
        }
        
        [self.messageLabel setTextColor:[UIColor blueColor]];
    }else
    {
        if ([message.isself intValue] == 1)
        {
            
            if ([message.pmtype intValue] == 4) {
                self.backgroundImage.frame = CGRectMake(iPhone_width - size.width - 70, 35, size.width + 20, size.height + 30);
            }else
            {
                self.backgroundImage.frame = CGRectMake(iPhone_width - size.width - 70, 35, size.width + 20, size.height + 15);
            }
            
        }else
        {
            self.backgroundImage.frame = CGRectMake(50, 35, size.width + 20, size.height +  15);
        }
    }
    
    [self bringSubviewToFront:_button_status];
}

////ylh modify
//- (void)backup_senondCellInitWithMessage:(MessageDetailModel *)message
//{
//    self.dateLabel.text = [[NSString alloc] initWithFormat:@"%@",message.lastTime];
//    CGSize size = [MessageDetailCell widthCell:message.subject];
//    self.messageLabel.frame = CGRectMake(10, 7, size.width, size.height);
//    self.messageLabel.text = message.subject;
//    [self.messageLabel setTextColor:[UIColor blackColor]];
//    NSString *pid = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
//    self.messageLabel.alpha = 1;
//    
//
//    
//    if (message.messageOption == SOUNDMESSAGE) {
//        CGFloat w = 60+10*message.soundTime;
//        if (w>200.0f) {
//            w = 200.0f;
//        }
//        
//        
//        self.sendImageView.frame = CGRectMake(0, 10, w - 15, 25);
//        self.backgroundImage.frame = CGRectMake(iPhone_width - w - 50, 35, w, 45);
//        _soundBtn.frame = CGRectMake(0, 0, w, 45);
//    }
//    else if (message.messageOption == IMAGEMESSAGE)
//    {
//        _sendImageView.alpha = 1;
//        self.messageLabel.alpha = 0;
//        if (message.myImage.size.height > message.myImage.size.width) {
//            
//            self.backgroundImage.frame = CGRectMake(iPhone_width - 145, 35, 95, 110);
//            self.sendImageView.frame = CGRectMake(8, 5, 75, 100);
//        }else
//        {
//            self.backgroundImage.frame = CGRectMake(iPhone_width - 170, 35, 120, 85);
//            self.sendImageView.frame = CGRectMake(8, 5, 100, 75);
//        }
//    }else if(message.messageOption == FILEMESSAGE)
//    {
//        self.messageLabel.frame = CGRectMake(10, 10, size.width, size.height);
//        if ([message.from integerValue] == [pid integerValue])
//        {
//            self.backgroundImage.frame = CGRectMake(iPhone_width - size.width - 70, 35, size.width + 20, size.height + 15);
//            
//        }else
//        {
//            self.backgroundImage.frame = CGRectMake(50, 35, size.width + 20, size.height +  15);
//        }
//
//        [self.messageLabel setTextColor:[UIColor blueColor]];
//    }else
//    {
//        if ([message.from integerValue] == [pid integerValue])
//        {
//            
//            if (message.resume) {
//                self.backgroundImage.frame = CGRectMake(iPhone_width - size.width - 70, 35, size.width + 20, size.height + 30);
//            }else
//            {
//                self.backgroundImage.frame = CGRectMake(iPhone_width - size.width - 70, 35, size.width + 20, size.height + 15);
//            }
//            
//        }else
//        {
//            self.backgroundImage.frame = CGRectMake(50, 35, size.width + 20, size.height +  15);
//        }
//    }
//}

//- (NSString *)saveImagePath
//{
//    return _mes.dataName;
//}

//文件名称
- (NSString *)fileNames:(NSArray *)files
{
    NSMutableString *fileName = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i<1; i++) {
        File *f = [files objectAtIndex:i];
        [fileName appendString:f.fileName];
    }
    return fileName;
}

+ (CGSize)widthCell:(NSString *)message
{
    UIFont *font = [UIFont systemFontOfSize:14];
    
    CGSize size = CGSizeMake(iPhone_width - 110, MAXFLOAT);
    
    CGSize expectedLabelSizeOne = [message sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    return expectedLabelSizeOne;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
