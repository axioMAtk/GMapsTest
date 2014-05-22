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

@import Security;


@interface ViewController : UIViewController <CLLocationManagerDelegate>
{
    IBOutlet UISegmentedControl *Segment;
}
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
@property (nonatomic) NSUInteger hikeNumber;
-(IBAction)switchMapType;
@property (nonatomic) CLLocationDistance totalDistance;
@property (strong, nonatomic) CLLocation* lastLocation;
@property (nonatomic) NSInteger minHeight;
@property (nonatomic) NSInteger maxHeight;




@end