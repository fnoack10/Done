//
//  Typography.m
//  Done
//
//  Created by Franco Noack on 6/20/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "Typography.h"

@implementation Typography

+ (UIFont *) lightOpenSans: (NSString *) type {
    
    if ([type isEqualToString:@"title"]) {
        
        return [UIFont fontWithName:@"OpenSans-Light" size:18];
        
    } else if ([type isEqualToString:@"text"]) {
        
        return [UIFont fontWithName:@"OpenSans-Light" size:16];
        
    } else if ([type isEqualToString:@"button"]) {
        
        return [UIFont fontWithName:@"OpenSans-Light" size:16];
        
    } else {
        
        return [UIFont fontWithName:@"OpenSans-Light" size:8];
        
    }

}

@end
