//
//  NewHikeSegue.m
//  GMapsTest
//
//  Created by Chris Sutton on 5/16/14.
//  Copyright (c) 2014 Chris Sutton. All rights reserved.
//

#import "NewHikeSegue.h"

@implementation NewHikeSegue

-(void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self   destinationViewController] animated:NO];
}

@end
