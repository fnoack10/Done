//
//  DataManager.h
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

// Model
#import "Item.h"
#import "List.h"

@interface DataManager : NSObject

// Singleton Init

+ (id)sharedManager;


// Properties

@property (nonatomic, retain) PFUser *user;

@property (nonatomic, retain) NSMutableArray *listArray;

@property (nonatomic, strong) NSMutableArray *itemArray;

// Data Manager Public Methods

- (void) loginWithUser: (NSString *)user andPassword: (NSString *)password;

- (void) signUpUser: (PFUser *)user;

- (void) loadUserData;

- (void) saveItem: (Item *)item;

- (void) saveList: (List *)list;


@end
