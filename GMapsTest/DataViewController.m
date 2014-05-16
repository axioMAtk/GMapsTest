//
//  DataViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/14/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import "DataViewController.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"
//#import "PastMapViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController


@synthesize lastHike;
@synthesize hikePicker;
@synthesize dbString;

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

- (void)viewDidLoad
{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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
    
    [database close];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendStuffPlaces:(id)sender {
   
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"base.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    NSMutableArray *results = [NSMutableArray array];
    
    [database open];
    NSString *dbQuery = [NSString stringWithFormat:@"SELECT * FROM %@", dbString];
    
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

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
    
    return [[results objectAtIndex:row] objectForKey:@"time"];
    
    
    //return [colorArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", (long)row);
    dbString = [NSMutableString stringWithFormat:@"logs%ld", (long)row];
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.dbString = dbString;
    
}




//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapSegue"]) {
       // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PastMapViewController *destViewController = segue.destinationViewController;
        destViewController.dbString = dbString;
    }
}*/


@end
