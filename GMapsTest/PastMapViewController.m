//
//  PastMapViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/14/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import "PastMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CoreLocation/CoreLocation.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"

@interface PastMapViewController ()

@end

@implementation PastMapViewController {
    GMSMapView *mapView_;
}

@synthesize path;
@synthesize amarker;
@synthesize bmarker;
@synthesize cmarker;
@synthesize totalDiastance;
@synthesize avgSpeed;
@synthesize maxElevation;
@synthesize minElevation;

//@synthesize dbString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //NSString *dbString = appDelegate.dbString;
    NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM logs WHERE hikeNumber = %@", appDelegate.dbString];
    
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *results = [NSMutableArray array];
    maxElevation = 1;
    double maxLatitude;
    double maxLongitude;
    
    
    [database open];
    //NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM logs8"];
    
    FMResultSet *hikeResults = [database executeQuery:dbQuery];
    FMResultSet *hikeStats = [database executeQuery:@"SELECT * FROM hikes WHERE number = ?", appDelegate.dbString];
    totalDiastance = [[[hikeStats resultDictionary] objectForKey:@"distance"] doubleValue];
    avgSpeed = [[[hikeStats resultDictionary] objectForKey:@"avgSpeed"] doubleValue];
    
    while ([hikeResults next]) {
        [results addObject:[hikeResults resultDictionary]];
        if([[[hikeResults resultDictionary] objectForKey:@"elevation"] doubleValue]>maxElevation)
        {
            maxElevation=[[[hikeResults resultDictionary] objectForKey:@"elevation"] doubleValue];
            maxLatitude=[[[hikeResults resultDictionary] objectForKey:@"latitude"] doubleValue];
            maxLongitude=[[[hikeResults resultDictionary] objectForKey:@"longitude"] doubleValue];
            
        }
    }
    //FMResultSet *maxElevation = [database executeQuery:dbQueryEle];
    //NSDictionary *elevationDict = [maxElevation resultDictionary];
    
    [database close];
    
    
    
    
    NSMutableDictionary *thenDictionary = [[NSMutableDictionary alloc] init];
    thenDictionary = [results objectAtIndex:0];
    
    NSMutableDictionary *thennDictionary = [[NSMutableDictionary alloc] init];
    thennDictionary = [results lastObject];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[thenDictionary objectForKey:@"latitude"] doubleValue]
                                                            longitude:[[thenDictionary objectForKey:@"longitude"] doubleValue]
                                                                 zoom:5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.mapType = kGMSTypeSatellite;
    self.view = mapView_;
    //[self.view insertSubview:mapView_ atIndex:0];
    //[self.view autoresizesSubviews];
    //[mapView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    path = [[GMSMutablePath alloc] init];
    
    
    //Creates CoordinateBounds that show the entire path and sets camera to display those bounds
    for(int x=0; x<results.count; x++)
    {
        NSMutableDictionary *thenDictionary = [[NSMutableDictionary alloc] init];
        thenDictionary = [results objectAtIndex:x];
        //NSLog(@"latitude: %f", [[thenDictionary objectForKey:@"latitude"] doubleValue]);
        //NSLog(@"longitude: %f", [[thenDictionary objectForKey:@"longitude"] doubleValue]);
        
        [path addCoordinate:CLLocationCoordinate2DMake([[thenDictionary objectForKey:@"latitude"] doubleValue], [[thenDictionary objectForKey:@"longitude"] doubleValue])];
    }
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
    amarker = [[GMSMarker alloc] init];
    amarker.position = CLLocationCoordinate2DMake(maxLatitude, maxLongitude);
    NSLog(@"latitude: %f", maxLatitude);
    NSLog(@"longitude: %f", maxLongitude);
    NSString *display = [NSNumberFormatter localizedStringFromNumber:@(maxElevation)
                                                         numberStyle:NSNumberFormatterDecimalStyle];
    NSString *markerString = [NSString stringWithFormat:@"%@ meters", display];
    amarker.snippet = markerString;
    amarker.title = @"Max Elevation";
    amarker.map = mapView_;
    
    bmarker = [[GMSMarker alloc] init];
    bmarker.position = CLLocationCoordinate2DMake([[thenDictionary objectForKey:@"latitude"] doubleValue], [[thenDictionary objectForKey:@"longitude"] doubleValue]);
    bmarker.title = @"Start";
    bmarker.snippet = [thenDictionary objectForKey:@"time"];
    bmarker.map = mapView_;
    
    cmarker = [[GMSMarker alloc] init];
    cmarker.position = CLLocationCoordinate2DMake([[thennDictionary objectForKey:@"latitude"] doubleValue], [[thennDictionary objectForKey:@"longitude"] doubleValue]);
    cmarker.title = @"end";
    NSString *distString = [NSString stringWithFormat:@"Total Distance: %.2f m", totalDiastance];
    cmarker.snippet = distString;
    cmarker.map = mapView_;
    
    //[self updateCamera];
    
    
    //self.view = mapView_;
    
    
    
    //mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView_.myLocationEnabled = YES;
    //mapView_.settings.myLocationButton = YES;
    //self.view = mapView_;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    GMSCoordinateBounds *pathscreen = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *pathcam = [GMSCameraUpdate fitBounds:pathscreen];
    [mapView_ animateWithCameraUpdate:pathcam];
    
    //NSLog(@"did stuff");




}
- (IBAction)statsButton:(id)sender {
    
    //NSString *display = [NSNumberFormatter localizedStringFromNumber:@(totalDistance)
      //                                                   numberStyle:NSNumberFormatterDecimalStyle];
    NSString *toastString = [NSString stringWithFormat:@"Total Distance: %.02f %@ \n average speed: %.02f m/s \n Max Elevation: %.2f m", totalDiastance, @" m", avgSpeed, maxElevation];
    //int aNum = 2000000;
    
    [self.view makeToast:toastString
                duration:60
                position:[NSValue valueWithCGPoint:CGPointMake(160, 400)]];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
