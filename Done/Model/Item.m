//
//  Item.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "Item.h"
#import <Parse/PFObject+Subclass.h>

@implementation Item

@dynamic _id;
@dynamic listId;
@dynamic name;

@dynamic creationDate;
@dynamic done;
@dynamic deleted;

+ (void)load {
    
    [self registerSubclass];
    
}

+ (NSString *)parseClassName {
    
    return @"Item";
    
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
