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
#import "Toast+UIView.h"
#import <dispatch/dispatch.h>
#import <PSLocationManager/PSLocationManager.h>


@import Security;


@interface ViewController : UIViewController <PSLocationManagerDelegate>
{
    IBOutlet UISegmentedControl *Segment;
    dispatch_queue_t backgroundQueue;
    dispatch_queue_t backgroundQueue2;

}
@property (strong, nonatomic)NSMutableArray *elevationStuff;
@property (strong, nonatomic)NSString* theStringiestStringThatHasEverStringed;
@property (strong, nonatomic) PSLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *latArray;
@property (strong, nonatomic) NSMutableArray *longArray;
@property (strong, nonatomic) NSMutableArray *altArray;
@property (strong, nonatomic) GMSMutablePath *path;
@property (strong, nonatomic) NSMutableArray* log;
@property (strong, nonatomic) NSMutableArray* JSONlog;
@property (strong, nonatomic) NSString* JSONString;
@property (strong, nonatomic) NSString* countString;
@property (nonatomic) NSUInteger hikeNumber;
@property (nonatomic) CLLocationDistance totalDistance;
@property (strong, nonatomic) CLLocation* lastLocation;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) NSMutableArray* speedArray;
//@property (nonatomic, strong) UIProgressView *progressView;

//dispatch_queue_t backgroundQueue;
-(IBAction)switchMapType;

@property (nonatomic) double minHeight;
@property (nonatomic) double maxHeight;





@end