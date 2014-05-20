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
    
    [database open];
    //NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM logs8"];
    
    FMResultSet *hikeResults = [database executeQuery:dbQuery];
    while ([hikeResults next]) {
        [results addObject:[hikeResults resultDictionary]];
    }
    
    [database close];
    
    
    NSMutableDictionary *thenDictionary = [[NSMutableDictionary alloc] init];
    thenDictionary = [results objectAtIndex:0];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[thenDictionary objectForKey:@"latitude"] doubleValue]
                                                            longitude:[[thenDictionary objectForKey:@"longitude"] doubleValue]
                                                                 zoom:5];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.mapType = kGMSTypeSatellite;
    self.view = mapView_;
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
