//
//  ViewController.h
//  GMapsTest
//
//  Created by Chris Sutton and Nate Lundie on 5/2/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
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

@end
