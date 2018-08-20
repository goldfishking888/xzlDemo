//
//  MapViewController.m
//  Map-demo
//
//  Created by king on 13-3-28.
//  Copyright (c) 2013年 ZJ. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isCleck = YES;
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"地图"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"地图"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    
    myMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 44, iPhone_width, iPhone_height-44)];
    myMapView.showsUserLocation = YES;
    [self.view addSubview:myMapView];
    
    [self addBackBtn];
    [self addTitleLabel:@"位置定位"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"所选" style:(UIBarButtonItemStylePlain) target:self action:@selector(bendi:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    //manager实现位置更新
    
    MJGeocoder *geocoder = [[MJGeocoder alloc] init];
    geocoder.delegate = self;
    [geocoder findLocationsWithAddress:_address title:nil];
    lmanager = [[CLLocationManager alloc] init];
    lmanager.delegate = self;
    //定位方案选择
    lmanager.desiredAccuracy = kCLLocationAccuracyBest;
    //重新定位距离
    lmanager.distanceFilter = 1000;
//    //开始定位
    
    
}



- (void)geocoder:(MJGeocoder *)geocoder didFindLocations:(NSArray *)locations
{
    _resultArray = locations;
    _add = [_resultArray objectAtIndex:0];
    self.laa = _add.coordinate.latitude;
    self.loo = _add.coordinate.longitude;
    
    CLLocationCoordinate2D coordinate;

    //设置经纬度
    coordinate.latitude = self.laa;//纬度
    coordinate.longitude = self.loo;//经度
    
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    
    //地图定位区域
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span = span;
    NSLog(@"-------------%f--------------%f ",self.laa , self.loo);
    //手动设置地图定位
    [myMapView setRegion:region animated:YES];
    //加"针"
    [self addAnnotation:coordinate];
    //[lmanager startUpdatingLocation];
}

- (void)geocoder:(MJGeocoder *)geocoder didFailWithError:(NSError *)error
{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //删除地图上所有"针"
    for (NowAnnotation *na in mapView.annotations) {
        [mapView removeAnnotation:na];
    }
    //创建"针"视图
    MKPinAnnotationView *pinAnnoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"now"];
    //设置"针"颜色
    pinAnnoView.pinColor = MKPinAnnotationColorPurple;
    //设置是否可以点击
    pinAnnoView.canShowCallout = YES;
    //设置是否加动画
    pinAnnoView.animatesDrop = YES;
    return pinAnnoView;
}
//地图加"针"完成后方法
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    for (MKPinAnnotationView *pa in views) {
        [mapView selectAnnotation:pa.annotation animated:YES];
    }
}


- (void)addAnnotation:(CLLocationCoordinate2D)coordinate
{ 
    //删除地图上所有"针"
    for (NowAnnotation *na in myMapView.annotations) {
        [myMapView removeAnnotation:na];
    }
    //设置地图"针"信息
    nowAnnotation = [[NowAnnotation alloc] init];
    nowAnnotation.coordinate = coordinate;
    nowAnnotation.title = _add.name;
    nowAnnotation.subtitle = _add.fullAddress;
    NSLog(@"--------------==---%@",_add.city);
    [myMapView addAnnotation: nowAnnotation];
    
}


- (void)bendi:(id)sender
{
    UIBarButtonItem *bbi = (UIBarButtonItem *)sender;
    myMapView.showsUserLocation = YES;
    MKCoordinateSpan span;
    MKCoordinateRegion region;
    
    span.latitudeDelta=0.010;
    span.longitudeDelta=0.010;
    region.span=span;
    CLLocationCoordinate2D coordinate;
    if (isCleck) {
        [bbi setTitle:@"本地"];
        coordinate.latitude = 36.065271;
        coordinate.longitude = 120.406993;
        isCleck = NO;
    }else{
        isCleck = YES;
        coordinate.latitude = self.laa;
        coordinate.longitude = self.loo;
        [bbi setTitle:@"所选"];
    }
        
    region.center= coordinate;
    [myMapView setRegion:region animated:YES];
    
}

- (void)backUpVC:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
