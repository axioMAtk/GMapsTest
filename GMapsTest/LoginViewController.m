//
//  LoginViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/22/14.
//  Copyright (c) 2014 Chris Sutton Nate Lundie. All rights reserved.
/**
 allows the user to input their username and password and attempt a login. If there is a username and password stored in the keychain it will attempt to login automagically, and the user won't even notice and will just be at the home screen of the app
 
 **/

#import "LoginViewController.h"
#import "Toast+UIView.h"

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


//initialize the view, and attempt a login if both username and password exist in the keychain
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[UICKeyChainStore setString:@"nlundie" forKey:@"username"];
    //[UICKeyChainStore setString:@"test" forKey:@"password"];
    //[UICKeyChainStore removeItemForKey:@"password"];
    //[UICKeyChainStore removeItemForKey:@"username"];
    // Do any additional setup after loading the view.
    if(!([UICKeyChainStore stringForKey:@"username"]==nil) && !([UICKeyChainStore stringForKey:@"password"]==nil))
    {
        username=[UICKeyChainStore stringForKey:@"username"];
        password=[UICKeyChainStore stringForKey:@"password"];
        [self attemptLogin:username withPass:password];
        if(success==1)
        {
            //[UICKeyChainStore setString:username forKey:@"username"];
            //[UICKeyChainStore setString:password forKey:@"password"];
            [self performSegueWithIdentifier: @"loggedIn" sender: self];
        }
        else{
        [UICKeyChainStore removeItemForKey:@"password"];
        }
    }
    if([UICKeyChainStore stringForKey:@"username"]!=nil)
    {
        usernameField.text=[UICKeyChainStore stringForKey:@"username"];
    }
    
    
    
    
    
}

//attempt a login with a given username and password
- (void) attemptLogin:(NSString *)usernamet withPass:(NSString *)passwordt
{
    //NSInteger success = 0;
    success=0;
    //jsonArray = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://www.hikingnex.us/phpshizz/Login.php?id=%@&p=%@", usernamet, passwordt];
    
    
    
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
    //message = [jsonDic[@"message"] stringValue];
    
    
    
    
    
}
- (IBAction)loginButton:(id)sender
{
    username = usernameField.text;
    password = passwordField.text;
    [self.view endEditing:YES];
    NSLog(@"success: %i", success);
   // NSLog(@"message: %i", message);
    
    
    [self attemptLogin:username withPass:password];
    
    if(success==1)
    {
        [UICKeyChainStore setString:username forKey:@"username"];
        [UICKeyChainStore setString:password forKey:@"password"];
        [self performSegueWithIdentifier: @"newLogIn" sender: self];
    }
    
    if(success==0)
    {
        usernameField.text=nil;
        passwordField.text=nil;
        [self.view makeToast:@"Invalid username, you might wanna go register"
                    duration:5
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 200)]];
    }
    if(success==2)
    {
        passwordField.text=nil;
       [self.view makeToast:@"Invalid Password!"
                    duration:5
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 200)]];
    }
    
}

//go to the registration view if you click the registration button
- (IBAction)registerButton:(id)sender
{
    [self performSegueWithIdentifier: @"RegistrationSegue" sender: self];
    
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
