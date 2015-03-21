//
//  ErrorManager.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "ErrorManager.h"

@implementation ErrorManager

+ (void) showAlertWithDelegate:(id)delegate forError:(NSError *)error {
    
    NSLog(@"ERROR USER INFO %@", error.userInfo);
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:[error valueForKey:@"error"]
                              delegate:delegate
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil,nil];
    
    [alertView show];
}

@end
