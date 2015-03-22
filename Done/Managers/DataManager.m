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

- (void) saveItem: (Item *)item {
    
    item.creationDate = [NSDate date];
    item.done = [NSNumber numberWithBool:NO];
    item.deleted = [NSNumber numberWithBool:NO];
    
    [item saveEventually];
    
}

- (void) saveList: (List *)list {
    
    list.creationDate = [NSDate date];
    list.done = [NSNumber numberWithBool:NO];
    list.deleted = [NSNumber numberWithBool:NO];

    [list saveEventually];
    
}

+ (NSString *) generateUID
{
    CFUUIDRef uidRef = CFUUIDCreate(NULL);
    CFStringRef uidStringRef = CFUUIDCreateString(NULL, uidRef);
    return (__bridge NSString *)uidStringRef;
}

@end
