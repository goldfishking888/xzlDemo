//
//  BaiduMapViewController.h
//  JobKnow
//
//  Created by Suny on 15/8/18.
//  Copyright (c) 2015年 lxw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface BaiduMapViewController : UIViewController<BMKMapViewDelegate, BMKGeoCodeSearchDelegate> {
    BMKMapView* mapView;
    BMKGeoCodeSearch* _geocodesearch;
    UILabel *navTitle;
    NSInteger num;
}
-(void)onClickGeocode;
-(void)onClickReverseGeocode;

@property (nonatomic,strong) NSString *address;

@end
