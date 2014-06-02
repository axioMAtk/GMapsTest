//
//  PastMapViewController.h
//  GMapsTest
//
//  Created by Nate Lundie on 5/14/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Toast+UIView.h"

@interface PastMapViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) GMSMutablePath *path;
@property (strong,nonatomic) GMSMarker *amarker;
@property (strong,nonatomic) GMSMarker *bmarker;
@property (strong,nonatomic) GMSMarker *cmarker;
@property (nonatomic)  double totalDiastance;
@property (nonatomic) double avgSpeed;
@property (nonatomic) double maxElevation;
@property (nonatomic) double minElevation;
//@property (strong, nonatomic) NSMutableString *dbString;


@end
