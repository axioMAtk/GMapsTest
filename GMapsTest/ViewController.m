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

- (void)viewDidLoad {
    [self loadSoups];
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.85,151.20 at zoom level 15.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.85
                                                            longitude:151.20
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    /*GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Elevation here";
    marker.snippet = theStringiestStringThatHasEverStringed;*/
    //marker.map = mapView_;
    //GMSMutablePath *path = [GMSMutablePath path];
    path = [[GMSMutablePath alloc] init];
    /*[path addCoordinate:CLLocationCoordinate2DMake(-33.85, 151.20)];
    [path addCoordinate:CLLocationCoordinate2DMake(-33.70, 151.40)];
    [path addCoordinate:CLLocationCoordinate2DMake(-33.73, 151.41)];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;*/
    //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
      //                                                      longitude:151.20
        //                                                         zoom:6];
    
    
    altArray = [[NSMutableArray alloc] init];
    latArray = [[NSMutableArray alloc] init];
    longArray = [[NSMutableArray alloc] init];
    log = [[NSMutableArray alloc] init];
    JSONlog = [[NSMutableArray alloc] init];
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
    [database executeUpdate:@"INSERT INTO hikes (time) VALUES (?)", dateString, nil];
    countString = [NSString stringWithFormat:@"%d", count];
    NSString *logsString = [NSString stringWithFormat:@"logs%@", countString];
    NSString *queryString = [NSString stringWithFormat:@"CREATE TABLE logs%@ (latitude Double, longitude Double, elevation Double, horizontalAccuracy Double, verticalAccuracy Double, time datetime)", countString];
    [database executeUpdate:queryString];
    [database close];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) loadSoups
{
    elevationStuff = [[NSMutableArray alloc] init];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/elevation/json?locations=39.7391536,-104.9847034&sensor=false&key=AIzaSyAlDakcBveHB6pyPqqkU-6RbHO2pGFiT2g"]];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                            timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    // NSLog(@"%@", urlData);
    
    NSDictionary *jsonDic = [NSJSONSerialization
                             JSONObjectWithData:urlData
                             options:0
                             error:&error];
    
    // NSLog(@"%@", jsonDic);
    NSDictionary *elevationDic = [jsonDic objectForKey:@"results"];
    
    //NSLog(@"Sides length is: %x", (unsigned int)[flikLiveDic count]);
    //NSLog(@"Description: %@", [flikLiveDic description]);
    
    for(NSDictionary *subMeals in elevationDic){
        NSString *holdString = [NSString stringWithFormat:@"%@", [subMeals objectForKey:@"elevation"]];
        //NSLog(@"MealName: %@", holdString);
        [elevationStuff addObject:holdString];
    }
    NSLog(@"lunchSoups: %@", elevationStuff);
    theStringiestStringThatHasEverStringed = elevationStuff.description;
    
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    //latitude.text = currentLatitude;
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    //longitude.text = currentLongitude;
    
    NSString *currentHorizontalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     newLocation.horizontalAccuracy];
    //horizontalAccuracy.text = currentHorizontalAccuracy;
    
    NSString *currentAltitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.altitude];
    //altitude.text = currentAltitude;
    //altArray = [[NSMutableArray alloc] init];
    //[altArray addObject:currentAltitude];
    //NSLog(@"altArray: %@", altArray);
    
    NSString *currentVerticalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     newLocation.verticalAccuracy];
    //verticalAccuracy.text = currentVerticalAccuracy;
    
    //if (startLocation == nil)
      //  startLocation = newLocation;
    
    //CLLocationDistance distanceBetween = [newLocation
      //                                    distanceFromLocation:startLocation];
    
    /*NSString *tripString = [[NSString alloc]
                            initWithFormat:@"%f",
                            distanceBetween];*/
    //distance.text = tripString;
    [path addCoordinate:CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)];
    [latArray addObject:currentLatitude];
    //NSLog(@"latArray: %@", latArray);
    [longArray addObject:currentLongitude];
    //NSLog(@"longArray: %@", longArray);
    [altArray addObject:currentAltitude];
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
    NSString *nqueryString = [NSString stringWithFormat:@"INSERT INTO logs%@ (latitude, longitude, elevation, horizontalAccuracy, verticalAccuracy, time) VALUES (?, ?, ?, ?, ?, ?)", countString];
    [database executeUpdate:nqueryString, currentLatitude, currentLongitude, currentAltitude, currentHorizontalAccuracy, currentVerticalAccuracy, dateString, nil];
    [database close];
    
    NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc] init];
    [theDictionary setObject:currentLatitude forKey:@"latitude"];
    [theDictionary setObject:currentLongitude forKey:@"longitude"];
    [theDictionary setObject:currentAltitude forKey:@"elevation"];
    [theDictionary setObject:currentHorizontalAccuracy forKey:@"horizontalAccuracy"];
    [theDictionary setObject:currentVerticalAccuracy forKey:@"verticalAccuracy"];
    [theDictionary setObject:dateString forKey:@"time"];
    [log addObject:theDictionary];
    
    NSError *error;
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:log
                                                        options:0
                                                        error:&error];
    
    JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    
    //[JSONlog addObject:JSONData];
    
    
    //for(int indexvalue=0; indexvalue<log.count; indexvalue++)
    //{
        //NSLog(@"dictionary values: %@", theDictionary);
        //NSLog(@"log Array values: %@", log.lastObject);
        //NSLog(@"Json values: %@", JSONlog.lastObject);
        //NSLog(JSONString);
    //}
    NSURL *url = [NSURL URLWithString:@"http://www.hikingnex.us/phpshizz/sendLog.php"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *postData = JSONString;
    
    NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
    [theRequest setValue:length forHTTPHeaderField:@"Content-Length"];
    
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
    
   // NSURLConnection *sConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    //[sConnection start];
    //NSlog(@"stuf%@", theRequest.accessibilityValue);
    
}

-(void) sendStuff
{
    NSURL *url = [NSURL URLWithString:@"http://www.hikingnex.us/phpshizz/sendLog.php"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                          timeoutInterval:60];
    
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *postData = JSONString;
    
    NSString *length = [NSString stringWithFormat:@"%d", [postData length]];
    [theRequest setValue:length forHTTPHeaderField:@"Content-Length"];
    
    [theRequest setHTTPBody:[postData dataUsingEncoding:NSASCIIStringEncoding]];
    
    NSURLConnection *sConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    [sConnection start];
}

@end
