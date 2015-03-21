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
//@property (nonatomic, retain) NSString *someProperty;


// Data Manager Public Methods

- (BOOL) createItem: (Item *)item;

- (BOOL) createList: (List *)list;


@end
