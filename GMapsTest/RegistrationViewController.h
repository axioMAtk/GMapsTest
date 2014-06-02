//
//  RegistrationViewController.h
//  GMapsTest
//
//  Created by Nate Lundie on 5/27/14.
//  Copyright (c) 2014 Chris Sutton and Nate Lundie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Toast+UIView.h"

@interface RegistrationViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *firstNameBox;
@property (strong, nonatomic) IBOutlet UITextField *lastNameBox;
@property (strong, nonatomic) IBOutlet UITextField *usernameBox;
@property (strong, nonatomic) IBOutlet UITextField *emailBox;
@property (strong, nonatomic) IBOutlet UITextField *passwordBox;
@property (nonatomic) NSInteger success;

@end
