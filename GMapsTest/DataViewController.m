//
//  DataViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/14/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
/**
 has a picker that displays a list of your hikes, and displays them, if you click 'show on map' whichever hike is selected will be shown on a map with various bits of info
 
 **/

#import "DataViewController.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
#import "UICKeyChainStore.h"

@import Security;
//#import "PastMapViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController


@synthesize lastHike;
@synthesize hikePicker;
@synthesize dbString;
@synthesize totalDistance;
@synthesize totalSpeed;
@synthesize avgSpeed;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
}


//creates picker, populates it with hike names, and initializes dbstring
- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //NSString *dbString = appDelegate.dbString;
    //NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM users"];
    
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *results = [NSMutableArray array];
    double maxElevation = 1;
    double maxLatitude;
    double maxLongitude;
    
    
    [database open];
    //NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM logs8"];
    
    FMResultSet *hikeResults = [database executeQuery:@"SELECT * FROM hikes"];
    while ([hikeResults next]) {
        [results addObject:[hikeResults resultDictionary]];
        //totalDistance += [[[hikeResults resultDictionary] objectForKey:@"distance"] doubleValue];
        //totalSpeed += ([[[hikeResults resultDictionary] objectForKey:@"distance"] doubleValue]*[[[hikeResults resultDictionary] objectForKey:@"avgSpeed"] doubleValue]);
        
    }
    
    //avgSpeed = (totalSpeed/totalDistance);
    
    //FMResultSet *maxElevation = [database executeQuery:dbQueryEle];
    //NSDictionary *elevationDict = [maxElevation resultDictionary];
    
    [database close];
    
    
    // Do any additional setup after loading the view.
    
    /*NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *results = [NSMutableArray array];
    
    [database open];
    
    FMResultSet *hikeResults = [database executeQuery:@"SELECT * FROM logs0"];
    while ([hikeResults next]) {
        [results addObject:[hikeResults resultDictionary]];
    }
    NSLog(@"stuff: %@", results);
    NSMutableDictionary *thenDictionary = [[NSMutableDictionary alloc] init];
    thenDictionary = [results objectAtIndex:0];
    NSLog(@"stuff: %@", thenDictionary);
    
    [database close];*/
    
    hikePicker.delegate=self;
    hikePicker.dataSource=self;
        
    
    
    /*NSMutableDictionary *theDictionary = [[NSMutableDictionary alloc] init];
    [theDictionary setObject:currentLatitude forKey:@"latitude"];
    [theDictionary setObject:currentLongitude forKey:@"longitude"];
    [theDictionary setObject:currentAltitude forKey:@"elevation"];
    [theDictionary setObject:currentHorizontalAccuracy forKey:@"horizontalAccuracy"];
    [theDictionary setObject:currentVerticalAccuracy forKey:@"verticalAccuracy"];
    [theDictionary setObject:dateString forKey:@"time"];
    [log addObject:theDictionary];
    
    [database close];*/
    
    //[UICKeyChainStore setString:@"testUser" forKey:@"username"];
    //[UICKeyChainStore setString:@"peenpeen" forKey:@"password"];
    dbString = [NSMutableString stringWithFormat:@"%d", 1];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//sends all not yet sent things from the local database to a remote database in Utah
- (IBAction)sendStuffPlaces:(id)sender {
   
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *results = [NSMutableArray array];
    NSString *username = [UICKeyChainStore stringForKey:@"username"];
    NSLog(@"username is:%@", username);
    
    [database open];
    NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM logs WHERE hasBeenSent=0"];
    //NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM logs"];
    
    FMResultSet *hikeResults = [database executeQuery:dbQuery];
    while ([hikeResults next]) {
        [results addObject:[hikeResults resultDictionary]];
    }
    
    [database close];
    
    NSError *error;
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:results
                                                        options:0
                                                          error:&error];
    
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    
    
    NSString *stuff = [NSString stringWithFormat:@"http://www.hikingnex.us/phpshizz/sendLog.php?id=%@", username];
    NSURL *url = [NSURL URLWithString:stuff];
    
    
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
    [database open];
    [database executeUpdate:@"UPDATE logs SET hasBeenSent=1 WHERE hasBeenSent=0"];
    [database close];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

//checks how many hikes you've done, and makes there be that many rows in the picker
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    
    [database open];
    NSUInteger count = [database intForQuery:@"SELECT COUNT(number) FROM hikes"];
    [database close];
    
    
    return count;
}

//gets the name of each hike, and puts it in the picker 
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *results = [NSMutableArray array];
    
    [database open];
    
    FMResultSet *hikeResults = [database executeQuery:@"SELECT * FROM hikes"];
    while ([hikeResults next]) {
        [results addObject:[hikeResults resultDictionary]];
    }
    
    [database close];
    
    return [[results objectAtIndex:row] objectForKey:@"name"];
    
    
    //return [colorArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", ((long)row+1));
    dbString = [NSMutableString stringWithFormat:@"%ld", ((long)row+1)];
    //AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    //appDelegate.dbString = dbString;
   // NSLog(@"&(row): %d", &(row));
    //NSLog(@"appDelegate.dbString: %ld", appDelegate.dbString);
    
}




//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapSegue"]) {
       // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //PastMapViewController *destViewController = segue.destinationViewController;
        //destViewController.dbString = dbString;
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        appDelegate.dbString = dbString;
    }
}


@end
