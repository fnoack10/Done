//
//  ViewController.m
//  Done
//
//  Created by Franco Noack on 3/21/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import "ViewController.h"

// Managers
#import "DataManager.h"

@interface ViewController () {
    
    DataManager *dataManager;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    dataManager = [DataManager sharedManager];
    
    Item *item = [Item object];
    item.name = @"First Item";

    [dataManager saveItem:item];
    
    List *list = [List object];
    list.name = @"First List";
    
    [dataManager saveList:list];
    
    PFQuery *query = [Item query];
    [query whereKey:@"name" notEqualTo:@"DO"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            NSLog(@"objects %@", objects);
            
            Item *firstArmor = [objects firstObject];
            
            NSLog(@"count %lu", (unsigned long)[objects count]);
            
            NSLog(@"first item %@", firstArmor);
            
            // ...
        }
    }];
    
    
    
    NSLog(@"QUERY %@", query);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
