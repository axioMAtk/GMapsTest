//
//  AppDelegate.m
//  GMapsTest
//
//  Created by Chris Sutton and Nate Lundie on 5/2/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
//

#import "AppDelegate.h"
#import "sqlite3.h"
#import "FMDatabase.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyAlDakcBveHB6pyPqqkU-6RbHO2pGFiT2g"];
    [UICKeyChainStore removeItemForKey:@"password"];
    //[UICKeyChainStore removeItemForKey:@"username"];
    //[UICKeyChainStore setString:@"nlundie" forKey:@"username"];
    
    BOOL success;
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:dbPath];
    
    if(success) return true;
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:@"CREATE TABLE hikes (number INTEGER PRIMARY KEY AUTOINCREMENT, time datetime, avgSpeed Double, name Varchar(100))"];
    [database executeUpdate:@"CREATE TABLE logs (latitude Double, longitude Double, elevation Double, horizontalAccuracy Double, verticalAccuracy Double, time datetime, hikeNumber int, hasBeenSent tinyint(1) DEFAULT 0)"];
    [database close];
    NSLog(@"created hikes table in database");
    
    
    return YES;
}



							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
