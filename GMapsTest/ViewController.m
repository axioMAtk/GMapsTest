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
@synthesize speedArray;

- (void)viewDidLoad {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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
    [database executeUpdate:@"INSERT INTO hikes (time) VALUES (?)", dateString, nil];
    countString = [NSString stringWithFormat:@"%d", (count+1)];
    NSString *logsString = [NSString stringWithFormat:@"logs%@", countString];
    //NSString *queryString = [NSString stringWithFormat:@"CREATE TABLE logs%@ (latitude Double, longitude Double, elevation Double, horizontalAccuracy Double, verticalAccuracy Double, time datetime)", countString];
    //[database executeUpdate:queryString];
    [database close];
    
    maxHeight=-9999999;
    minHeight=99999999;

    
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
    GMSCoordinateBounds *pathscreen = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *pathcam = [GMSCameraUpdate fitBounds:pathscreen];
    [mapView_ animateWithCameraUpdate:pathcam];
    
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
    
    NSString *display = [NSNumberFormatter localizedStringFromNumber:@(totalDistance)
                                                         numberStyle:NSNumberFormatterDecimalStyle];
    NSString *toastString = [NSString stringWithFormat:@"Total Distance: %@ %@ \n average speed: %.02f \n current speed: %.02f \n %@ %.2ld \n %@ %.2ld", display, @" m", [[speedArray valueForKeyPath:@"@avg.doubleValue"] doubleValue],  [[speedArray lastObject] doubleValue], @"Max Height", (long)maxHeight, @"Min Height", (long)minHeight];
    //int aNum = 2000000;
    
    [self.view makeToast:toastString
                duration:100
                position:[NSValue valueWithCGPoint:CGPointMake(160, 400)]];
    
    
}
- (void)locationManager:(PSLocationManager *)locationManager error:(NSError *)error {
    // location services is probably not enabled for the app
    //self.strengthLabel.text = NSLocalizedString(@"Unable to determine location", @"");
    [self.view makeToast:@"Unable to determine location"
                duration:100
                position:[NSValue valueWithCGPoint:CGPointMake(160, 400)]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [locationManager stopLocationUpdates];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
   double averageSpeed = [[speedArray valueForKeyPath:@"@avg.doubleValue"] doubleValue];
    NSLog(@"average speed: %@", [speedArray valueForKeyPath:@"@avg.doubleValue"]);
    
    [database open];
    for(int x=0; x<log.count; x++)
    {
        NSDictionary *theDictionary = [log objectAtIndex:x];
        [database executeUpdate:@"INSERT INTO logs (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time, hikeNumber) VALUES (?, ?, ?, ?, ?, ?, ?)", [theDictionary objectForKey:@"latitude"], [theDictionary objectForKey:@"longitude"], [theDictionary objectForKey:@"elevation"], [theDictionary objectForKey:@"horizontalAccuracy"], [theDictionary objectForKey:@"verticalAccuracy"], [theDictionary objectForKey:@"time"], countString, nil];
    }
    [database executeUpdateWithFormat:@"UPDATE hikes SET avgSpeed = %@ where number = %@", [speedArray valueForKeyPath:@"@avg.doubleValue"], countString];

    [database close];
    NSLog(@"dumped array to database");
    
}

@end
