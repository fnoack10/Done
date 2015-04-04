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
    
    [item pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [item saveEventually];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
            
        } else {
            
            [ErrorManager showAlertWithDelegate:self forError:error];
            
        }
        
    }];

    
}

- (void) saveList: (List *)list {
    
    list[@"user"] = self.user;
    
    list.creationDate = [NSDate date];
    list.done = [NSNumber numberWithBool:NO];
    list.deleted = [NSNumber numberWithBool:NO];
    
    [list pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
            [list saveEventually];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
            
        } else {
            
            [ErrorManager showAlertWithDelegate:self forError:error];

        }
        
    }];

    
}

- (void) loadUserData {
    
    self.user = [PFUser currentUser];
    
    // TODO - Reachability
    
    id lists = [self getLists];
    id items = [self getItems];
    
    [PMKPromise when:@[lists, items]].then(^(NSArray *results){
        
        [self fetchUserData];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (void) fetchUserData {
    
    self.user = [PFUser currentUser];
    
    id fetchLists = [self fetchLists];
    id fetchItems = [self fetchItems];
    
    [PMKPromise when:@[fetchLists, fetchItems]].then(^(NSArray *results){
        
        self.listArray = [[results objectAtIndex:0] mutableCopy];
        self.itemArray = [[results objectAtIndex:1] mutableCopy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (void) fetchItemsInList: (List *)list {
    
    PFQuery *query = [Item query];
    [query fromLocalDatastore];
    [query whereKey:@"list" equalTo:list];
    [query findObjectsInBackgroundWithBlock:^(NSArray *items, NSError *error) {
        
        if (!error) {
            
            self.itemsInListArray = [items mutableCopy];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
            
        } else {
            
            [ErrorManager showAlertWithDelegate:self forError:error];
            
        }
    }];
}

- (PMKPromise *) fetchLists {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [List query];
        [query fromLocalDatastore];
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




- (PMKPromise *) fetchItems {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [Item query];
        [query fromLocalDatastore];
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

//
//- (BFTask *) fetchItemsForList: (List *) list {
//    
//    PFQuery *query = [Item query];
//    [query fromLocalDatastore];
//    [query whereKey:@"list" equalTo:list];
//    
//    
//    BFTask *task = [query findObjectsInBackground];
//    
//    [task continueWithBlock:^id(BFTask *task) {
//        
//        if (!task.error) {
//            
//            [ErrorManager showAlertWithDelegate:self forError:task.error];
//            
//            return nil;
//            
//        } else {
//            
//            NSLog(@"Retrieved %@", (NSArray *)task.result);
//            
//            return task.result;
//        }
//        
//        
//    }];
//    
//    return task;
//    
//}


- (PMKPromise *) getLists {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [List query];
        [query whereKey:@"user" equalTo:self.user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *lists, NSError *error) {
                
            if (!error) {
                
                // TODO - Improve
                
                [List pinAllInBackground:lists block:^(BOOL succeeded, NSError *error) {
                    
                    if (!error) {
                        
                        fulfill(nil);
                        
                    } else {
                        
                        reject(error);
                        
                    }
                    
                }];

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
                
                // TODO - Improve
                
                [Item pinAllInBackground:items block:^(BOOL succeeded, NSError *error) {
                    
                    if (!error) {
                        
                        fulfill(nil);
                        
                    } else {
                        
                        reject(error);
                        
                    }
                    
                }];
                    
            } else {
                    
                reject(error);
                    
            }
                
        }];
        
    }];
    
}

@end
