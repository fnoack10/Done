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

//+ (PFQuery *)query {
//    
//    PFQuery *query = [Item query];
//    
//    return query;
//    
//    
//    
////    [query whereKey:@"rupees" lessThanOrEqualTo:[PFUser currentUser][@"rupees"]];
////    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
////        if (!error) {
////            Armor *firstArmor = [objects firstObject];
////            // ...
////        }
////    }];
//    
//}

@end
