//
//  MapViewController.h
//  Map-demo
//
//  Created by king on 13-3-28.
//  Copyright (c) 2013年 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowAnnotation.h"
#import "MJGeocoder.h"
#import "Address.h"
@interface MapViewController : BaseViewController<MKMapViewDelegate,CLLocationManagerDelegate,MJGeocoderDelegate>

{
    MKMapView *myMapView ;
    NowAnnotation *nowAnnotation;
    BOOL isCleck;
    CLLocationManager *lmanager;
}

@property (nonatomic, strong) Address *add;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double laa;
@property (nonatomic, assign) double loo;

@end
