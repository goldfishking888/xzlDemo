//
//  XZLNewPMDetailCell.m
//  XzlEE
//
//  Created by 孙扬 on 2017/1/6.
//  Copyright © 2017年 xzhiliao. All rights reserved.
//

#import "XZLNewPMDetailCell.h"
#import "XZLCommonWebViewController.h"
#import "VoiceConverter.h"
#import "UIImageView+AFNetworking.h"




@interface XZLNewPMDetailCell (){
    
    UIImageView * myImageView;
    XZLPMDetailModel *myModel;
    NSString *Soundpath;
    
    CGFloat rate;
}
@end
@implementation XZLNewPMDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setModelData:(XZLPMDetailModel *)model
{
    _tempModel = model;
    rate = 1;
    if (isScreenIPhone6Below) {
        rate = 320.0/375.0;
    }else if (isScreenIPhone6Upper){
        rate = 414.0/375.0;
    }
    
    for (UIView *item in self.subviews) {
        [item removeFromSuperview];
    }
    //发言角色标识符 isself=1自己 0对方 isSelf=NO 对方 YES 自己
    BOOL isSelf = NO;
    if ([model.isSelf isEqualToString:@"1"]) {
        isSelf = YES;
    }
    
    myModel = model;
    //添加时间label
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0 , 19, kMainScreenWidth, 15);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.created_time.integerValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日 HH:mm"];
    label.text = [formatter stringFromDate:date];
    label.textColor = RGB(153, 153, 153);
    label.font = [UIFont systemFontOfSize:14];
    [self addSubview:label];

    UIImageView *headImageView = [[UIImageView alloc]init];
    headImageView.backgroundColor = RGB(255, 214, 154);
    if(isSelf){
        headImageView.frame = CGRectMake(kMainScreenWidth-42-15, 50, 42, 42);
        
        UIImage *headImage = [UIImage imageNamed:@"portrait_default"];
        //获取头像
        if (model.portrait && model.portrait.length > 0) {
            [headImageView setImageWithURL:[NSURL URLWithString:[mUserDefaults valueForKey:@"portrait"]] placeholderImage:headImage];
        }else{
            headImageView.image = headImage;
        }
        
    }else{
        UIImage *headImage = [UIImage imageNamed:@"portrait_default"];
        //获取头像 company_logo
        if (model.portrait && model.portrait.length > 0) {
            [headImageView setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:headImage];
        }else{
            headImageView.image = headImage;
        }
        headImageView.frame = CGRectMake(15, 50, 50, 50);
    }
    //头像加圆角
    mViewBorderRadius(headImageView, headImageView.width/2, 1, [UIColor clearColor]);
    [self addSubview:headImageView];
    
    
    
    // 聊天背景
    UIImage *bg ;
    if (isSelf) {
        bg = [UIImage imageNamed:@"chat_back_right"];
    }else{
        bg = [UIImage imageNamed:@"chat_back_left"];
    }
    UIImageView *chatBgIV = [[UIImageView alloc] initWithImage:[bg stretchableImageWithLeftCapWidth:bg.size.width/2 topCapHeight:bg.size.height/2]];
    chatBgIV.frame = CGRectMake(60, 5, kMainScreenWidth - 120 , 30);
    [self addSubview:chatBgIV];

    NSString *resultStr = [model.content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    model.content = resultStr;

        UILabel *textLabel = [[UILabel alloc] init];
        
        
        textLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        [textLabel addGestureRecognizer:tap];
//        textLabel.text = model.content;
        
        NSData *data = [model.content dataUsingEncoding:NSUnicodeStringEncoding];
//        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
        NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                                   options:options
                                                        documentAttributes:nil
                                                                     error:nil];
        textLabel.attributedText = html;
        CGSize size = CGSizeMake(kMainScreenWidth-150*rate, CGFLOAT_MAX);
        size = [textLabel.attributedText.string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kContentFontMiddle} context:nil].size;
        if (isSelf) {
            [textLabel setFrame:CGRectMake(kMainScreenWidth-80-size.width-4, 12+45, size.width + 10, size.height)];
            textLabel.textColor = [UIColor whiteColor];
        }else{
            [textLabel setFrame:CGRectMake(90, 12+45, size.width+5 , size.height )];
            textLabel.textColor = RGB(92, 92, 92);
        }
        [self addSubview:textLabel];
    
    
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = kContentFontMiddle;
    
        textLabel.numberOfLines = 0;
        textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [textLabel sizeToFit];
    
    if (isSelf) {
        
        chatBgIV.frame = CGRectMake(kMainScreenWidth-90-size.width-6, 50, size.width + 35 , textLabel.height + 15);
    }else{
       
        chatBgIV.frame = CGRectMake(70, 50, size.width + 35 , textLabel.height+15 );
    }

    
    // 重发按钮
    if (isSelf) {
        _statusButton = [[UIButton alloc] initWithFrame:CGRectMake(chatBgIV.frame.origin.x - 30, (chatBgIV.frame.size.height-24)/2+chatBgIV.frame.origin.y, 24, 24)];
        [_statusButton setImage:[UIImage imageNamed:@"liaotian_notsend_ico"] forState:UIControlStateNormal];
        [_statusButton addTarget:self action:@selector(resendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_statusButton];
        if (model.sendStatus == MessageSendStatusFail) {
            _statusButton.hidden = NO;
        }else{
            _statusButton.hidden = YES;
        }
    }
    
}

#pragma mark 点击重发

- (void)resendMessage{
    
    if (_delegate && [_delegate respondsToSelector:@selector(resendMessageWithModel:)]) {
        myModel.sendStatus = MessageSendStatusSending;
        [_delegate resendMessageWithModel:myModel];
    }
}

#pragma mark 查看账单
- (void)seeBill:(id)sender
{
    
    if ([[mUserDefaults valueForKey:HideForCheck] isEqualToString:HideForCheck_Value]) {
        return;
    }
    
    NSNotification *notification = [NSNotification notificationWithName:@"seeBill" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark 查看图片
- (void)seeImage:(id)sender
{
    NSDictionary *paramter = [NSDictionary dictionaryWithObjectsAndKeys:myImageView ,@"imageview",nil];
    
    NSNotification *notification = [NSNotification notificationWithName:@"seeImage" object:nil userInfo:paramter];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark 文件是否存在
- (BOOL)isExistAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

#pragma mark 获取documents文件夹路径
- (NSString *)getDocumentDirectory{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(void)tapLabel:(UITapGestureRecognizer*)tap{
    UILabel *label = (UILabel *)tap.view;
    
    
    UINavigationController *nav= (UINavigationController *)[UIApplication sharedApplication].windows[0].rootViewController;
    if([_tempModel.content containsString:@"常见问题"]){
        
                XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
                vc.titleStr = @"常见问题";
                NSString *url = kCombineURL(kTestAPPAPIGR, @"/api/partner/qa");
                //        url = [url stringByAppendingString:[NSString stringWithFormat:@"?token=%@",kTestToken]];
                vc.urlStr = url;
                [nav pushViewController:vc animated:YES];
            }else if([_tempModel.content containsString:@"/raiders"]){
                XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
                vc.titleStr = @"";
                NSString *string = _tempModel.content;
                //用>分割字符串，放进数组里，取出第二个元素，截取字符串 就可得到脉搏网
                NSArray *array=[string componentsSeparatedByString:@">"];
                NSString *separateString=[array objectAtIndex:1];
                NSLog(@"%@",[separateString substringToIndex:(separateString.length-3)]);
                NSString *url = [separateString substringToIndex:(separateString.length-3)];
                //        url = [url stringByAppendingString:[NSString stringWithFormat:@"?token=%@",kTestToken]];
                vc.urlStr = url;
                [nav pushViewController:vc animated:YES];
            }else if ([_tempModel.content containsString:@"<a"] && [_tempModel.content containsString:@"href"]) {
        XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
                vc.titleStr = @"";
                NSString *string = _tempModel.content;
                //用>分割字符串，放进数组里，取出第二个元素，截取字符串 就可得到脉搏网
                NSArray *array=[string componentsSeparatedByString:@">"];
                NSString *separateString=[array objectAtIndex:1];
                NSLog(@"%@",[separateString substringToIndex:(separateString.length-3)]);
                NSString *url = [separateString substringToIndex:(separateString.length-3)];
                //        url = [url stringByAppendingString:[NSString stringWithFormat:@"?token=%@",kTestToken]];
                vc.urlStr = url;
                [nav pushViewController:vc animated:YES];
    }
//    if ([_tempModel.content containsString:@"/recruit/job/recommend/all"]||[_tempModel.content containsString:@"/recruit/resumeJob/recommend/all"]||[_tempModel.content containsString:@"/recruit/job/interview/all"]) {
//
//    }else if([_tempModel.content containsString:@"user/company_profile"]){
//
//    }else if([_tempModel.content containsString:@"/recruit/resumeJob/interviewResumeDetail"]){
//
//    }else if([_tempModel.content containsString:@"常见问题"]){
//
//        XZLCommonWebViewController *vc = [XZLCommonWebViewController new];
//        vc.titleStr = @"常见问题";
//        NSString *url = kCombineURL(kTestAPPAPIGR, @"/api/partner/qa");
//        //        url = [url stringByAppendingString:[NSString stringWithFormat:@"?token=%@",kTestToken]];
//        vc.urlStr = url;
//        [nav pushViewController:vc animated:YES];
//    }
}

@end
