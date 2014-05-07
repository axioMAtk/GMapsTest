//
//  AppDelegate.h
//  GMapsTest
//
//  Created by Chris Sutton on 5/2/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* databaseName;
@property (strong, nonatomic) NSString* databasePath;

@end
