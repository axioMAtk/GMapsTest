//
//  ViewController.m
//  GMapsTest
//
//  Created by Chris Sutton and Nate Lundie on 5/2/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CoreLocation/CoreLocation.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController {
    GMSMapView *mapView_;
}
@synthesize elevationStuff;
@synthesize theStringiestStringThatHasEverStringed;
@synthesize locationManager;
@synthesize altArray;
@synthesize longArray;
@synthesize latArray;
@synthesize path;
@synthesize log;
@synthesize JSONlog;
@synthesize JSONString;
@synthesize countString;
@synthesize hikeNumber;
@synthesize totalDistance;
@synthesize lastLocation;
@synthesize maxHeight;
@synthesize minHeight;
@synthesize autoZoom;
@synthesize speedArray;

- (void)viewDidLoad {
    [Segment.layer setCornerRadius:7.0f];
    [stats.layer setCornerRadius:7.0f];
    [zoom.layer setCornerRadius:7.0f];
    zoom.layer.borderWidth=1.0f;
    zoom.layer.borderColor=[[UIColor colorWithRed:0 green:0 blue:1 alpha:.5] CGColor];
    stats.layer.borderWidth=1.0f;
    stats.layer.borderColor=[[UIColor colorWithRed:0 green:0 blue:1 alpha:.5] CGColor];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    autoZoom=YES;
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.85,151.20 at zoom level 15.
    backgroundQueue = dispatch_queue_create("com.lundie.thread", NULL);
    backgroundQueue2 = dispatch_queue_create("com.lundie.thread2", NULL);
    locationManager = [[PSLocationManager alloc] init];
    //locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager prepLocationUpdates];
    dispatch_sync(backgroundQueue, ^(void) {
        [locationManager startLocationUpdates];
    });
    //[locationManager startUpdatingLocation];
    //[locationManager startUpdatingLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.85
                                                            longitude:151.20
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 64,
                                                   CGRectGetWidth(self.view.bounds),
                                                   (CGRectGetHeight(self.view.bounds))-64) camera:camera];
    mapView_.myLocationEnabled = YES;
    //mapView_.settings.myLocationButton = YES;
    mapView_.mapType = kGMSTypeSatellite;
    [self.view insertSubview:mapView_ atIndex:0];
    [self.view autoresizesSubviews];
    [mapView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    // Creates a marker in the center of the map.
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Elevation here";
    marker.snippet = theStringiestStringThatHasEverStringed;*/
    //marker.map = mapView_;
    //GMSMutablePath *path = [GMSMutablePath path];
    path = [[GMSMutablePath alloc] init];
    /*GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;*/
    /*[path addCoordinate:CLLocationCoordinate2DMake(-33.85, 151.20)];
    [path addCoordinate:CLLocationCoordinate2DMake(-33.70, 151.40)];
    [path addCoordinate:CLLocationCoordinate2DMake(-33.73, 151.41)];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;*/
    //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
      //                                                      longitude:151.20
        //                                                         zoom:6];
    
    
   // altArray = [[NSMutableArray alloc] init];
    //latArray = [[NSMutableArray alloc] init];
    //longArray = [[NSMutableArray alloc] init];
    speedArray = [[NSMutableArray alloc] init];
    log = [[NSMutableArray alloc] init];
    JSONlog = [[NSMutableArray alloc] init];
    //hikeNumber = [[NSUInteger alloc] init];
    //JSONString = [[NSString alloc] init];
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *now = [NSDate date];
    
    NSString *dateString = [gmtDateFormatter stringFromDate:now];
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    [database open];
     NSUInteger count = [database intForQuery:@"SELECT COUNT(rowid) FROM hikes"];
    hikeNumber = count;
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [database executeUpdate:@"INSERT INTO hikes (time, name) VALUES (?, ?)", dateString, appDelegate.hikeName, nil];
    countString = [NSString stringWithFormat:@"%d", (count+1)];
    NSString *logsString = [NSString stringWithFormat:@"logs%@", countString];
    //NSString *queryString = [NSString stringWithFormat:@"CREATE TABLE logs%@ (latitude Double, longitude Double, elevation Double, horizontalAccuracy Double, verticalAccuracy Double, time datetime)", countString];
    //[database executeUpdate:queryString];
    [database close];
    
    maxHeight=-9999999;
    minHeight=99999999;
    //self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    //self.progressView.center = self.view.center;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(PSLocationManager *)manager waypoint:(CLLocation *)waypoint calculatedSpeed:(double)calculatedSpeed
{
    

    [self foundLocation:waypoint withSpeed:calculatedSpeed];
    
    //[self foundLocation:manager.location];
    
    //[self foundLocation:manager.location];
    /*CLLocation *location = [locations lastObject];
    CLLocationDistance distance = [location distanceFromLocation:lastLocation];
    totalDistance += distance;
    NSLog(@"Total Distance: %.2f", totalDistance);
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 location.coordinate.latitude];
    //latitude.text = currentLatitude;
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  location.coordinate.longitude];
    //longitude.text = currentLongitude;
    
    NSString *currentHorizontalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     location.horizontalAccuracy];
    //horizontalAccuracy.text = currentHorizontalAccuracy;
    
    NSString *currentAltitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 location.altitude];
    //altitude.text = currentAltitude;
    //altArray = [[NSMutableArray alloc] init];
    //[altArray addObject:currentAltitude];
    //NSLog(@"altArray: %@", altArray);
    
    NSString *currentVerticalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     location.verticalAccuracy];
    //verticalAccuracy.text = currentVerticalAccuracy;
    
    //if (startLocation == nil)
      //  startLocation = newLocation;
    
    //CLLocationDistance distanceBetween = [newLocation
      //                                    distanceFromLocation:startLocation];
    
    NSString *tripString = [[NSString alloc]
                            initWithFormat:@"%f",
                            distanceBetween];
    //distance.text = tripString;
    [path addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    //[latArray addObject:currentLatitude];
    //NSLog(@"latArray: %@", latArray);
    //[longArray addObject:currentLongitude];
    //NSLog(@"longArray: %@", longArray);
    //[altArray addObject:currentAltitude];
    //NSLog(@"altArray: %@", altArray);
    
    
    
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;

    //Creates CoordinateBounds that show the entire path and sets camera to display those bounds
    GMSCoordinateBounds *pathscreen = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *pathcam = [GMSCameraUpdate fitBounds:pathscreen];
    [mapView_ animateWithCameraUpdate:pathcam];
    
    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *now = [NSDate date];
    
    NSString *dateString = [gmtDateFormatter stringFromDate:now];
    
    
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    [database open];
    NSString *nqueryString = [NSString stringWithFormat:@"INSERT INTO logs (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time, hikeNumber) VALUES (?, ?, ?, ?, ?, ?, ?)"];
    [database executeUpdate:@"INSERT INTO logs (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time, hikeNumber) VALUES (?, ?, ?, ?, ?, ?, ?)", currentLatitude, currentLongitude, currentAltitude, currentHorizontalAccuracy, currentVerticalAccuracy, dateString, countString, nil];
    [database close];
    
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc] init];
    [theDictionary setObject:currentLatitude forKey:@"latitude"];
    [theDictionary setObject:currentLongitude forKey:@"longitude"];
    [theDictionary setObject:currentAltitude forKey:@"elevation"];
    [theDictionary setObject:currentHorizontalAccuracy forKey:@"horizontalAccuracy"];
    [theDictionary setObject:currentVerticalAccuracy forKey:@"verticalAccuracy"];
    [theDictionary setObject:dateString forKey:@"time"];
    [log addObject:theDictionary];
    
    lastLocation = location;
    if(location.altitude<minHeight)
    {
        minHeight=location.altitude;
        //NSLog(@"minimum height: %ldl", (long)minHeight);
    }
    
    if(location.altitude>maxHeight)
    {
        maxHeight=location.altitude;
        //NSLog(@"maximum height: %ldl", (long)maxHeight);
    }*/
    //[self.locationManager stopLocationUpdates];
    //self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(_turnOnLocationManager)  userInfo:nil repeats:NO];
}

- (void)_turnOnLocationManager {
    [self.locationManager startLocationUpdates];
}




- (void)foundLocation:(CLLocation *)location withSpeed:(double)calculatedSpeed
{
    //CLLocation *location = [locations lastObject];
    //CLLocationDistance distance = [location distanceFromLocation:lastLocation];
    totalDistance = locationManager.totalDistance;
    [speedArray addObject:[NSNumber numberWithDouble:calculatedSpeed]];
    
    
    NSLog(@"Total Distance: %.2f", totalDistance);
   NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 location.coordinate.latitude];
    //latitude.text = currentLatitude;
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  location.coordinate.longitude];
    //longitude.text = currentLongitude;
    
    NSString *currentHorizontalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     location.horizontalAccuracy];
    //horizontalAccuracy.text = currentHorizontalAccuracy;
    
    NSString *currentAltitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 location.altitude];
    //altitude.text = currentAltitude;
    //altArray = [[NSMutableArray alloc] init];
    //[altArray addObject:currentAltitude];
    //NSLog(@"altArray: %@", altArray);
    
    NSString *currentVerticalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     location.verticalAccuracy];
    //verticalAccuracy.text = currentVerticalAccuracy;
    
    //if (startLocation == nil)
    //  startLocation = newLocation;
    
    //CLLocationDistance distanceBetween = [newLocation
    //                                    distanceFromLocation:startLocation];
    
    /*NSString *tripString = [[NSString alloc]
     initWithFormat:@"%f",
     distanceBetween];*/
    //distance.text = tripString;
    [path addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
    //[latArray addObject:currentLatitude];
    //NSLog(@"latArray: %@", latArray);
    //[longArray addObject:currentLongitude];
    //NSLog(@"longArray: %@", longArray);
    //[altArray addObject:currentAltitude];
    //NSLog(@"altArray: %@", altArray);
    
    
    
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
    
    //Creates CoordinateBounds that show the entire path and sets camera to display those bounds
    if (autoZoom)
    {
        GMSCoordinateBounds *pathscreen = [[GMSCoordinateBounds alloc] initWithPath:path];
        GMSCameraUpdate *pathcam = [GMSCameraUpdate fitBounds:pathscreen];
        /*NSLog(@"%f, %f",fabs(pathscreen.northEast.latitude-pathscreen.southWest.latitude),fabs(pathscreen.northEast.longitude-pathscreen.southWest.longitude));*/
        if (totalDistance>250) {
            [mapView_ animateWithCameraUpdate:pathcam];
        } else {
            CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
            GMSCameraUpdate *vancouverCam = [GMSCameraUpdate setTarget:vancouver zoom:17];
            [mapView_ animateWithCameraUpdate:vancouverCam];
        }
    }

    NSDateFormatter *gmtDateFormatter = [[NSDateFormatter alloc] init];
    gmtDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    gmtDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *now = [NSDate date];
    
    NSString *dateString = [gmtDateFormatter stringFromDate:now];
    
    
    
    /*NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    [database open];
    NSString *nqueryString = [NSString stringWithFormat:@"INSERT INTO logs (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time, hikeNumber) VALUES (?, ?, ?, ?, ?, ?, ?)"];
    [database executeUpdate:@"INSERT INTO logs (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time, hikeNumber) VALUES (?, ?, ?, ?, ?, ?, ?)", currentLatitude, currentLongitude, currentAltitude, currentHorizontalAccuracy, currentVerticalAccuracy, dateString, countString, nil];
    [database close];*/
    
    /*NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc] init];
     [theDictionary setObject:currentLatitude forKey:@"latitude"];
     [theDictionary setObject:currentLongitude forKey:@"longitude"];
     [theDictionary setObject:currentAltitude forKey:@"elevation"];
     [theDictionary setObject:currentHorizontalAccuracy forKey:@"horizontalAccuracy"];
     [theDictionary setObject:currentVerticalAccuracy forKey:@"verticalAccuracy"];
     [theDictionary setObject:dateString forKey:@"time"];
     [log addObject:theDictionary];*/
    
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc] init];
    [theDictionary setObject:currentLatitude forKey:@"latitude"];
    [theDictionary setObject:currentLongitude forKey:@"longitude"];
    [theDictionary setObject:currentAltitude forKey:@"elevation"];
    [theDictionary setObject:currentHorizontalAccuracy forKey:@"horizontalAccuracy"];
    [theDictionary setObject:currentVerticalAccuracy forKey:@"verticalAccuracy"];
    [theDictionary setObject:dateString forKey:@"time"];
    [log addObject:theDictionary];
    
    lastLocation = location;
    if(location.altitude<minHeight)
    {
        minHeight=location.altitude;
        //NSLog(@"minimum height: %ldl", (long)minHeight);
    }
    
    if((double)location.altitude>maxHeight)
    {
        maxHeight=location.altitude;
        //NSLog(@"maximum height: %ldl", (long)maxHeight);
    }
}




- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
}

-(IBAction)switchMapType{
	if(Segment.selectedSegmentIndex == 0){
		mapView_.mapType = kGMSTypeSatellite;
	}
	if(Segment.selectedSegmentIndex == 1){
        mapView_.mapType = kGMSTypeTerrain;
	}
    if(Segment.selectedSegmentIndex == 2){
        mapView_.mapType = kGMSTypeHybrid;
	}
}


- (IBAction)showStats:(id)sender {
    
    //[toast hideToast];
    
    NSString *display = [NSNumberFormatter localizedStringFromNumber:@(totalDistance)
                                                         numberStyle:NSNumberFormatterDecimalStyle];
    NSString *toastString = [NSString stringWithFormat:@"Total Distance: %@ %@ \n Average Speed: %.02f \n Current Speed: %.02f \n %@ %.2ld \n %@ %.2ld", display, @" m", [[speedArray valueForKeyPath:@"@avg.doubleValue"] doubleValue],  [[speedArray lastObject] doubleValue], @"Max Height", (long)maxHeight, @"Min Height", (long)minHeight];
    //int aNum = 2000000;
    
    [self.view makeToast:toastString
                duration:30
                position:[NSValue valueWithCGPoint:CGPointMake(160, 400)]];
    
    
}

- (IBAction)autoZoomOn:(id)sender {
    if (autoZoom) {
        autoZoom=NO;
    } else {
        autoZoom=YES;
        GMSCoordinateBounds *pathscreen = [[GMSCoordinateBounds alloc] initWithPath:path];
        GMSCameraUpdate *pathcam = [GMSCameraUpdate fitBounds:pathscreen];
        [mapView_ animateWithCameraUpdate:pathcam];
    }

}

- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
    //self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
    [self.view makeToast:@"Unable to determine location"
                duration:30
                position:[NSValue valueWithCGPoint:CGPointMake(160, 400)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [locationManager stopLocationUpdates];
    //[self.view addSubview:self.progressView];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
   double averageSpeed = [[speedArray valueForKeyPath:@"@avg.doubleValue"] doubleValue];
    NSLog(@"average speed: %@", [speedArray valueForKeyPath:@"@avg.doubleValue"]);
    
    [database open];
    for(int x=0; x<log.count; x++)
    {
       // self.progressView.progress = x/log.count;
        
        NSDictionary *theDictionary = [log objectAtIndex:x];
        [database executeUpdate:@"INSERT INTO logs (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time, hikeNumber) VALUES (?, ?, ?, ?, ?, ?, ?)", [theDictionary objectForKey:@"latitude"], [theDictionary objectForKey:@"longitude"], [theDictionary objectForKey:@"elevation"], [theDictionary objectForKey:@"horizontalAccuracy"], [theDictionary objectForKey:@"verticalAccuracy"], [theDictionary objectForKey:@"time"], countString, nil];
    }
    [database executeUpdateWithFormat:@"UPDATE hikes SET avgSpeed = %@ where number = %@", [speedArray valueForKeyPath:@"@avg.doubleValue"], countString];
    
    [database executeUpdateWithFormat:@"UPDATE hikes SET distance = %f where number = %@", totalDistance, countString];

    [database close];
    NSLog(@"dumped array to database");
    
}

@end
