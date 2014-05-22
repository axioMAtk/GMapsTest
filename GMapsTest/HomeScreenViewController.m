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
@synthesize locationManager;
BOOL start;

- (void)viewDidLoad
{
    NSLog(@"width: %fl", CGRectGetWidth(self.view.bounds));
    NSLog(@"height: %fl", CGRectGetHeight(self.view.bounds));
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
    [self.view autoresizesSubviews];
    [mapView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
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
}

- (void)mapView:(GMSMapView *)mapView
didChangeCameraPosition:(GMSCameraPosition *)position;
{
    /*CGRect btFrame = answerButton.frame;
     btFrame.origin.x = mapView_.camera.target.latitude;
     btFrame.origin.y = mapView_.camera.target.longitude;
     answerButton.frame = btFrame;*/
}

@end
