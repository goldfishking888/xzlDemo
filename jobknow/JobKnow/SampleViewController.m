//
//  SampleViewController.m
//  ChromeProgressBarSample
//
//  Created by Mario Nguyen on 01/12/11.
//  Copyright (c) 2012 Mario Nguyen. All rights reserved.
//

#import "SampleViewController.h"

@implementation SampleViewController

@synthesize addressBox, webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.change = NO;
       
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadRequest];
    [super viewDidAppear:YES];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"浏览器"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"浏览器"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (iPhone_5Screen) {
        webView.frame = CGRectMake(0, 52, 320, iPhone_5Frame.size.height-52);
    }else{
        webView.frame = CGRectMake(0, 52, 320, 480-52);
    }
    // 设置可以支持缩放
    [webView setScalesPageToFit:YES];
    
    if (self.change) {
        OLGhostAlertView *alert  = [[OLGhostAlertView alloc] initWithTitle:nil message:@"已复制求职信，请在编辑时粘贴到邮件内容" timeout:2 dismissible:YES];
        alert.position = OLGhostAlertViewPositionCenter;
        [alert show];
    }
    
    if (![self.urlStr hasPrefix:@"http://"]) {
         self.urlStr = self.urlStr;
    } else {
        
        NSString* prefix = [self.urlStr substringFromIndex:8];

        self.urlStr = prefix;
    }
    

    
    
    
   self.addressBox.text = self.urlStr;
    
}

- (void)viewDidUnload {
    [self setAddressBox:nil];
    [self setWebView:nil];
    chromeBar = nil;
    
    // Release any retained subviews of the main view.
    [super viewDidUnload];
    
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)webView:(IMTWebView *)_webView didReceiveResourceNumber:(int)resourceNumber totalResources:(int)totalResources {
    //Set progress value
    [chromeBar setProgress:((float)resourceNumber) / ((float)totalResources) animated:NO];

    //Reset resource count after finished
    if (resourceNumber == totalResources) {
        _webView.resourceCount = 0;
        _webView.resourceCompletedCount = 0;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loadRequest];
    return YES;
}

- (IBAction)goButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)loadRequest {
    if (chromeBar) {
        UIView* subview = (UIView*)chromeBar;
        [subview removeFromSuperview];
    }
    
    chromeBar = [[ChromeProgressBar alloc] initWithFrame:CGRectMake(0.0f, 50.0f, self.view.bounds.size.width, 4.0f)];
    
    [self.view addSubview:chromeBar];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"http://%@", self.addressBox.text]]]];
    [chromeBar release];
    [addressBox resignFirstResponder];
}

- (void)dealloc {
    [addressBox release];
    [webView release];
    [super dealloc];
}

@end
