//
//  BaiduMapViewController.m
//  JobKnow
//
//  Created by Suny on 15/8/18.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import "BaiduMapViewController.h"

@interface BaiduMapViewController ()
{
    bool isGeoSearch;
}
@end
@implementation BaiduMapViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = XZHILBJ_colour;
    num=ios7jj;
    //顶部导航栏样式
    for (int i=0; i<4; i++) {
        if (i==0) {
            //图片
            UIImageView *titleIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iPhone_width, 44+num)];
            titleIV.backgroundColor = RGBA(255, 115, 4, 1);
            [self.view addSubview:titleIV];
            
        }else if(i==3){
            //标题
            navTitle =[[UILabel alloc] initWithFrame:CGRectMake(50, 0+Frame_Y, 210, 44)];
            [navTitle setText:_address];
            [navTitle setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(readBtnClick:)];
            [navTitle addGestureRecognizer:tap];
            //            uicontroleve
            [navTitle setTextAlignment:NSTextAlignmentCenter];
            [navTitle setBackgroundColor:[UIColor clearColor]];
            [navTitle setFont:[UIFont systemFontOfSize:18]];
            [navTitle setNumberOfLines:0];
            [navTitle setTag:999];
            [navTitle setTextColor:[UIColor whiteColor]];
            [self.view addSubview:navTitle];
            
        }else{
            //左右按钮
            
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
            if (i==1) {
                //左按钮
                [btn setFrame:CGRectMake(10, Frame_Y+5, 50, 30)];
                [btn setEnabled:true];
                [btn setBackgroundColor:[UIColor clearColor]];
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
                [btn setTitleColor:[UIColor colorWithHex:0x2c2c2c alpha:1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"btnnew"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(leftBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //右按钮
                
                if (IOS7) {
                    btn.frame = CGRectMake(iPhone_width-40,24,35,35);
                }else
                {
                    btn.frame = CGRectMake(iPhone_width-40,10,35,35);
                }
              
                [btn  addTarget:self action:@selector(rightBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
    }

    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        //        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.navigationController.navigationBar.translucent = NO;
    }
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 44+num, iPhone_width, iPhone_height-44-num)];
    [mapView setZoomLevel:17];
    [self.view addSubview:mapView];
    [self onClickGeocode];
}

//点击导航栏左侧按钮
-(void)leftBtnPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//点击导航栏右侧按钮
-(void)rightBtnPressed{

}


-(void)viewWillAppear:(BOOL)animated {
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    _geocodesearch.delegate = nil; // 不用时，置nil
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (mapView) {
        mapView = nil;
    }
}

-(IBAction)textFiledReturnEditing:(id)sender {
    [sender resignFirstResponder];
}


//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    return annotationView;
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mapView addAnnotation:item];
        mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
//        [mapView setCenterCoordinate:item.coordinate animated:NO];
        
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
    }
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mapView addAnnotation:item];
        mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        titleStr = @"反向地理编码";
        showmeg = [NSString stringWithFormat:@"%@",item.title];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}



-(void)onClickReverseGeocode
{
    isGeoSearch = false;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
//    if (_coordinateXText.text != nil && _coordinateYText.text != nil) {
//        pt = (CLLocationCoordinate2D){[_coordinateYText.text floatValue], [_coordinateXText.text floatValue]};
//    }
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

-(void)onClickGeocode
{
    isGeoSearch = true;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geocodeSearchOption.city= _cityText.text;
    geocodeSearchOption.address = _address;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}

@end
