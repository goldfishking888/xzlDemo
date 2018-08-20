//
//  ViewEntryIdentifierViewController.m
//  JobKnow
//
//  Created by WangJinyu on 15/9/11.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "ViewEntryIdentifierViewController.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
@interface ViewEntryIdentifierViewController ()<UIScrollViewDelegate>
{
    UIScrollView * bgScrollV;
    UIImageView * bigImageV;
}
@end

@implementation ViewEntryIdentifierViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(243, 243, 243, 1);
    [self addBackBtn];
    [self addTitleLabel:@"查看入职证明"];
    bgScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44 + ios7jj, self.view.frame.size.width, self.view.frame.size.height - 44 - ios7jj)];
    bgScrollV.delegate = self;
    bgScrollV.backgroundColor = RGBA(243, 243, 243, 1);
    [self.view addSubview:bgScrollV];
    bigImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, self.view.frame.size.width - 30, 280)];
    bigImageV.image = [UIImage imageNamed:@"url_image_loading"];
    [bgScrollV addSubview:bigImageV];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)loadData
{
#pragma mark - 取到图片原大小按比例缩放至屏幕宽度wjy
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.CertifyUrl]] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (finished)
        {
            if (image.size.width > 0)
            {
//                float a = 0;//a 是
//                if (image.size.width != 0)
//                {
//                    a = (self.view.frame.size.width) / image.size.width;
//                    NSLog(@"a = %f",a);
//                }
//                float heightOfPhoto = image.size.height * a + 10;
//                //self.BigPhotoImageVBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MRScreenWidth, heightOfPhoto)];
//                bigImageV.frame = CGRectMake(15,44 + ios7jj + 15, self.view.frame.size.width - 30, heightOfPhoto);
                bigImageV.image = image;
                [bigImageV setContentMode:UIViewContentModeScaleAspectFit];
//                self.BigPhotoImageVBtn.center = CGPointMake(self.view.center.x, self.BigPhotobgButton.center.y - 32);
//                [self.BigPhotoImageVBtn addTarget:self action:@selector(removeViewButtonClick) forControlEvents:UIControlEventTouchUpInside];
//                [self.BigPhotobgButton addSubview:self.BigPhotoImageVBtn];
            }
        }
        if (error) {
            NSLog(@"error 57行");
        }
    }];

    UILabel * contentLabel = [MyControl createLableFrame:CGRectMake(15, bigImageV.frame.origin.y + bigImageV.frame.size.height + 10, self.view.frame.size.width - 30, 100) font:12 title:[NSString stringWithFormat:@"说明:%@",self.CertifyRemark]];
    contentLabel.layer.borderWidth = 0.5;
    contentLabel.layer.cornerRadius = 4;
    contentLabel.layer.masksToBounds = YES;
    contentLabel.layer.borderColor = [[UIColor orangeColor]CGColor];
    contentLabel.numberOfLines = 0;
    contentLabel.backgroundColor = RGBA(243, 243, 243, 1);
    contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [bgScrollV addSubview:contentLabel];
    
    bgScrollV.contentSize = CGSizeMake(self.view.frame.size.width, contentLabel.frame.origin.y + contentLabel.frame.size.height + 100);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
