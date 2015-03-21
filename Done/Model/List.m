//
//  List.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "List.h"
#import <Parse/PFObject+Subclass.h>

@implementation List

@dynamic _id;
@dynamic name;

@dynamic creationDate;
@dynamic done;
@dynamic deleted;

+ (NSString *)parseClassName {
    
    return @"List";
    
}

+ (instancetype)objectWithoutDataWithObjectId:(NSString *)objectId {
    
    return nil;
    
}

+ (instancetype)object {
    
    return nil;
    
}

+ (PFQuery *)query {
    
    return nil;
    
}

+ (PFQuery *)queryWithPredicate:(NSPredicate *)predicate {
    
    return nil;
    
}

+ (void)registerSubclass {
    
}

@end
