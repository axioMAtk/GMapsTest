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

@interface DataViewController ()

@end

@implementation DataViewController


@synthesize lastHike;

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
    
    FMResultSet *hikeResults = [database executeQuery:@"SELECT * FROM logs8"];
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
