//
//  DataManager.h
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Bolts/Bolts.h>

// Model
#import "Item.h"
#import "List.h"

@interface DataManager : NSObject

// Singleton Init

+ (id)sharedManager;


// Properties

@property (nonatomic, retain) PFUser *user;

@property (nonatomic, retain) NSMutableArray *listArray;

@property (nonatomic, strong) NSMutableArray *itemsInListArray;

@property (nonatomic, strong) NSMutableArray *userArray;

@property (nonatomic, strong) NSMutableArray *friendsArray;

// Data Manager Public Methods

- (void) preloadUserData;

- (void) loginWithUser: (NSString *)user andPassword: (NSString *)password;

- (void) signUpUser: (PFUser *)user;

- (void) loadUserData;

- (void) loadUsers;

- (void) loadFriends;

- (void) fetchUserData;

// Save

- (void) saveList: (List *)list;

- (void) saveItem: (Item *)item forList: (List *)list;

// Delete

- (void) deleteList: (List *)list;

- (void) deleteItem: (Item *)item InList: (List *)list;

// Friends

- (void) addFriend: (PFUser *) user;

- (void) addFriend: (PFUser *) user ToList: (List *)list;

// Getters

- (NSMutableArray *) itemsForList: (List *)list;


@end
