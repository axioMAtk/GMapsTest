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
#import "AppDelegate.h"


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
    if([UICKeyChainStore stringForKey:@"test"]!=nil)
    {
        NSLog(@"test: %@", [UICKeyChainStore stringForKey:@"test"]);
    }
    //NSLog(@"height: %fl", CGRectGetHeight(self.view.bounds));
    [mylocbtn.layer setCornerRadius:7.0f];
    [pastHike.layer setCornerRadius:7.0f];
    pastHike.layer.borderWidth=1.0f;
    pastHike.layer.borderColor=[[UIColor colorWithRed:0 green:0 blue:1 alpha:.5] CGColor];
    mylocbtn.layer.borderWidth=1.0f;
    mylocbtn.layer.borderColor=[[UIColor colorWithRed:0 green:0 blue:1 alpha:.5] CGColor];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.85
                                                            longitude:151.20
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.mapType = kGMSTypeSatellite;
    mapView_.delegate=self;
    mapView_.settings.tiltGestures=NO;
    mapView_.settings.consumesGesturesInView=NO;
    //mapView_.settings.myLocationButton=YES;
    mapView_.settings.compassButton=YES;
    //mapView_.myLocationEnabled=YES;
    [self.view insertSubview:mapView_ atIndex:0];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Hike" message:@"Please name your hike" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 12;
    [[alert textFieldAtIndex:0] setPlaceholder:@"New Hike Name"];
    [alert addButtonWithTitle:@"Begin"];
    [alert show];
    //[self performSegueWithIdentifier:@"woot" sender:self];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12) {
        if (buttonIndex == 1) {
            UITextField *textfield = [alertView textFieldAtIndex:0];
            NSLog(@"hike Name: %@", textfield.text);
            AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            if (![textfield.text isEqual:@""]) {
                appDelegate.hikeName = textfield.text;
                [self performSegueWithIdentifier:@"woot" sender:self];
            }
            else
            {
                [self.view makeToast:@"NAME YOUR HIKE"
                            duration:60
                            position:[NSValue valueWithCGPoint:CGPointMake(160, 150)]];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];

        [mapView_ clear];
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

}

- (IBAction) myloc
{
    [locationManager startUpdatingLocation];
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
