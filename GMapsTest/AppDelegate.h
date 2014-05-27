//
//  AppDelegate.h
//  GMapsTest
//
//  Created by Chris Sutton and Nate Lundie on 5/2/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "UICKeyChainStore.h"

//@import Security;
@import Security;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString* databaseName;
@property (strong, nonatomic) NSString* databasePath;
@property (strong, nonatomic) NSString* dbString;
//test push stuff

@end
