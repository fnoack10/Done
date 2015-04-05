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

- (void) saveItem: (Item *)item forList: (List *)list {
    
    item[@"user"] = self.user;
    item[@"list"] = list;
    
    item.creationDate = [NSDate date];
    item.done = [NSNumber numberWithBool:NO];
    item.deleted = [NSNumber numberWithBool:NO];
    
    [item pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            NSInteger index = [self.listArray indexOfObject:list];
            
            [[self.itemsInListArray objectAtIndex:index] addObject:item];
            
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
        
        if (!error) {
            
            [self.listArray addObject:list];
            
            [self.itemsInListArray addObject:[[NSMutableArray alloc] init]];
            
            [list saveEventually];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
            
        } else {
            
            [ErrorManager showAlertWithDelegate:self forError:error];

        }
        
    }];

    
}

- (void) loadUsers {
    
    [self getUsers].then(^(NSArray *users) {
        
        self.userArray = [users mutableCopy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (void) loadUserData {
    
    self.user = [PFUser currentUser];
    
    [self fetchUserData];
    
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
    
    [self fetchLists].then(^(NSArray *lists){
        
        self.listArray = [lists mutableCopy];
        
        NSMutableArray *listsWithItems = [[NSMutableArray alloc] init];
        
        for (List *list in lists) {
            
            id listWithItems = [self fetchItemsInList:list];
            [listsWithItems addObject:listWithItems];
            
        }
        
        NSLog(@"lists %@", listsWithItems);
        
        return [PMKPromise when:listsWithItems];
        
    }).then(^(NSArray *itemsInLists) {
        
        NSLog(@"items %@", itemsInLists);
        
        self.itemsInListArray = [itemsInLists mutableCopy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (NSMutableArray *) itemsForList: (List *)list {
    
    NSInteger index = [self.listArray indexOfObject:list];
    
    return [self.itemsInListArray objectAtIndex:index];
    
}


- (PMKPromise *) fetchLists{
    
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

- (PMKPromise *) fetchItemsInList: (List *)list {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [Item query];
        [query fromLocalDatastore];
        [query whereKey:@"list" equalTo:list];
        [query findObjectsInBackgroundWithBlock:^(NSArray *lists, NSError *error) {
            
            if (!error) {
                
                fulfill([lists mutableCopy]);
                
            } else {
                
                reject(error);
                
            }
            
        }];
        
    }];
    
}


- (PMKPromise *) getUsers {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        
        PFQuery *query = [PFUser query];
        [query whereKey:@"email" notEqualTo:self.user.email];
        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
            
            if (!error) {
                
                fulfill(users);
                
            } else {
                
                reject(error);
                
            }
            
        }];
        
    }];
    
}

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
