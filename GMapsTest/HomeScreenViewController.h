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

@interface HomeScreenViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *hsLocationManager;
}

@property (strong,nonatomic) GMSCameraPosition *currentcam;
@property (strong, nonatomic) IBOutlet UIButton *answerButton;
@property (strong,nonatomic) GMSMarker *amarker;

@end
