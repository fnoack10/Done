//
//  DataManager.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "DataManager.h"
#import "ErrorManager.h"

@implementation DataManager


+ (id)sharedManager {
    
    static DataManager *sharedDataManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedDataManager = [[self alloc] init];
        
    });
    
    return sharedDataManager;
}


- (id)init {
    if (self = [super init]) {
        
        
        
    }
    return self;
}

- (BOOL) createItem: (Item *)item {
    
//    // Add a relation between the Post with objectId "1zEcyElZ80" and the comment
//    myComment[@"parent"] = [PFObject objectWithoutDataWithClassName:@"Post" objectId:@"1zEcyElZ80"];
    
    __block BOOL result;
    
    Item *object = [Item object];
    
    object._id = [DataManager generateUID];  // NOT NECESSARY
    object.listId = item.listId;
    object.name = item.name;
    
    object.creationDate = [NSDate date];
    object.done = [NSNumber numberWithBool:NO];
    object.deleted = [NSNumber numberWithBool:NO];
    
    return result;
    
}

- (BOOL) createList: (List *)list {
    
    __block BOOL result;
    
    PFObject *object = [PFObject objectWithClassName:@"list"];
    
    object[@"_id"] = [DataManager generateUID];  // NOT NECESSARY
    object[@"name"] = list.name;
    
    object[@"creationDate"] = [NSDate date];
    object[@"done"] = [NSNumber numberWithBool:NO];
    object[@"deleted"] = [NSNumber numberWithBool:NO];
    
    [object saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            
            // The object has been saved.
            
            result = YES;
            
        } else {
            
            // There was a problem, check error.description
            
            [ErrorManager showAlertWithDelegate:self forError:error];
            
            result = NO;
            
        }
    }];
    
    return result;
    
}

+ (NSString *) generateUID
{
    CFUUIDRef uidRef = CFUUIDCreate(NULL);
    CFStringRef uidStringRef = CFUUIDCreateString(NULL, uidRef);
    return (__bridge NSString *)uidStringRef;
}

@end
