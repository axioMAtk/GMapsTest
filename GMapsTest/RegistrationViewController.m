//
//  RegistrationViewController.m
//  GMapsTest
//
//  Created by Nate Lundie on 5/27/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
/**
 Allows the user to register an account, which will then be sent to our server for future logging in
 
 if the account is succesfully created it then takes them to the login screen, where they can use that shiny new login
 **/

#import "RegistrationViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize firstNameBox;
@synthesize lastNameBox;
@synthesize usernameBox;
@synthesize passwordBox;
@synthesize success;
@synthesize emailBox;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int) attemptLogin:(NSString *)usernamet withPass:(NSString *)passwordt withEmail:(NSString *)emailt withFirst:(NSString *)firstNt withLast:(NSString *)lastNt
{
    //NSInteger success = 0;
    success=0;
    //jsonArray = [[NSMutableArray alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"http://www.hikingnex.us/phpshizz/Register.php?u=%@&p=%@&e=%@&fn=%@&ln=%@", usernamet, passwordt, emailt, firstNt, lastNt];
    
    
    
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
    NSLog(@"result: %ld", (long)[jsonDic[@"result"] integerValue]);
    success = [jsonDic[@"result"] integerValue];
    return [jsonDic[@"result"] integerValue];
    
    //message = [jsonDic[@"message"] stringValue];
    
    
    
    
    
}
- (IBAction)buttonPressedf:(id)sender {
    [self.view endEditing:YES];
    if(usernameBox.hasText && passwordBox.hasText && emailBox.hasText && firstNameBox.hasText && lastNameBox.hasText)
    {
        [self attemptLogin:usernameBox.text withPass:passwordBox.text withEmail:emailBox.text withFirst:firstNameBox.text withLast:lastNameBox.text];
        if (success==1) {
                [self performSegueWithIdentifier:@"LogSegue" sender:self];
        }
        
    }
    else{
        [self.view makeToast:@"Please fill all fields"
                    duration:5
                    position:[NSValue valueWithCGPoint:CGPointMake(160, 200)]];
    }
    
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
