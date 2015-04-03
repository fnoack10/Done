//
//  DataManager.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "DataManager.h"

// Managers

#import "ErrorManager.h"

// Pods

#import <PromiseKit.h>


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


- (void) loginWithUser: (NSString *)user andPassword: (NSString *)password {
    
    [PFUser logInWithUsernameInBackground:user password:password block:^(PFUser *user, NSError *error) {
        
        if (user) {
            
            [self loadUserData];
            
            NSLog(@"login success");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
                                            
        } else {

            [ErrorManager showAlertWithDelegate:self forError:error];

        }
    
    }];
    
}

- (void) signUpUser: (PFUser *)user {
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {

            [self loadUserData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
            
        } else {
            
            [ErrorManager showAlertWithDelegate:self forError:error];
            
        }
    }];
}

- (void) saveItem: (Item *)item {
    
    item[@"user"] = self.user;
    
    item.creationDate = [NSDate date];
    item.done = [NSNumber numberWithBool:NO];
    item.deleted = [NSNumber numberWithBool:NO];
    
    [item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
            
        } else {
            
            [item saveEventually];
            
            // There was a problem, check error.description
        }
        
    }];
    
}

- (void) saveList: (List *)list {
    
    list[@"user"] = self.user;
    
    list.creationDate = [NSDate date];
    list.done = [NSNumber numberWithBool:NO];
    list.deleted = [NSNumber numberWithBool:NO];

    [list saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
            
        } else {
            
            [list saveEventually];
            
            // There was a problem, check error.description
        }
        
    }];
    
}

- (void) loadUserData {
    
    self.user = [PFUser currentUser];
    
    id lists = [self getLists];
    id items = [self getItems];
    
    [PMKPromise when:@[lists, items]].then(^(NSArray *results){
        
        self.listArray = [[results objectAtIndex:0] mutableCopy];
        self.itemArray = [[results objectAtIndex:1] mutableCopy];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:self];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}


- (PMKPromise *) getLists {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [List query];
        [query whereKey:@"user" equalTo:self.user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *lists, NSError *error) {
                
            if (!error) {
                    
                fulfill(lists);
                    
            } else {
                    
                reject(error);
                    
            }

        }];
        
    }];
    
}

- (PMKPromise *) getItems {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [Item query];
        [query whereKey:@"user" equalTo:self.user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
                
            if (!error) {
                
                fulfill(items);
                    
            } else {
                    
                reject(error);
                    
            }
                
        }];
        
    }];
    
}



@end
