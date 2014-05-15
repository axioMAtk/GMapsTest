//
//  DataViewController.h
//  GMapsTest
//
//  Created by Nate Lundie on 5/14/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) NSMutableArray* lastHike;
@property (strong, nonatomic) IBOutlet UIPickerView *hikePicker;
@property (strong, nonatomic) NSMutableString* dbString;



@end
