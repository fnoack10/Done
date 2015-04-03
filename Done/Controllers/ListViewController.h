//
//  ListViewController.h
//  Done
//
//  Created by Franco Noack on 4/3/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

// Managers
#import "DataManager.h"

@interface ListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// List

@property (strong, nonatomic) List *list;

// Table Views

@property (weak, nonatomic) IBOutlet UITableView *itemTableView;

// Views

@property (weak, nonatomic) IBOutlet UIView *headerView;

// Labels

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Refresh Control

@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UIButton *rightButton;

// Actions

- (IBAction)letfAction:(UIButton *)sender;

- (IBAction)rightAction:(UIButton *)sender;

@end
