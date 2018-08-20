//
//  XZLNoDataView.m
//  JobKnow
//
//  Created by WangJinyu on 2017/8/29.
//  Copyright © 2017年 YingNet. All rights reserved.
//

#import "XZLNoDataView.h"

@implementation XZLNoDataView
- (instancetype)initWithLabelString:(NSString *)string
{
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((iPhone_width - 114)/2, 80, 114, 92);
        imageView.image = [UIImage imageNamed:@"xzl_nodataImage"];
        [self addSubview:imageView];
        label = [[UILabel alloc] init];
        label.frame = CGRectMake(30, 180, iPhone_width - 60, 60);//写成60 防止2行的显示不开
        label.font = kContentFontSmall;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = string.length == 0 ? @"暂无数据":string;
        label.textColor = RGBA(121, 121, 121, 1);
        label.numberOfLines = 0;
        self.backgroundColor = RGBA(255, 255, 255, 1);
        [self addSubview:label];
    }
    return self;
}
#pragma mark - 修改文字
- (void)modifyLabelText:(NSString *)string
{
    label.text = string;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
