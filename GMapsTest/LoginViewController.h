//
//  LoginViewController.h
//  GMapsTest
//
//  Created by Nate Lundie on 5/22/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICKeyChainStore.h"
@import Security;

@interface LoginViewController : UIViewController
@property (nonatomic) NSInteger success;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* password;


@end
