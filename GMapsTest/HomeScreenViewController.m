//
//  HomeScreenViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/12/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import "HomeScreenViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CoreLocation/CoreLocation.h"

@interface HomeScreenViewController () <GMSMapViewDelegate>

@end

@implementation HomeScreenViewController{
    GMSMapView *mapView_;
}

@synthesize currentcam;
@synthesize answerButton;
@synthesize amarker;
BOOL start;

- (void)viewDidLoad
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.85
                                                            longitude:151.20
                                                                 zoom:11];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.mapType = kGMSTypeSatellite;
    mapView_.delegate=self;
    mapView_.settings.tiltGestures=NO;
    [self.view insertSubview:mapView_ atIndex:0];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    start=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    //[self newHike];
    [self performSegueWithIdentifier:@"woot" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if(start)
    {
        CLLocationCoordinate2D vancouver = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
        GMSCameraUpdate *vancouverCam = [GMSCameraUpdate setTarget:vancouver];
        [mapView_ moveCamera:vancouverCam];
        amarker = [[GMSMarker alloc] init];
        amarker.position = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
        amarker.snippet = @"Tap to Start";
        amarker.title = @"New Hike";
        amarker.map = mapView_;
        [locationManager stopUpdatingLocation];
        [mapView_ setSelectedMarker:amarker];
        start=NO;
    }
    
    else{
        /*}
         
         -(void)locationManager:(CLLocationManager *)manager
         didUpdateToLocation:(CLLocation *)location
         fromLocation:(CLLocation *)oldLocation
         {*/
        NSString *currentLatitude = [[NSString alloc]
                                     initWithFormat:@"%+.6f",
                                     location.coordinate.latitude];
        
        NSString *currentLongitude = [[NSString alloc]
                                      initWithFormat:@"%+.6f",
                                      location.coordinate.longitude];
        
        NSString *currentHorizontalAccuracy =
        [[NSString alloc]
         initWithFormat:@"%+.6f",
         location.horizontalAccuracy];
        
        NSString *currentAltitude = [[NSString alloc]
                                     initWithFormat:@"%+.6f",
                                     location.altitude];
        
        NSString *currentVerticalAccuracy =
        [[NSString alloc]
         initWithFormat:@"%+.6f",
         location.verticalAccuracy];
        
        [path addCoordinate:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
        [latArray addObject:currentLatitude];
        
        [longArray addObject:currentLongitude];
        
        [altArray addObject:currentAltitude];
        
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
        polyline.map = mapView_;
        
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
    }
}

- (void)mapView:(GMSMapView *)mapView
didChangeCameraPosition:(GMSCameraPosition *)position;
{
    /*CGRect btFrame = answerButton.frame;
     btFrame.origin.x = mapView_.camera.target.latitude;
     btFrame.origin.y = mapView_.camera.target.longitude;
     answerButton.frame = btFrame;*/
}


//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
/*                   Code Below used to be ViewController class                     */
//////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

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

- (void)newHike     //formerly viewDidLoad
{
    [mapView_ clear];
    mapView_.mapType = kGMSTypeHybrid;
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self loadSoups];
    
    [locationManager startUpdatingLocation];
    
    mapView_.myLocationEnabled = YES;
    //mapView_.settings.myLocationButton = YES;
    
    path = [[GMSMutablePath alloc] init];
    
    altArray = [[NSMutableArray alloc] init];
    latArray = [[NSMutableArray alloc] init];
    longArray = [[NSMutableArray alloc] init];
    log = [[NSMutableArray alloc] init];
    JSONlog = [[NSMutableArray alloc] init];
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

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
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
