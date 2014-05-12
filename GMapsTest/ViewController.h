//
//  ViewController.h
//  GMapsTest
//
//  Created by Chris Sutton on 5/2/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic)NSMutableArray *elevationStuff;
@property (strong, nonatomic)NSString* theStringiestStringThatHasEverStringed;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *latArray;
@property (strong, nonatomic) NSMutableArray *longArray;
@property (strong, nonatomic) NSMutableArray *altArray;
@property (strong, nonatomic) GMSMutablePath *path;
@property (strong, nonatomic) NSMutableArray* log;
@property (strong, nonatomic) NSMutableArray* JSONlog;
@property (strong, nonatomic) NSString* JSONString;
@property (strong, nonatomic) NSString* countString;



@end
