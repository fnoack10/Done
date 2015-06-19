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

- (void) preloadUserData {
    
    PFUser *user = [PFUser currentUser];
    
    if (user) {
        
        NSLog(@"PreloadData");
        
        self.user = user;
        
        [self fetchUserData];
        
    }
    
}

- (void) loginWithUser: (NSString *)user andPassword: (NSString *)password {
    
    [PFUser logInWithUsernameInBackground:user password:password block:^(PFUser *user, NSError *error) {
        
        if (user) {
            
            self.user = user;
            
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
            
            self.user = [PFUser currentUser];

            [self loadUserData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
            
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:nil];
            
            [ErrorManager showAlertWithDelegate:self forError:error];
            
        }
    }];
}

- (void) giveAccessTo: (PFUser *)user forList: (List *)list {
    
    PFRelation *relation = [user relationForKey:@"hasAccess"];
    [relation addObject:list];
    
    [user saveInBackground];
    
}

- (void) addFriend: (PFUser *)user {
    
    NSLog(@"save user %@", user);
    
    PFRelation *relation = [self.user relationForKey:@"isFriend"];
    [relation addObject:user];
    
    [self.user saveInBackground];
    
}

- (void) addFriend: (PFUser *)user ToList: (List *)list {
    
    PFRelation *relation = [user relationForKey:@"hasAccessToList"];
    [relation addObject:list];
    
    [user saveInBackground];
    
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


- (void) deleteList: (List *)list {
    
    list.deleted = [NSNumber numberWithBool:YES];
    
    // TODO - DELETE ALL ITEMS IN LIST
    
    [list saveEventually];
    
    [self fetchUserData];
    
}

- (void) deleteItem: (Item *)item InList: (List *)list {
    
    item.deleted = [NSNumber numberWithBool:YES];
    
    [item saveEventually];
    
    [self fetchUserData];
    
}


- (void) loadUsers {
    
    [self getUsers].then(^(NSArray *users) {
        
        self.userArray = [users mutableCopy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (void) loadFriends {
    
    [self getFriends].then(^(NSArray *friends) {
        
        self.friendsArray = [friends mutableCopy];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateData" object:nil];
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (void) loadUserData {
    
    // TODO - Reachability
    
    NSLog(@"user %@", self.user);
    
    id lists = [self getLists];
    id items = [self getItems];
    
    [PMKPromise when:@[lists, items]].then(^(NSArray *results){
        
        [self fetchUserData];
        
        
    }).catch(^(NSError *error){
        
        [ErrorManager showAlertWithDelegate:self forError:error];
        
    });
    
}

- (void) fetchUserData {
    
    NSLog(@"FETCH USER DATA");
    
    [self fetchLists].then(^(NSArray *lists){
        
        // TODO - FIX SORT FUNCTION
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
        lists = [lists sortedArrayUsingDescriptors:@[sort]];
        
        self.listArray = [lists mutableCopy];
        
        NSMutableArray *listsWithItems = [[NSMutableArray alloc] init];
        
        for (List *list in lists) {
            
            id listWithItems = [self fetchItemsInList:list];
            [listsWithItems addObject:listWithItems];
            
        }
        
        return [PMKPromise when:listsWithItems];
        
    }).then(^(NSArray *itemsInLists) {
        
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
        [query whereKey:@"deleted" equalTo:[NSNumber numberWithBool:NO]];
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
        [query whereKey:@"deleted" equalTo:[NSNumber numberWithBool:NO]];
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

- (PMKPromise *) getFriends {
    
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
    
        PFRelation *relation = [self.user relationForKey:@"isFriend"];
        [[relation query] findObjectsInBackgroundWithBlock:^(NSArray *friends, NSError *error) {

            if (!error) {
                
                fulfill(friends);
                
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
