//
//  ErrorManager.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "ErrorManager.h"

#import <Parse/Parse.h>

@implementation ErrorManager

+ (void) showAlertWithDelegate:(id)delegate forError:(NSError *)error {

    
    if ([error code] == kPFErrorObjectNotFound) {
        NSLog(@"ERROR MANAGER - Uh oh, we couldn't find the object!");
    }
    
    NSLog(@"ERROR MESSAGE %@", [error.userInfo valueForKey:@"error"]);
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[error.userInfo valueForKey:@"error"]
                              delegate:delegate
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil,nil];
    
    [alertView show];
}

@end
