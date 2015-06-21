//
//  DoneViewController.h
//  Done
//
//  Created by Franco Noack on 3/29/15.
//  Copyright (c) 2015 Franco Noack. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

// Table Views

@property (weak, nonatomic) IBOutlet UITableView *listTableView;

// Views

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIView *addListView;

// Labels

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *addListLabel;

// Buttons

@property (weak, nonatomic) IBOutlet UIButton *leftButton;

// Refresh Control

@property (strong, nonatomic) UIRefreshControl *refreshControl;

// Constraint

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addListConstraint;

@end
