//
//  HomeScreenViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/12/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface HomeScreenViewController ()

@end

@implementation HomeScreenViewController

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
    
    [database close];
    
    
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
- (IBAction)buttonPushed:(id)sender {
    
    
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
    [database close];
    
    NSLog(@"stuff: %@", hikeResults);*/
    
    
}

@end
