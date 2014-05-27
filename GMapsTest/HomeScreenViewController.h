//
//  HomeScreenViewController.h
//  GMapsTest
//
//  Created by Nate Lundie on 5/12/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "UICKeyChainStore.h"
@import Security;


@interface HomeScreenViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *hsLocationManager;
    IBOutlet UIButton *mylocbtn;
}

@property (strong,nonatomic) GMSCameraPosition *currentcam;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (strong,nonatomic) GMSMarker *amarker;
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
-(IBAction)myloc;

@end
