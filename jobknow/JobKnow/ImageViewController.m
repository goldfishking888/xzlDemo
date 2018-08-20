//
//  ImageViewController.m
//  JobKnow
//
//  Created by liuxiaowu on 13-9-9.
//  Copyright (c) 2013年 lxw. All rights reserved.
//

#import "ImageViewController.h"
#import "Photo.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[self addBackBtn];
    
    //[self addTitleLabel:@"图片"];
    
    [self.backBtn addTarget:self action:@selector(backPress:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height - 44)];
    [self.view addSubview:_imageView];
    
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, iPhone_height/2, iPhone_width - 40, 30)];
    [_progressView setProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_progressView];
    
    [self getImageWithUrl];
    
	// Do any additional setup after loading the view.
}


- (void)backPress:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)getImageWithUrl
{
    NSString *urlString = kCombineURL(@"http://timages.hrbanlv.com/", _imageUrl);
    NSLog(@"url------------------------%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    __block ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setUploadProgressDelegate:self];
    
    [request setCompletionBlock:^{
        //_progressView.alpha = 0;
        NSData *imagedata = [Photo scaleData:request.responseData toWidth:320 toHeight:iPhone_height - 44];
        _imageView.image = [UIImage imageWithData:imagedata];
        NSLog(@"------------------------%@",[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding]);
    }];
    
    [request setFailedBlock:^{
        NSLog(@"------------------------fail");
    }];
    [request startAsynchronous];
}

- (void)setProgress:(float)newProgress
{
    [_progressView setProgress:newProgress animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
