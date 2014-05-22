//
//  LoginViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/22/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize success;
@synthesize message;
@synthesize usernameField;
@synthesize passwordField;
@synthesize username;
@synthesize password;

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
    if(!([UICKeyChainStore stringForKey:@"username"]==nil) && !([UICKeyChainStore stringForKey:@"password"]==nil))
    {
        username=[UICKeyChainStore stringForKey:@"username"];
        password=[UICKeyChainStore stringForKey:@"password"];
        [self attemtLogin];
        [UICKeyChainStore removeItemForKey:@"password"];
        
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if([UICKeyChainStore stringForKey:@"username"]!=nil)
    {
        usernameField.text=[UICKeyChainStore stringForKey:@"username"];
    }
    
    
    
    
    
}

- (void) attemtLogin
{
    //NSInteger success = 0;
    success=0;
    //jsonArray = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://www.hikingnex.us/phpshizz/login.php?id=%@&p=%@", [UICKeyChainStore stringForKey:@"username"] , [UICKeyChainStore stringForKey:@"password"]];
    
    
    
    NSURL * url = [[NSURL alloc] initWithString: urlString];
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    NSLog(@"%@", urlData);
    
    NSDictionary *jsonDic = [NSJSONSerialization
                             JSONObjectWithData:urlData
                             options:0
                             error:&error];
    
    NSLog(@"%@", jsonDic);
    success = [jsonDic[@"success"] integerValue];
    message = [jsonDic[@"message"] stringValue];
    
    if(success==0)
    {
        [UICKeyChainStore setString:username forKey:@"username"];
        [UICKeyChainStore setString:password forKey:@"password"];
        [self performSegueWithIdentifier: @"loggedIn" sender: self];
    }
    
    
    
}
- (IBAction)loginButton:(id)sender
{
    username = usernameField.text;
    password = passwordField.text;
    
    [self attemtLogin];
    
}

- (IBAction)registerButton:(id)sender
{
    
    
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

@end
